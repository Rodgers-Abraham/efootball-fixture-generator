import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/entities/tournament_entity.dart';

part 'tournament_model.freezed.dart';
part 'tournament_model.g.dart';

@freezed
class TournamentModel with _$TournamentModel {
  const TournamentModel._();

  const factory TournamentModel({
    required String id,
    required String name,
    required String format,
    required String status,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'invite_code') String? inviteCode,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @Default([]) List<String> participantIds,
  }) = _TournamentModel;

  factory TournamentModel.fromJson(Map<String, dynamic> json) =>
      _$TournamentModelFromJson(json);

  factory TournamentModel.fromEntity(TournamentEntity e) => TournamentModel(
        id: e.id,
        name: e.name,
        format: e.format,
        status: e.status,
        createdBy: e.createdBy,
        inviteCode: e.inviteCode,
        createdAt: e.createdAt,
        participantIds: e.participantIds,
      );

  TournamentEntity toEntity() => TournamentEntity(
        id: id,
        name: name,
        format: format,
        status: status,
        createdBy: createdBy,
        inviteCode: inviteCode,
        createdAt: createdAt,
        participantIds: participantIds,
      );
}
