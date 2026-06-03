import 'package:dartz/dartz.dart';
import 'package:eFootClash/core/errors/failures.dart';
import 'package:eFootClash/features/analytics/data/datasources/analytics_remote_datasource.dart';
import 'package:eFootClash/features/analytics/domain/entities/leaderboard_entry_entity.dart';
import 'package:eFootClash/features/analytics/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDatasource _datasource;

  AnalyticsRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<LeaderboardEntryEntity>>> getGoldenBoot(
    String tournamentId,
  ) async {
    try {
      final entries = await _datasource.getGoldenBoot(tournamentId);
      return Right(entries);
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LeaderboardEntryEntity>>> getMotmLeaderboard(
    String tournamentId,
  ) async {
    try {
      final entries = await _datasource.getMotmLeaderboard(tournamentId);
      return Right(entries);
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }
}
