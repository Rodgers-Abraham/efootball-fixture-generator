import 'package:dartz/dartz.dart';
import 'package:efootball_fixture_generator/core/errors/failures.dart';
import 'package:efootball_fixture_generator/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:efootball_fixture_generator/features/auth/domain/entities/user_entity.dart';
import 'package:efootball_fixture_generator/features/auth/domain/repositories/auth_repository.dart';

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
}
