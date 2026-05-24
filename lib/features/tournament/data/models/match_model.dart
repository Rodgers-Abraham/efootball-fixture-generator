import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/entities/match_entity.dart';

part 'match_model.freezed.dart';
part 'match_model.g.dart';

@freezed
class MatchModel with _$MatchModel {
  const MatchModel._();

  const factory MatchModel({
    required String id,
    @JsonKey(name: 'tournament_id') required String tournamentId,
    required int round,
    @JsonKey(name: 'match_number') required int matchNumber,
    @JsonKey(name: 'home_user_id') String? homeUserId,
    @JsonKey(name: 'away_user_id') String? awayUserId,
    @JsonKey(name: 'home_score') int? homeScore,
    @JsonKey(name: 'away_score') int? awayScore,
    @JsonKey(name: 'home_possession') int? homePossession,
    @JsonKey(name: 'away_possession') int? awayPossession,
    @JsonKey(name: 'home_shots') int? homeShots,
    @JsonKey(name: 'away_shots') int? awayShots,
    @JsonKey(name: 'home_shots_on_target') int? homeShotsOnTarget,
    @JsonKey(name: 'away_shots_on_target') int? awayShotsOnTarget,
    @JsonKey(name: 'home_fouls') int? homeFouls,
    @JsonKey(name: 'away_fouls') int? awayFouls,
    @Default('scheduled') String status,
    @JsonKey(name: 'played_at') DateTime? playedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // Joined fields from users table (not stored in matches table)
    @JsonKey(includeFromJson: false, includeToJson: false) String? homeUsername,
    @JsonKey(includeFromJson: false, includeToJson: false) String? awayUsername,
    @JsonKey(includeFromJson: false, includeToJson: false) String? homeTeamTag,
    @JsonKey(includeFromJson: false, includeToJson: false) String? awayTeamTag,
  }) = _MatchModel;

  factory MatchModel.fromJson(Map<String, dynamic> json) =>
      _$MatchModelFromJson(json);

  factory MatchModel.fromEntity(MatchEntity e) => MatchModel(
        id: e.id,
        tournamentId: e.tournamentId,
        round: e.round,
        matchNumber: e.matchNumber,
        homeUserId: e.homeUserId,
        awayUserId: e.awayUserId,
        homeScore: e.homeScore,
        awayScore: e.awayScore,
        homePossession: e.homePossession,
        awayPossession: e.awayPossession,
        homeShots: e.homeShots,
        awayShots: e.awayShots,
        homeShotsOnTarget: e.homeShotsOnTarget,
        awayShotsOnTarget: e.awayShotsOnTarget,
        homeFouls: e.homeFouls,
        awayFouls: e.awayFouls,
        status: e.status,
        playedAt: e.playedAt,
        createdAt: e.createdAt,
      );

  MatchEntity toEntity() => MatchEntity(
        id: id,
        tournamentId: tournamentId,
        round: round,
        matchNumber: matchNumber,
        homeUserId: homeUserId,
        awayUserId: awayUserId,
        homeUsername: homeUsername,
        awayUsername: awayUsername,
        homeTeamTag: homeTeamTag,
        awayTeamTag: awayTeamTag,
        homeScore: homeScore,
        awayScore: awayScore,
        homePossession: homePossession,
        awayPossession: awayPossession,
        homeShots: homeShots,
        awayShots: awayShots,
        homeShotsOnTarget: homeShotsOnTarget,
        awayShotsOnTarget: awayShotsOnTarget,
        homeFouls: homeFouls,
        awayFouls: awayFouls,
        status: status,
        playedAt: playedAt,
        createdAt: createdAt,
      );
}
