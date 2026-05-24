// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TournamentModelImpl _$$TournamentModelImplFromJson(
  Map<String, dynamic> json,
) => _$TournamentModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  format: json['format'] as String,
  status: json['status'] as String,
  createdBy: json['created_by'] as String?,
  inviteCode: json['invite_code'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  participantIds:
      (json['participantIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$TournamentModelImplToJson(
  _$TournamentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'format': instance.format,
  'status': instance.status,
  'created_by': instance.createdBy,
  'invite_code': instance.inviteCode,
  'created_at': instance.createdAt?.toIso8601String(),
  'participantIds': instance.participantIds,
};
