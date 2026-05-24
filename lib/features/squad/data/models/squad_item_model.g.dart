// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'squad_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SquadItemModelImpl _$$SquadItemModelImplFromJson(Map<String, dynamic> json) =>
    _$SquadItemModelImpl(
      squadItemId: json['squad_item_id'] as String,
      userId: json['user_id'] as String,
      card: PlayerCardModel.fromJson(
        json['player_cards'] as Map<String, dynamic>,
      ),
      position: json['position'] as String,
      slotIndex: (json['slot_index'] as num).toInt(),
    );

Map<String, dynamic> _$$SquadItemModelImplToJson(
  _$SquadItemModelImpl instance,
) => <String, dynamic>{
  'squad_item_id': instance.squadItemId,
  'user_id': instance.userId,
  'player_cards': instance.card,
  'position': instance.position,
  'slot_index': instance.slotIndex,
};
