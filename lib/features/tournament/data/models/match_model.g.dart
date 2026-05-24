// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchModelImpl _$$MatchModelImplFromJson(Map<String, dynamic> json) =>
    _$MatchModelImpl(
      id: json['id'] as String,
      tournamentId: json['tournament_id'] as String,
      round: (json['round'] as num).toInt(),
      matchNumber: (json['match_number'] as num).toInt(),
      homeUserId: json['home_user_id'] as String?,
      awayUserId: json['away_user_id'] as String?,
      homeScore: (json['home_score'] as num?)?.toInt(),
      awayScore: (json['away_score'] as num?)?.toInt(),
      homePossession: (json['home_possession'] as num?)?.toInt(),
      awayPossession: (json['away_possession'] as num?)?.toInt(),
      homeShots: (json['home_shots'] as num?)?.toInt(),
      awayShots: (json['away_shots'] as num?)?.toInt(),
      homeShotsOnTarget: (json['home_shots_on_target'] as num?)?.toInt(),
      awayShotsOnTarget: (json['away_shots_on_target'] as num?)?.toInt(),
      homeFouls: (json['home_fouls'] as num?)?.toInt(),
      awayFouls: (json['away_fouls'] as num?)?.toInt(),
      status: json['status'] as String? ?? 'scheduled',
      playedAt: json['played_at'] == null
          ? null
          : DateTime.parse(json['played_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$MatchModelImplToJson(_$MatchModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tournament_id': instance.tournamentId,
      'round': instance.round,
      'match_number': instance.matchNumber,
      'home_user_id': instance.homeUserId,
      'away_user_id': instance.awayUserId,
      'home_score': instance.homeScore,
      'away_score': instance.awayScore,
      'home_possession': instance.homePossession,
      'away_possession': instance.awayPossession,
      'home_shots': instance.homeShots,
      'away_shots': instance.awayShots,
      'home_shots_on_target': instance.homeShotsOnTarget,
      'away_shots_on_target': instance.awayShotsOnTarget,
      'home_fouls': instance.homeFouls,
      'away_fouls': instance.awayFouls,
      'status': instance.status,
      'played_at': instance.playedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
