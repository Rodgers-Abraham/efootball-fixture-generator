import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_event_entity.freezed.dart';

@freezed
class GoalEventEntity with _$GoalEventEntity {
  const factory GoalEventEntity({
    required String id,
    required String matchId,
    required String squadItemId,
    required String playerName,
    required String teamTag,
    required String eventType,
    DateTime? createdAt,
  }) = _GoalEventEntity;
}
