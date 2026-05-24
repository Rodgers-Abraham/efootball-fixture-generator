// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoalEventModelImpl _$$GoalEventModelImplFromJson(Map<String, dynamic> json) =>
    _$GoalEventModelImpl(
      id: json['id'] as String,
      matchId: json['match_id'] as String,
      squadItemId: json['squad_item_id'] as String,
      eventType: json['event_type'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$GoalEventModelImplToJson(
  _$GoalEventModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'match_id': instance.matchId,
  'squad_item_id': instance.squadItemId,
  'event_type': instance.eventType,
  'created_at': instance.createdAt?.toIso8601String(),
};
