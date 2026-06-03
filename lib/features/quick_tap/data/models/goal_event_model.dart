import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:eFootClash/features/quick_tap/domain/entities/goal_event_entity.dart';

part 'goal_event_model.freezed.dart';
part 'goal_event_model.g.dart';

@freezed
class GoalEventModel with _$GoalEventModel {
  const GoalEventModel._();

  const factory GoalEventModel({
    required String id,
    @JsonKey(name: 'match_id') required String matchId,
    @JsonKey(name: 'squad_item_id') required String squadItemId,
    @JsonKey(name: 'event_type') required String eventType,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // Joined from squad_items -> player_cards -> users
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String playerName,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String teamTag,
  }) = _GoalEventModel;

  factory GoalEventModel.fromJson(Map<String, dynamic> json) =>
      _$GoalEventModelFromJson(json);

  GoalEventEntity toEntity() => GoalEventEntity(
    id: id,
    matchId: matchId,
    squadItemId: squadItemId,
    playerName: playerName,
    teamTag: teamTag,
    eventType: eventType,
    createdAt: createdAt,
  );
}
