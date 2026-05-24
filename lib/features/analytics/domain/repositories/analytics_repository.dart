import 'package:dartz/dartz.dart';
import 'package:efootball_fixture_generator/core/errors/failures.dart';
import 'package:efootball_fixture_generator/features/analytics/domain/entities/leaderboard_entry_entity.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, List<LeaderboardEntryEntity>>> getGoldenBoot(
      String tournamentId);

  Future<Either<Failure, List<LeaderboardEntryEntity>>> getMotmLeaderboard(
      String tournamentId);
}
