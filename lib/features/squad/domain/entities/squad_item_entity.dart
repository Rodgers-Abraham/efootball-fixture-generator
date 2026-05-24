import 'package:freezed_annotation/freezed_annotation.dart';
import 'player_card_entity.dart';

part 'squad_item_entity.freezed.dart';

@freezed
class SquadItemEntity with _$SquadItemEntity {
  const factory SquadItemEntity({
    required String squadItemId,
    required String userId,
    required PlayerCardEntity card,
    required String position,
    required int slotIndex,
  }) = _SquadItemEntity;
}
