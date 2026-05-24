import 'package:flutter_test/flutter_test.dart';
import 'package:efootball_fixture_generator/core/constants/app_constants.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/usecases/generate_fixtures_usecase.dart';

void main() {
  late GenerateFixturesUseCase useCase;
  const tournamentId = 'test-tournament';

  setUp(() {
    useCase = GenerateFixturesUseCase();
  });

  group('GenerateFixturesUseCase - Round Robin', () {
    test('should generate 1 round for 2 teams', () {
      final participants = ['user1', 'user2'];
      final rounds = useCase(
        tournamentId: tournamentId,
        format: AppConstants.formatRoundRobin,
        participantIds: participants,
      );

      expect(rounds.length, 1);
      expect(rounds[0].length, 1);
      expect(rounds[0][0].homeUserId, 'user1');
      expect(rounds[0][0].awayUserId, 'user2');
    });

    test('should generate 3 rounds for 4 teams', () {
      final participants = ['u1', 'u2', 'u3', 'u4'];
      final rounds = useCase(
        tournamentId: tournamentId,
        format: AppConstants.formatRoundRobin,
        participantIds: participants,
      );

      expect(rounds.length, 3);
      for (var round in rounds) {
        expect(round.length, 2);
      }
    });

    test('should handle odd number of teams with byes', () {
      final participants = ['u1', 'u2', 'u3'];
      final rounds = useCase(
        tournamentId: tournamentId,
        format: AppConstants.formatRoundRobin,
        participantIds: participants,
      );

      // 3 teams -> 4 virtual teams -> 3 rounds
      expect(rounds.length, 3);
      for (var round in rounds) {
        expect(round.length, 1); // Each round has 1 match, 1 team has a bye
      }
    });
  });

  group('GenerateFixturesUseCase - Single Elimination', () {
    test('should generate correct rounds for power-of-two participants (4)', () {
      final participants = ['u1', 'u2', 'u3', 'u4'];
      final rounds = useCase(
        tournamentId: tournamentId,
        format: AppConstants.formatSingleElimination,
        participantIds: participants,
      );

      // Round 1: 2 matches, Round 2: 1 match (Final)
      expect(rounds.length, 2);
      expect(rounds[0].length, 2);
      expect(rounds[1].length, 1);
      expect(rounds[1][0].homeUserId, isNull);
      expect(rounds[1][0].awayUserId, isNull);
    });

    test('should pad with byes for non-power-of-two (3 teams)', () {
      final participants = ['u1', 'u2', 'u3'];
      final rounds = useCase(
        tournamentId: tournamentId,
        format: AppConstants.formatSingleElimination,
        participantIds: participants,
      );

      // 3 teams pads to 4. 
      // Round 1: 2 matches
      expect(rounds.length, 2);
      expect(rounds[0].length, 2);
      final hasBye = rounds[0].any((m) => m.homeUserId == null || m.awayUserId == null);
      expect(hasBye, true);
    });
  });

  group('GenerateFixturesUseCase - Double Elimination', () {
    test('should generate structure including losers bracket and grand final', () {
      final participants = ['u1', 'u2', 'u3', 'u4'];
      final rounds = useCase(
        tournamentId: tournamentId,
        format: AppConstants.formatDoubleElimination,
        participantIds: participants,
      );

      expect(rounds.length, 4);
      expect(rounds.last.length, 1);
      expect(rounds.last[0].id, 'grand_final');
    });
  });
}
