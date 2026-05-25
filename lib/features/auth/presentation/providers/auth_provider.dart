import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:efootball_fixture_generator/core/utils/supabase_client.dart';
import 'package:efootball_fixture_generator/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:efootball_fixture_generator/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:efootball_fixture_generator/features/auth/domain/entities/user_entity.dart';
import 'package:efootball_fixture_generator/features/auth/domain/repositories/auth_repository.dart';

// ── Infrastructure ─────────────────────────────────────────────
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRemoteDatasourceImpl(client);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final ds = ref.watch(authRemoteDatasourceProvider);
  return AuthRepositoryImpl(ds);
});

// ── Auth state notifier ────────────────────────────────────────
final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, UserEntity?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async {
    final repo = ref.watch(authRepositoryProvider);
    // Listen to stream for real-time updates
    repo.authStateChanges().listen((user) {
      state = AsyncData(user);
    });
    final result = await repo.getCurrentUser();
    return result.fold((_) => null, (user) => user);
  }

  Future<String?> signUp({
    required String username,
    required String teamTag,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.signUp(
      username: username,
      teamTag: teamTag,
      email: email,
      password: password,
    );
    return result.fold(
      (f) {
        state = AsyncError(f, StackTrace.current);
        return f.message;
      },
      (user) {
        state = AsyncData(user);
        return null;
      },
    );
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.signIn(email: email, password: password);
    return result.fold(
      (f) {
        state = AsyncError(f, StackTrace.current);
        return f.message;
      },
      (user) {
        state = AsyncData(user);
        return null;
      },
    );
  }

  Future<void> signOut() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.signOut();
    state = const AsyncData(null);
  }

  Future<String?> updateProfile({
    String? username,
    String? teamTag,
    String? avatarUrl,
  }) async {
    final currentUser = state.valueOrNull;
    if (currentUser == null) return 'Not logged in';

    final repo = ref.read(authRepositoryProvider);
    final result = await repo.updateProfile(
      userId: currentUser.id,
      username: username,
      teamTag: teamTag,
      avatarUrl: avatarUrl,
    );

    return result.fold(
      (f) => f.message,
      (updated) {
        state = AsyncData(updated);
        return null;
      },
    );
  }

  Future<String?> uploadAvatar(File file) async {
    final user = state.valueOrNull;
    if (user == null) return 'Not logged in';

    final repo = ref.read(authRepositoryProvider);
    final result = await repo.uploadAvatar(userId: user.id, imageFile: file);

    return result.fold(
      (f) => f.message,
      (url) => updateProfile(avatarUrl: url),
    );
  }

  // ── Account Management ──
  Future<String?> resetPassword(String email) async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.sendPasswordResetEmail(email);
    return result.fold((f) => f.message, (_) => null);
  }

  Future<String?> deleteAccount() async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.deleteAccount();
    return result.fold((f) => f.message, (_) {
      state = const AsyncData(null);
      return null;
    });
  }

  // ── Friendship Management ──
  Future<String?> sendFriendRequest(String toUserId) async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.sendFriendRequest(toUserId);
    return result.fold((f) => f.message, (_) => null);
  }

  Future<String?> acceptFriendRequest(String requestId) async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.acceptFriendRequest(requestId);
    if (result.isRight()) {
      ref.invalidate(friendsProvider);
      ref.invalidate(pendingRequestsProvider);
    }
    return result.fold((f) => f.message, (_) => null);
  }

  Future<String?> declineFriendRequest(String requestId) async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.declineFriendRequest(requestId);
    if (result.isRight()) {
      ref.invalidate(pendingRequestsProvider);
    }
    return result.fold((f) => f.message, (_) => null);
  }
}

// ── Convenience providers ──────────────────────────────────────
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).valueOrNull != null;
});

final friendsProvider = FutureProvider<List<UserEntity>>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  final result = await repo.getFriends();
  return result.fold((_) => [], (list) => list);
});

final pendingRequestsProvider = FutureProvider<List<({String id, UserEntity fromUser})>>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  final result = await repo.getPendingRequests();
  return result.fold((_) => [], (list) => list);
});

final userTrophiesProvider = FutureProvider.family<int, String>((ref, userId) async {
  final client = ref.watch(supabaseClientProvider);
  final response = await client.from('match_events').select('id, squad_items!inner(user_id)').eq('event_type', 'motm').eq('squad_items.user_id', userId);
  return (response as List).length;
});
