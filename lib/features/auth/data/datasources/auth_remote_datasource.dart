import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:efootball_fixture_generator/core/constants/app_constants.dart';
import 'package:efootball_fixture_generator/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> signUp({
    required String username,
    required String teamTag,
    required String email,
    required String password,
  });

  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Stream<UserModel?> authStateChanges();

  Future<UserModel?> getCurrentUser();

  Future<UserModel> updateProfile({
    required String userId,
    String? username,
    String? teamTag,
    String? avatarUrl,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final SupabaseClient _client;

  AuthRemoteDatasourceImpl(this._client);

  @override
  Future<UserModel> signUp({
    required String username,
    required String teamTag,
    required String email,
    required String password,
  }) async {
    final authResponse = await _client.auth.signUp(
      email: email,
      password: password,
    );

    if (authResponse.user == null) {
      throw Exception('Sign-up failed: no user returned');
    }

    final userId = authResponse.user!.id;

    await _client.from(AppConstants.usersTable).insert({
      'id': userId,
      'username': username,
      'team_tag': teamTag.toUpperCase(),
      'email': email,
    });

    final row = await _client
        .from(AppConstants.usersTable)
        .select()
        .eq('id', userId)
        .single();

    return UserModel.fromJson(row);
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final authResponse = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (authResponse.user == null) {
      throw Exception('Sign-in failed: no user returned');
    }

    final userId = authResponse.user!.id;
    final row = await _client
        .from(AppConstants.usersTable)
        .select()
        .eq('id', userId)
        .single();

    return UserModel.fromJson(row);
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return _client.auth.onAuthStateChange.asyncMap((event) async {
      final user = event.session?.user;
      if (user == null) return null;

      try {
        final row = await _client
            .from(AppConstants.usersTable)
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (row == null) return null;
        return UserModel.fromJson(row);
      } catch (_) {
        return null;
      }
    });
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final row = await _client
        .from(AppConstants.usersTable)
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (row == null) return null;
    return UserModel.fromJson(row);
  }

  @override
  Future<UserModel> updateProfile({
    required String userId,
    String? username,
    String? teamTag,
    String? avatarUrl,
  }) async {
    final updates = <String, dynamic>{};
    if (username != null) updates['username'] = username;
    if (teamTag != null) updates['team_tag'] = teamTag.toUpperCase();
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

    await _client
        .from(AppConstants.usersTable)
        .update(updates)
        .eq('id', userId);

    final row = await _client
        .from(AppConstants.usersTable)
        .select()
        .eq('id', userId)
        .single();

    return UserModel.fromJson(row);
  }
}
