import 'package:eFootClash/core/constants/app_constants.dart';
import 'package:eFootClash/features/tournament/domain/entities/match_entity.dart';

/// Pure Dart bracket generation — no external dependencies.
class GenerateFixturesUseCase {
  /// Returns a list of rounds; each round is a list of [MatchEntity].
  /// Pass real UUIDs for [tournamentId]; match IDs are temporary
  /// placeholders until the records are inserted into the DB.
  List<List<MatchEntity>> call({
    required String tournamentId,
    required String format,
    required List<String> participantIds,
  }) {
    if (participantIds.length < 2) return [];

    switch (format) {
      case AppConstants.formatSingleElimination:
        return _singleElimination(tournamentId, participantIds);
      case AppConstants.formatDoubleElimination:
        return _doubleElimination(tournamentId, participantIds);
      case AppConstants.formatRoundRobin:
      default:
        return _roundRobin(tournamentId, participantIds);
    }
  }

  // ── Single elimination ─────────────────────────────────────────
  List<List<MatchEntity>> _singleElimination(
    String tournamentId,
    List<String> participants,
  ) {
    final seeded = List<String?>.from(participants);

    // Pad to next power of two with null (bye)
    final bracketSize = _nextPowerOfTwo(seeded.length);
    while (seeded.length < bracketSize) {
      seeded.add(null);
    }

    final rounds = <List<MatchEntity>>[];
    List<String?> current = seeded;
    int roundNum = 1;

    while (current.length > 1) {
      final round = <MatchEntity>[];
      final next = <String?>[];

      for (int i = 0; i < current.length; i += 2) {
        final home = current[i];
        final away = current[i + 1];
        final matchNum = round.length + 1;

        round.add(
          MatchEntity(
            id: 'r${roundNum}_m$matchNum',
            tournamentId: tournamentId,
            round: roundNum,
            matchNumber: matchNum,
            homeUserId: home,
            awayUserId: away,
            status: AppConstants.matchScheduled,
          ),
        );

        // Winner placeholder (null means TBD)
        next.add(null);
      }

      rounds.add(round);
      current = next;
      roundNum++;
    }

    return rounds;
  }

  // ── Double elimination ─────────────────────────────────────────
  List<List<MatchEntity>> _doubleElimination(
    String tournamentId,
    List<String> participants,
  ) {
    // Generate winners bracket then add a losers bracket skeleton
    final winnerRounds = _singleElimination(tournamentId, participants);
    final loserMatches = <MatchEntity>[];

    // Losers bracket: one match per round of the winners bracket (simplified)
    for (int r = 0; r < winnerRounds.length - 1; r++) {
      loserMatches.add(
        MatchEntity(
          id: 'losers_r${r + 1}_m1',
          tournamentId: tournamentId,
          round: r + 1,
          matchNumber: winnerRounds[r].length + 1,
          homeUserId: null,
          awayUserId: null,
          status: AppConstants.matchScheduled,
        ),
      );
    }

    // Grand final
    final grandFinalRound = winnerRounds.length + 1;
    final grandFinal = MatchEntity(
      id: 'grand_final',
      tournamentId: tournamentId,
      round: grandFinalRound,
      matchNumber: 1,
      homeUserId: null,
      awayUserId: null,
      status: AppConstants.matchScheduled,
    );

    return [
      ...winnerRounds,
      loserMatches,
      [grandFinal],
    ];
  }

  // ── Round robin ────────────────────────────────────────────────
  List<List<MatchEntity>> _roundRobin(
    String tournamentId,
    List<String> participants,
  ) {
    final n = participants.length;
    final list = List<String>.from(participants);

    // Use circle method; if odd add a dummy bye
    final hasBye = n % 2 != 0;
    if (hasBye) list.add('BYE');

    final totalTeams = list.length;
    final totalRounds = totalTeams - 1;
    final matchesPerRound = totalTeams ~/ 2;
    final rounds = <List<MatchEntity>>[];

    final rotation = List<String>.from(list);

    for (int r = 0; r < totalRounds; r++) {
      final round = <MatchEntity>[];

      for (int m = 0; m < matchesPerRound; m++) {
        final home = rotation[m];
        final away = rotation[totalTeams - 1 - m];

        if (home == 'BYE' || away == 'BYE') continue;

        round.add(
          MatchEntity(
            id: 'rr_r${r + 1}_m${m + 1}',
            tournamentId: tournamentId,
            round: r + 1,
            matchNumber: m + 1,
            homeUserId: home,
            awayUserId: away,
            status: AppConstants.matchScheduled,
          ),
        );
      }

      rounds.add(round);

      // Rotate: keep first element fixed, rotate the rest
      final fixed = rotation[0];
      final rest = [...rotation.sublist(1)];
      rest.insert(0, rest.removeLast());
      rotation.setRange(0, 1, [fixed]);
      rotation.setRange(1, rotation.length, rest);
    }

    return rounds;
  }

  int _nextPowerOfTwo(int n) {
    int p = 1;
    while (p < n) {
      p <<= 1;
    }
    return p;
  }
}
