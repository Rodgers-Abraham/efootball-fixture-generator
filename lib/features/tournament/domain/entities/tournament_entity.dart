import 'package:freezed_annotation/freezed_annotation.dart';

part 'tournament_entity.freezed.dart';

@freezed
class TournamentEntity with _$TournamentEntity {
  const factory TournamentEntity({
    required String id,
    required String name,
    required String format,
    required String status,
    String? createdBy,
    String? inviteCode,
    @Default([]) List<String> participantIds,
    DateTime? createdAt,
  }) = _TournamentEntity;
}
