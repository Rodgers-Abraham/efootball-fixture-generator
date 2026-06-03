import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eFootClash/core/theme/app_colors.dart';
import 'package:eFootClash/features/auth/presentation/providers/auth_provider.dart';
import 'package:eFootClash/core/utils/supabase_client.dart';
import 'package:eFootClash/features/auth/data/models/user_model.dart';
import 'package:eFootClash/features/squad/domain/entities/squad_item_entity.dart';
import 'package:eFootClash/features/squad/data/models/squad_item_model.dart';
import 'package:eFootClash/features/squad/presentation/widgets/player_card_chip.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Fetches a specific user's public info.
final publicUserProvider = FutureProvider.family<UserModel?, String>((
  ref,
  userId,
) async {
  final client = ref.watch(supabaseClientProvider);
  final row = await client
      .from('users')
      .select()
      .eq('id', userId)
      .maybeSingle();
  if (row == null) return null;
  return UserModel.fromJson(row);
});

/// Fetches a specific user's squad.
final publicSquadProvider =
    FutureProvider.family<List<SquadItemEntity>, String>((ref, userId) async {
      final client = ref.watch(supabaseClientProvider);
      final response = await client
          .from('squad_items')
          .select('*, player_cards(*)')
          .eq('user_id', userId)
          .order('slot_index');

      final list = response as List;
      return list
          .map(
            (json) => SquadItemModel.fromJson(
              json as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList();
    });

class PublicProfileScreen extends ConsumerWidget {
  final String userId;

  const PublicProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(publicUserProvider(userId));
    final trophyAsync = ref.watch(userTrophiesProvider(userId));
    final squadAsync = ref.watch(publicSquadProvider(userId));
    final currentUser = ref.watch(authNotifierProvider).valueOrNull;
    final friendsAsync = ref.watch(friendsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('PLAYER PROFILE')),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          final isOwnProfile = currentUser?.id == userId;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              // Header section (Avatar + Name)
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      backgroundImage: user.avatarUrl != null
                          ? CachedNetworkImageProvider(user.avatarUrl!)
                          : null,
                      child: user.avatarUrl == null
                          ? Text(
                              user.teamTag,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.username,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.teamTag,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Social Action Button
                    if (!isOwnProfile && currentUser != null)
                      friendsAsync.when(
                        data: (friends) {
                          final isFriend = friends.any((f) => f.id == userId);
                          if (isFriend) {
                            return const Chip(
                              label: Text('FRIENDS'),
                              avatar: Icon(Icons.check, size: 16),
                            );
                          }
                          return ElevatedButton.icon(
                            icon: const Icon(Icons.person_add),
                            label: const Text('SEND FRIEND REQUEST'),
                            onPressed: () async {
                              final error = await ref
                                  .read(authNotifierProvider.notifier)
                                  .sendFriendRequest(userId);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      error ?? 'Friend request sent!',
                                    ),
                                    backgroundColor: error != null
                                        ? AppColors.error
                                        : AppColors.success,
                                  ),
                                );
                              }
                            },
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 🏆 Trophy cabinet
              const Text(
                'TROPHY CABINET',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: AppColors.trophyGold,
                      size: 28,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        trophyAsync.when(
                          data: (count) => Text(
                            '$count',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          loading: () => const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          error: (_, _) => const Text('0'),
                        ),
                        const Text(
                          'TOURNAMENT WINS',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ⚽ Squad section
              const Text(
                'STARTING XI',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              squadAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error loading squad: $e'),
                data: (squad) {
                  final starters = squad
                      .where((s) => s.slotIndex < 11)
                      .toList();
                  if (starters.isEmpty) {
                    return const Center(
                      child: Text(
                        'No squad built yet',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.72,
                        ),
                    itemCount: starters.length,
                    itemBuilder: (context, i) =>
                        PlayerCardChip(card: starters[i].card),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
