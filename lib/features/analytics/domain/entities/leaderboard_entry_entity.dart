import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_entry_entity.freezed.dart';

@freezed
class LeaderboardEntryEntity with _$LeaderboardEntryEntity {
  const factory LeaderboardEntryEntity({
    required int rank,
    required String playerName,
    required String teamTag,
    required String cardType,
    @Default(0) int goals,
    @Default(0) int motmCount,
    String? cardImageUrl,
    String? squadItemId,
  }) = _LeaderboardEntryEntity;
}
