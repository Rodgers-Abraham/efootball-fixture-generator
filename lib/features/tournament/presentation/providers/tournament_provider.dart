import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eFootClash/core/errors/failures.dart';
import 'package:eFootClash/core/utils/supabase_client.dart';
import 'package:eFootClash/features/auth/presentation/providers/auth_provider.dart';
import 'package:eFootClash/features/tournament/data/datasources/tournament_remote_datasource.dart';
import 'package:eFootClash/features/tournament/data/repositories/tournament_repository_impl.dart';
import 'package:eFootClash/features/tournament/domain/entities/bracket_entity.dart';
import 'package:eFootClash/features/tournament/domain/entities/match_entity.dart';
import 'package:eFootClash/features/tournament/domain/entities/tournament_entity.dart';
import 'package:eFootClash/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:eFootClash/features/tournament/domain/usecases/generate_fixtures_usecase.dart';

// ── Infrastructure ─────────────────────────────────────────────
final tournamentRemoteDatasourceProvider = Provider<TournamentRemoteDatasource>(
  (ref) {
    final client = ref.watch(supabaseClientProvider);
    return TournamentRemoteDatasourceImpl(client);
  },
);

final tournamentRepositoryProvider = Provider<TournamentRepository>((ref) {
  final ds = ref.watch(tournamentRemoteDatasourceProvider);
  return TournamentRepositoryImpl(ds);
});

final generateFixturesUseCaseProvider = Provider<GenerateFixturesUseCase>(
  (_) => GenerateFixturesUseCase(),
);

// ── Tournament list ────────────────────────────────────────────
final tournamentListProvider =
    AsyncNotifierProvider<TournamentListNotifier, List<TournamentEntity>>(
      TournamentListNotifier.new,
    );

class TournamentListNotifier extends AsyncNotifier<List<TournamentEntity>> {
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

    final result = await repo.createTournament(
      name: name,
      format: format,
      createdBy: user.id,
      participantIds: participantIds,
    );

    return result.fold((_) => null, (tournament) async {
      // NOTE: Fixtures are NO LONGER generated here.
      // They will be generated when the creator taps 'START'.

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
    String code,
  ) async {
    final user = ref.read(authNotifierProvider).valueOrNull;
    if (user == null) return (tournament: null, error: 'Not logged in');
    final repo = ref.read(tournamentRepositoryProvider);
    final result = await repo.joinByCode(code: code, userId: user.id);
    return result.fold((f) => (tournament: null, error: f.displayMessage), (t) {
      ref.invalidateSelf();
      return (tournament: t, error: null);
    });
  }

  Future<bool> startTournament(String tournamentId) async {
    final repo = ref.read(tournamentRepositoryProvider);
    final generateUseCase = ref.read(generateFixturesUseCaseProvider);

    // 1. Fetch latest tournament data
    final tournamentResult = await repo.getTournament(tournamentId);
    return tournamentResult.fold((_) => false, (tournament) async {
      if (tournament.status != 'pending') return false;

      // 2. Generate fixtures based on current participants
      final rounds = generateUseCase(
        tournamentId: tournament.id,
        format: tournament.format,
        participantIds: tournament.participantIds,
      );
      final allMatches = rounds.expand((r) => r).toList();

      // 3. Save matches and update status
      await repo.saveMatches(allMatches);
      await repo.updateTournamentStatus(id: tournamentId, status: 'active');

      ref.invalidateSelf();
      return true;
    });
  }
}

// ── Single tournament ──────────────────────────────────────────
final tournamentProvider = FutureProvider.autoDispose
    .family<TournamentEntity?, String>((ref, id) async {
      final repo = ref.watch(tournamentRepositoryProvider);
      final result = await repo.getTournament(id);
      return result.fold((_) => null, (t) => t);
    });

// ── Bracket ────────────────────────────────────────────────────
final bracketProvider = FutureProvider.autoDispose
    .family<BracketEntity?, String>((ref, tournamentId) async {
      final repo = ref.watch(tournamentRepositoryProvider);
      final result = await repo.getBracket(tournamentId);
      return result.fold((_) => null, (b) => b);
    });

// ── Matches for a tournament ───────────────────────────────────
final matchesProvider = FutureProvider.autoDispose
    .family<List<MatchEntity>, String>((ref, tournamentId) async {
      final repo = ref.watch(tournamentRepositoryProvider);
      final result = await repo.getMatches(tournamentId);
      return result.fold((_) => [], (m) => m);
    });

// ── Single match ───────────────────────────────────────────────
final matchProvider = FutureProvider.autoDispose.family<MatchEntity?, String>((
  ref,
  matchId,
) async {
  final repo = ref.watch(tournamentRepositoryProvider);
  final result = await repo.getMatch(matchId);
  return result.fold((_) => null, (m) => m);
});

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

final standingsProvider = FutureProvider.autoDispose
    .family<List<StandingEntry>, String>((ref, tournamentId) async {
      final repo = ref.watch(tournamentRepositoryProvider);
      final result = await repo.getMatches(tournamentId);
      final matches = result.fold<List<MatchEntity>>(
        (_) => <MatchEntity>[],
        (m) => m,
      );

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

        // Fixed unnecessary_cast
        final hg = m.homeScore ?? 0;
        final ag = m.awayScore ?? 0;

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
    });
