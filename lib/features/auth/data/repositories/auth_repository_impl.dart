import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:eFootClash/core/errors/failures.dart';
import 'package:eFootClash/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:eFootClash/features/auth/data/models/user_model.dart';
import 'package:eFootClash/features/auth/domain/entities/user_entity.dart';
import 'package:eFootClash/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String username,
    required String teamTag,
    required String email,
    required String password,
  }) async {
    try {
      final model = await _datasource.signUp(
        username: username,
        teamTag: teamTag,
        email: email,
        password: password,
      );
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.auth(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _datasource.signIn(email: email, password: password);
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.auth(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _datasource.signOut();
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.auth(message: e.toString()));
    }
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return _datasource.authStateChanges().map((m) => m?.toEntity());
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final model = await _datasource.getCurrentUser();
      return Right(model?.toEntity());
    } on Exception catch (e) {
      return Left(Failure.auth(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String userId,
    String? username,
    String? teamTag,
    String? avatarUrl,
  }) async {
    try {
      final model = await _datasource.updateProfile(
        userId: userId,
        username: username,
        teamTag: teamTag,
        avatarUrl: avatarUrl,
      );
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.auth(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadAvatar({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final url = await _datasource.uploadAvatar(
        userId: userId,
        imageFile: imageFile,
      );
      return Right(url);
    } on Exception catch (e) {
      return Left(Failure.auth(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email) async {
    try {
      await _datasource.sendPasswordResetEmail(email);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.auth(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    try {
      await _datasource.deleteAccount();
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.auth(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendFriendRequest(String toUserId) async {
    try {
      final user = await _datasource.getCurrentUser();
      if (user == null)
        return Left(const Failure.auth(message: 'Not logged in'));
      await _datasource.sendFriendRequest(user.id, toUserId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.auth(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> acceptFriendRequest(String friendshipId) async {
    try {
      await _datasource.acceptFriendRequest(friendshipId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.auth(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> declineFriendRequest(
    String friendshipId,
  ) async {
    try {
      await _datasource.declineFriendRequest(friendshipId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.auth(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getFriends() async {
    try {
      final user = await _datasource.getCurrentUser();
      if (user == null)
        return Left(const Failure.auth(message: 'Not logged in'));
      final models = await _datasource.getFriends(user.id);
      return Right(models.map((m) => m.toEntity()).toList());
    } on Exception catch (e) {
      return Left(Failure.auth(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<({String id, UserEntity fromUser})>>>
  getPendingRequests() async {
    try {
      final user = await _datasource.getCurrentUser();
      if (user == null)
        return Left(const Failure.auth(message: 'Not logged in'));
      final list = await _datasource.getPendingRequests(user.id);
      final results = list.map((item) {
        final id = item['id'] as String;
        final fromUserData = (item['fromUser'] as Map<String, dynamic>);
        return (id: id, fromUser: UserModel.fromJson(fromUserData).toEntity());
      }).toList();
      return Right(results);
    } on Exception catch (e) {
      return Left(Failure.auth(message: e.toString()));
    }
  }
}
