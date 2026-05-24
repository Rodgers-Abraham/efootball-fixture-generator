import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String username,
    required String teamTag,
    String? email,
    String? avatarUrl,
    DateTime? createdAt,
  }) = _UserEntity;
}
