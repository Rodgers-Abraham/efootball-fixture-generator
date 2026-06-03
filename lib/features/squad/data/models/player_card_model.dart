import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:eFootClash/features/squad/domain/entities/player_card_entity.dart';

part 'player_card_model.freezed.dart';
part 'player_card_model.g.dart';

@freezed
class PlayerCardModel with _$PlayerCardModel {
  const PlayerCardModel._();

  const factory PlayerCardModel({
    @JsonKey(name: 'master_card_id') required String masterCardId,
    @JsonKey(name: 'player_name') required String playerName,
    @JsonKey(name: 'card_type') required String cardType,
    @JsonKey(name: 'max_rating') required int maxRating,
    @JsonKey(name: 'card_image_url') String? cardImageUrl,
  }) = _PlayerCardModel;

  factory PlayerCardModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerCardModelFromJson(json);

  factory PlayerCardModel.fromEntity(PlayerCardEntity entity) =>
      PlayerCardModel(
        masterCardId: entity.masterCardId,
        playerName: entity.playerName,
        cardType: entity.cardType,
        maxRating: entity.maxRating,
        cardImageUrl: entity.cardImageUrl,
      );

  PlayerCardEntity toEntity() => PlayerCardEntity(
    masterCardId: masterCardId,
    playerName: playerName,
    cardType: cardType,
    maxRating: maxRating,
    cardImageUrl: cardImageUrl,
  );
}
