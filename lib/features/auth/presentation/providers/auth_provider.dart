import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:efootball_fixture_generator/core/errors/failures.dart';
import 'package:efootball_fixture_generator/core/utils/supabase_client.dart';
import 'package:efootball_fixture_generator/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:efootball_fixture_generator/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:efootball_fixture_generator/features/auth/domain/entities/user_entity.dart';
import 'package:efootball_fixture_generator/features/auth/domain/repositories/auth_repository.dart';
import 'package:efootball_fixture_generator/features/tournament/presentation/providers/tournament_provider.dart';

// ── Datasource ─────────────────────────────────────────────────
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRemoteDatasourceImpl(client);
});

// ── Repository ─────────────────────────────────────────────────
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.watch(authRemoteDatasourceProvider);
  return AuthRepositoryImpl(datasource);
});

// ── Auth state notifier ────────────────────────────────────────
class AuthNotifier extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async {
    final repo = ref.watch(authRepositoryProvider);
    final result = await repo.getCurrentUser();
    return result.fold((_) => null, (user) => user);
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.signIn(email: email, password: password);
    return result.fold(
      (failure) {
        state = const AsyncData(null);
        return failure.displayMessage;
      },
      (user) {
        state = AsyncData(user);
        return null;
      },
    );
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
      (failure) {
        state = const AsyncData(null);
        return failure.displayMessage;
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
    final user = state.valueOrNull;
    if (user == null) return 'Not logged in';
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.updateProfile(
      userId: user.id,
      username: username,
      teamTag: teamTag,
      avatarUrl: avatarUrl,
    );
    return result.fold(
      (failure) => failure.displayMessage,
      (updated) {
        state = AsyncData(updated);
        return null;
      },
    );
  }

  Future<String?> uploadAvatar(File imageFile) async {
    final user = state.valueOrNull;
    if (user == null) return 'Not logged in';
    
    final repo = ref.read(authRepositoryProvider);
    final uploadResult = await repo.uploadAvatar(
      userId: user.id,
      imageFile: imageFile,
    );

    return uploadResult.fold(
      (failure) => failure.displayMessage,
      (url) async {
        return updateProfile(avatarUrl: url);
      },
    );
  }
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, UserEntity?>(AuthNotifier.new);

/// Convenience stream provider that mirrors Supabase auth state.
final authStateStreamProvider = StreamProvider<UserEntity?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges();
});

/// Quick boolean whether any user is logged in.
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.valueOrNull != null;
});

/// The current Supabase auth user (raw).
final supabaseAuthUserProvider = Provider<User?>((ref) {
  return Supabase.instance.client.auth.currentUser;
});

/// Fetches trophy count for a given user.
final userTrophiesProvider = FutureProvider.family<int, String>((ref, userId) async {
  final client = ref.watch(supabaseClientProvider);
  
  // 1. Get all completed tournaments
  final tournamentsResponse = await client
      .from('tournaments')
      .select('id, format')
      .eq('status', 'completed');

  final completedTournaments = List<Map<String, dynamic>>.from(tournamentsResponse);
  int trophies = 0;

  for (final t in completedTournaments) {
    final tid = t['id'] as String;
    final format = t['format'] as String;

    if (format == 'round_robin') {
      final standings = await ref.read(standingsProvider(tid).future);
      if (standings.isNotEmpty && standings.first.userId == userId) {
        trophies++;
      }
    } else {
      final matches = await ref.read(matchesProvider(tid).future);
      if (matches.isNotEmpty) {
        final lastMatch = matches.last;
        if (lastMatch.status == 'completed') {
          final winnerId = (lastMatch.homeScore ?? 0) > (lastMatch.awayScore ?? 0)
              ? lastMatch.homeUserId 
              : lastMatch.awayUserId;
          if (winnerId == userId) trophies++;
        }
      }
    }
  }

  return trophies;
});
