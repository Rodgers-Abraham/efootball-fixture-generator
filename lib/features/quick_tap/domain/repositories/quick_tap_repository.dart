import 'package:dartz/dartz.dart';
import 'package:eFootClash/core/errors/failures.dart';
import 'package:eFootClash/features/quick_tap/domain/entities/goal_event_entity.dart';

abstract class QuickTapRepository {
  Future<Either<Failure, GoalEventEntity>> logGoal({
    required String matchId,
    required String squadItemId,
  });

  Future<Either<Failure, GoalEventEntity>> logMotm({
    required String matchId,
    required String squadItemId,
  });

  Future<Either<Failure, Unit>> clearEventsForMatch(String matchId);

  Future<Either<Failure, Unit>> finalizeMatch(String matchId);
}
