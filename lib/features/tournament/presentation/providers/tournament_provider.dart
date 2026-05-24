import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:efootball_fixture_generator/core/errors/failures.dart';
import 'package:efootball_fixture_generator/core/utils/supabase_client.dart';
import 'package:efootball_fixture_generator/features/auth/presentation/providers/auth_provider.dart';
import 'package:efootball_fixture_generator/features/tournament/data/datasources/tournament_remote_datasource.dart';
import 'package:efootball_fixture_generator/features/tournament/data/repositories/tournament_repository_impl.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/entities/bracket_entity.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/entities/match_entity.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/entities/tournament_entity.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/usecases/generate_fixtures_usecase.dart';

// ── Infrastructure ─────────────────────────────────────────────
final tournamentRemoteDatasourceProvider =
    Provider<TournamentRemoteDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TournamentRemoteDatasourceImpl(client);
});

final tournamentRepositoryProvider = Provider<TournamentRepository>((ref) {
  final ds = ref.watch(tournamentRemoteDatasourceProvider);
  return TournamentRepositoryImpl(ds);
});

final generateFixturesUseCaseProvider =
    Provider<GenerateFixturesUseCase>((_) => GenerateFixturesUseCase());

// ── Tournament list ────────────────────────────────────────────
final tournamentListProvider =
    AsyncNotifierProvider<TournamentListNotifier, List<TournamentEntity>>(
        TournamentListNotifier.new);

class TournamentListNotifier
    extends AsyncNotifier<List<TournamentEntity>> {
  @override
  Future<List<TournamentEntity>> build() async {
    final repo = ref.watch(tournamentRepositoryProvider);
    final result = await repo.getTournaments();
    return result.fold((_) => [], (list) => list);
  }

  Future<TournamentEntity?> createTournament({
    required String name,
    required String format,
    required List<String> participantIds,
  }) async {
    final user = ref.read(authNotifierProvider).valueOrNull;
    if (user == null) return null;

    final repo = ref.read(tournamentRepositoryProvider);
    final generateUseCase = ref.read(generateFixturesUseCaseProvider);

    final result = await repo.createTournament(
      name: name,
      format: format,
      createdBy: user.id,
      participantIds: participantIds,
    );

    return result.fold((_) => null, (tournament) async {
      // Generate and save fixtures
      final rounds = generateUseCase(
        tournamentId: tournament.id,
        format: format,
        participantIds: participantIds,
      );
      final allMatches = rounds.expand((r) => r).toList();
      await repo.saveMatches(allMatches);

      // Update status to active
      await repo.updateTournamentStatus(
        id: tournament.id,
        status: 'active',
      );

      ref.invalidateSelf();
      return tournament;
    });
  }

  Future<void> deleteTournament(String id) async {
    final repo = ref.read(tournamentRepositoryProvider);
    await repo.deleteTournament(id);
    ref.invalidateSelf();
  }

  Future<({TournamentEntity? tournament, String? error})> joinByCode(
      String code) async {
    final user = ref.read(authNotifierProvider).valueOrNull;
    if (user == null) return (tournament: null, error: 'Not logged in');
    final repo = ref.read(tournamentRepositoryProvider);
    final result = await repo.joinByCode(code: code, userId: user.id);
    return result.fold(
      (f) => (tournament: null, error: f.displayMessage),
      (t) {
        ref.invalidateSelf();
        return (tournament: t, error: null);
      },
    );
  }
}

// ── Single tournament ──────────────────────────────────────────
final tournamentProvider =
    FutureProvider.autoDispose.family<TournamentEntity?, String>(
  (ref, id) async {
    final repo = ref.watch(tournamentRepositoryProvider);
    final result = await repo.getTournament(id);
    return result.fold((_) => null, (t) => t);
  },
);

// ── Bracket ────────────────────────────────────────────────────
final bracketProvider =
    FutureProvider.autoDispose.family<BracketEntity?, String>(
  (ref, tournamentId) async {
    final repo = ref.watch(tournamentRepositoryProvider);
    final result = await repo.getBracket(tournamentId);
    return result.fold((_) => null, (b) => b);
  },
);

// ── Matches for a tournament ───────────────────────────────────
final matchesProvider =
    FutureProvider.autoDispose.family<List<MatchEntity>, String>(
  (ref, tournamentId) async {
    final repo = ref.watch(tournamentRepositoryProvider);
    final result = await repo.getMatches(tournamentId);
    return result.fold((_) => [], (m) => m);
  },
);

// ── Single match ───────────────────────────────────────────────
final matchProvider =
    FutureProvider.autoDispose.family<MatchEntity?, String>(
  (ref, matchId) async {
    final repo = ref.watch(tournamentRepositoryProvider);
    final result = await repo.getMatch(matchId);
    return result.fold((_) => null, (m) => m);
  },
);

// ── Standings (round-robin) ────────────────────────────────────
class StandingEntry {
  final String userId;
  final String username;
  final String teamTag;
  int played = 0;
  int wins = 0;
  int draws = 0;
  int losses = 0;
  int goalsFor = 0;
  int goalsAgainst = 0;

  StandingEntry({
    required this.userId,
    required this.username,
    required this.teamTag,
  });

  int get points => wins * 3 + draws;
  int get goalDifference => goalsFor - goalsAgainst;
}

final standingsProvider =
    FutureProvider.autoDispose.family<List<StandingEntry>, String>(
  (ref, tournamentId) async {
    final repo = ref.watch(tournamentRepositoryProvider);
    final result = await repo.getMatches(tournamentId);
    final matches = result.fold<List<MatchEntity>>(
        (_) => <MatchEntity>[], (m) => m);

    final table = <String, StandingEntry>{};

    void ensure(String? userId, String? username, String? teamTag) {
      if (userId == null) return;
      table.putIfAbsent(
        userId,
        () => StandingEntry(
          userId: userId,
          username: username ?? userId,
          teamTag: teamTag ?? '???',
        ),
      );
    }

    for (final m in matches) {
      if (m.status != 'completed') continue;
      ensure(m.homeUserId, m.homeUsername, m.homeTeamTag);
      ensure(m.awayUserId, m.awayUsername, m.awayTeamTag);

      final home = table[m.homeUserId];
      final away = table[m.awayUserId];
      if (home == null || away == null) continue;

      final int hg = (m.homeScore ?? 0) as int;
      final int ag = (m.awayScore ?? 0) as int;

      home.played++;
      away.played++;
      home.goalsFor = home.goalsFor + hg;
      home.goalsAgainst = home.goalsAgainst + ag;
      away.goalsFor = away.goalsFor + ag;
      away.goalsAgainst = away.goalsAgainst + hg;

      if (hg > ag) {
        home.wins++;
        away.losses++;
      } else if (ag > hg) {
        away.wins++;
        home.losses++;
      } else {
        home.draws++;
        away.draws++;
      }
    }

    final standings = table.values.toList()
      ..sort((a, b) {
        final pts = b.points.compareTo(a.points);
        if (pts != 0) return pts;
        final gd = b.goalDifference.compareTo(a.goalDifference);
        if (gd != 0) return gd;
        return b.goalsFor.compareTo(a.goalsFor);
      });

    return standings;
  },
);
