import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_card_entity.freezed.dart';

@freezed
class PlayerCardEntity with _$PlayerCardEntity {
  const factory PlayerCardEntity({
    required String masterCardId,
    required String playerName,
    required String cardType,
    required int maxRating,
    String? cardImageUrl,
  }) = _PlayerCardEntity;
}
