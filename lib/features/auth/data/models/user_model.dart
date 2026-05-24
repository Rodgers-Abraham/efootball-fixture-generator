import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:efootball_fixture_generator/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String username,
    @JsonKey(name: 'team_tag') required String teamTag,
    String? email,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        username: entity.username,
        teamTag: entity.teamTag,
        email: entity.email,
        avatarUrl: entity.avatarUrl,
        createdAt: entity.createdAt,
      );

  UserEntity toEntity() => UserEntity(
        id: id,
        username: username,
        teamTag: teamTag,
        email: email,
        avatarUrl: avatarUrl,
        createdAt: createdAt,
      );
}
