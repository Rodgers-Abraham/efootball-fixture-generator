import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:eFootClash/core/errors/failures.dart';
import 'package:eFootClash/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signUp({
    required String username,
    required String teamTag,
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> signOut();

  Stream<UserEntity?> authStateChanges();

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, UserEntity>> updateProfile({
    required String userId,
    String? username,
    String? teamTag,
    String? avatarUrl,
  });

  Future<Either<Failure, String>> uploadAvatar({
    required String userId,
    required File imageFile,
  });

  // ── Account Management ──
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email);
  Future<Either<Failure, Unit>> deleteAccount();

  // ── Social / Friendships ──
  Future<Either<Failure, Unit>> sendFriendRequest(String toUserId);
  Future<Either<Failure, Unit>> acceptFriendRequest(String friendshipId);
  Future<Either<Failure, Unit>> declineFriendRequest(String friendshipId);
  Future<Either<Failure, List<UserEntity>>> getFriends();
  Future<Either<Failure, List<({String id, UserEntity fromUser})>>>
  getPendingRequests();
}
