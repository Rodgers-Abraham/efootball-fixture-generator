import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:efootball_fixture_generator/features/squad/data/models/player_card_model.dart';
import 'package:efootball_fixture_generator/features/squad/domain/entities/squad_item_entity.dart';

part 'squad_item_model.freezed.dart';
part 'squad_item_model.g.dart';

@freezed
class SquadItemModel with _$SquadItemModel {
  const SquadItemModel._();

  const factory SquadItemModel({
    @JsonKey(name: 'squad_item_id') required String squadItemId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'player_cards') required PlayerCardModel card,
    required String position,
    @JsonKey(name: 'slot_index') required int slotIndex,
  }) = _SquadItemModel;

  factory SquadItemModel.fromJson(Map<String, dynamic> json) =>
      _$SquadItemModelFromJson(json);

  SquadItemEntity toEntity() => SquadItemEntity(
        squadItemId: squadItemId,
        userId: userId,
        card: card.toEntity(),
        position: position,
        slotIndex: slotIndex,
      );
}
