import 'package:dartz/dartz.dart';
import 'package:efootball_fixture_generator/core/constants/app_constants.dart';
import 'package:efootball_fixture_generator/core/errors/failures.dart';
import 'package:efootball_fixture_generator/features/quick_tap/data/datasources/quick_tap_remote_datasource.dart';
import 'package:efootball_fixture_generator/features/quick_tap/domain/entities/goal_event_entity.dart';
import 'package:efootball_fixture_generator/features/quick_tap/domain/repositories/quick_tap_repository.dart';

class QuickTapRepositoryImpl implements QuickTapRepository {
  final QuickTapRemoteDatasource _datasource;

  QuickTapRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, GoalEventEntity>> logGoal({
    required String matchId,
    required String squadItemId,
  }) async {
    try {
      final model = await _datasource.logEvent(
        matchId: matchId,
        squadItemId: squadItemId,
        eventType: AppConstants.eventGoal,
      );
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GoalEventEntity>> logMotm({
    required String matchId,
    required String squadItemId,
  }) async {
    try {
      final model = await _datasource.logEvent(
        matchId: matchId,
        squadItemId: squadItemId,
        eventType: AppConstants.eventMotm,
      );
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearEventsForMatch(String matchId) async {
    try {
      await _datasource.clearEventsForMatch(matchId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> finalizeMatch(String matchId) async {
    try {
      await _datasource.finalizeMatch(matchId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }
}
