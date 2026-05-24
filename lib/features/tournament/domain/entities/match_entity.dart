import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_entity.freezed.dart';

@freezed
class MatchEntity with _$MatchEntity {
  const factory MatchEntity({
    required String id,
    required String tournamentId,
    required int round,
    required int matchNumber,
    String? homeUserId,
    String? awayUserId,
    String? homeUsername,
    String? awayUsername,
    String? homeTeamTag,
    String? awayTeamTag,
    int? homeScore,
    int? awayScore,
    int? homePossession,
    int? awayPossession,
    int? homeShots,
    int? awayShots,
    int? homeShotsOnTarget,
    int? awayShotsOnTarget,
    int? homeFouls,
    int? awayFouls,
    @Default('scheduled') String status,
    DateTime? playedAt,
    DateTime? createdAt,
  }) = _MatchEntity;
}
