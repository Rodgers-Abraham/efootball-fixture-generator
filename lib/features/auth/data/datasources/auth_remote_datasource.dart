import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eFootClash/core/constants/app_constants.dart';
import 'package:eFootClash/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> signUp({
    required String username,
    required String teamTag,
    required String email,
    required String password,
  });

  Future<UserModel> signIn({required String email, required String password});

  Future<void> signOut();

  Stream<UserModel?> authStateChanges();

  Future<UserModel?> getCurrentUser();

  Future<UserModel> updateProfile({
    required String userId,
    String? username,
    String? teamTag,
    String? avatarUrl,
  });

  Future<String> uploadAvatar({
    required String userId,
    required File imageFile,
  });

  // ── Account Management ──
  Future<void> sendPasswordResetEmail(String email);
  Future<void> deleteAccount();

  // ── Social / Friendships ──
  Future<void> sendFriendRequest(String fromUserId, String toUserId);
  Future<void> acceptFriendRequest(String friendshipId);
  Future<void> declineFriendRequest(String friendshipId);
  Future<List<UserModel>> getFriends(String userId);
  Future<List<Map<String, dynamic>>> getPendingRequests(String userId);
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

  @override
  Future<String> uploadAvatar({
    required String userId,
    required File imageFile,
  }) async {
    final fileExt = imageFile.path.split('.').last;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final path = '$userId/$fileName';

    await _client.storage
        .from('avatars')
        .upload(path, imageFile, fileOptions: const FileOptions(upsert: true));

    final imageUrl = _client.storage.from('avatars').getPublicUrl(path);
    return imageUrl;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  @override
  Future<void> deleteAccount() async {
    final user = _client.auth.currentUser;
    if (user == null) return;
    await _client.from('users').delete().eq('id', user.id);
    await signOut();
  }

  @override
  Future<void> sendFriendRequest(String fromUserId, String toUserId) async {
    final ids = [fromUserId, toUserId]..sort();
    await _client.from('friendships').insert({
      'user_id_1': ids[0],
      'user_id_2': ids[1],
      'status': 'pending',
    });
  }

  @override
  Future<void> acceptFriendRequest(String friendshipId) async {
    await _client
        .from('friendships')
        .update({'status': 'accepted'})
        .eq('id', friendshipId);
  }

  @override
  Future<void> declineFriendRequest(String friendshipId) async {
    await _client.from('friendships').delete().eq('id', friendshipId);
  }

  @override
  Future<List<UserModel>> getFriends(String userId) async {
    final response = await _client
        .from('friendships')
        .select('*, user1:users!user_id_1(*), user2:users!user_id_2(*)')
        .eq('status', 'accepted')
        .or('user_id_1.eq.$userId,user_id_2.eq.$userId');

    final List<UserModel> friends = [];
    for (var row in (response as List)) {
      final u1 = UserModel.fromJson(row['user1']);
      final u2 = UserModel.fromJson(row['user2']);
      friends.add(u1.id == userId ? u2 : u1);
    }
    return friends;
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingRequests(String userId) async {
    final response = await _client
        .from('friendships')
        .select('id, fromUser:users!user_id_1(*)')
        .eq('status', 'pending')
        .eq('user_id_2', userId);

    return List<Map<String, dynamic>>.from(response);
  }
}
