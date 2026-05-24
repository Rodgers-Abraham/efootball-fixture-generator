import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_stats_entity.freezed.dart';

@freezed
class MatchStatsEntity with _$MatchStatsEntity {
  const factory MatchStatsEntity({
    required int homeScore,
    required int awayScore,
    int? homePossession,
    int? awayPossession,
    int? homeShots,
    int? awayShots,
    int? homeShotsOnTarget,
    int? awayShotsOnTarget,
    int? homeFouls,
    int? awayFouls,
    @Default(0.0) double confidence,
  }) = _MatchStatsEntity;
}
