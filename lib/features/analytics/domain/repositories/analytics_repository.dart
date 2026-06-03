import 'package:dartz/dartz.dart';
import 'package:eFootClash/core/errors/failures.dart';
import 'package:eFootClash/features/analytics/domain/entities/leaderboard_entry_entity.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, List<LeaderboardEntryEntity>>> getGoldenBoot(
    String tournamentId,
  );

  Future<Either<Failure, List<LeaderboardEntryEntity>>> getMotmLeaderboard(
    String tournamentId,
  );
}
