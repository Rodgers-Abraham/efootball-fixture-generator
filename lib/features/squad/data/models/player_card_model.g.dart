// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerCardModelImpl _$$PlayerCardModelImplFromJson(
  Map<String, dynamic> json,
) => _$PlayerCardModelImpl(
  masterCardId: json['master_card_id'] as String,
  playerName: json['player_name'] as String,
  cardType: json['card_type'] as String,
  maxRating: (json['max_rating'] as num).toInt(),
  cardImageUrl: json['card_image_url'] as String?,
);

Map<String, dynamic> _$$PlayerCardModelImplToJson(
  _$PlayerCardModelImpl instance,
) => <String, dynamic>{
  'master_card_id': instance.masterCardId,
  'player_name': instance.playerName,
  'card_type': instance.cardType,
  'max_rating': instance.maxRating,
  'card_image_url': instance.cardImageUrl,
};
