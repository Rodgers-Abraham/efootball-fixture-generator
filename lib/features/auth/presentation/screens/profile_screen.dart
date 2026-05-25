import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:efootball_fixture_generator/core/theme/app_colors.dart';
import 'package:efootball_fixture_generator/features/auth/presentation/providers/auth_provider.dart';
import 'package:efootball_fixture_generator/features/auth/domain/entities/user_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      final error = await ref.read(authNotifierProvider.notifier).uploadAvatar(File(image.path));
      if (error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: AppColors.error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (user) {
          if (user == null) return const Center(child: Text('Please log in'));

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 240,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildProfileHeader(user),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabDelegate(
                  TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primary,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    tabs: const [
                      Tab(text: 'OVERVIEW'),
                      Tab(text: 'SOCIAL'),
                      Tab(text: 'SETTINGS'),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(user),
                const _SocialTab(),
                const _SettingsTab(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserEntity user) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.surfaceVariant, AppColors.background],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          GestureDetector(
            onTap: _pickAvatar,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.surface,
                  backgroundImage: user.avatarUrl != null ? CachedNetworkImageProvider(user.avatarUrl!) : null,
                  child: user.avatarUrl == null ? const Icon(Icons.person, size: 50, color: AppColors.textDisabled) : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt, size: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(user.username, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
          Text(user.teamTag, style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 2)),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(UserEntity user) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildInfoTile('Email', user.email ?? 'Not set', Icons.email_outlined),
        _buildInfoTile('Member Since', user.createdAt != null ? user.createdAt!.toLocal().toString().split(' ')[0] : 'N/A', Icons.calendar_today_outlined),
        const SizedBox(height: 32),
        const Text('TROPHY CABINET', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.5)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
          child: const Center(child: Text('No trophies yet.', style: TextStyle(color: AppColors.textDisabled))),
        ),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textDisabled, size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialTab extends ConsumerWidget {
  const _SocialTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);
    final requestsAsync = ref.watch(pendingRequestsProvider);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        requestsAsync.when(
          data: (requests) {
            if (requests.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PENDING REQUESTS', style: TextStyle(color: AppColors.accentVolt, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.5)),
                const SizedBox(height: 12),
                ...requests.map((r) => _RequestTile(requestId: r.id, fromUser: r.fromUser)),
                const SizedBox(height: 24),
              ],
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (e, s) => const SizedBox.shrink(),
        ),

        const Text('FRIENDS', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.5)),
        const SizedBox(height: 12),
        friendsAsync.when(
          data: (friends) {
            if (friends.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('No friends yet.', style: TextStyle(color: AppColors.textDisabled))));
            return Column(children: friends.map((f) => _FriendTile(user: f)).toList());
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Text('Error: $e'),
        ),
      ],
    );
  }
}

class _RequestTile extends ConsumerWidget {
  final String requestId;
  final UserEntity fromUser;
  const _RequestTile({required this.requestId, required this.fromUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.accentVolt.withValues(alpha: 0.3))),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.surfaceVariant,
            backgroundImage: fromUser.avatarUrl != null ? CachedNetworkImageProvider(fromUser.avatarUrl!) : null,
            child: fromUser.avatarUrl == null ? const Icon(Icons.person, size: 20) : null,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(fromUser.username, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
          IconButton(icon: const Icon(Icons.check, color: AppColors.success), onPressed: () => ref.read(authNotifierProvider.notifier).acceptFriendRequest(requestId)),
          IconButton(icon: const Icon(Icons.close, color: AppColors.error), onPressed: () => ref.read(authNotifierProvider.notifier).declineFriendRequest(requestId)),
        ],
      ),
    );
  }
}

class _FriendTile extends StatelessWidget {
  final UserEntity user;
  const _FriendTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.surfaceVariant,
        backgroundImage: user.avatarUrl != null ? CachedNetworkImageProvider(user.avatarUrl!) : null,
        child: user.avatarUrl == null ? const Icon(Icons.person, size: 20) : null,
      ),
      title: Text(user.username, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      subtitle: Text(user.teamTag, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textDisabled),
      onTap: () {},
    );
  }
}

class _SettingsTab extends ConsumerWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('SECURITY', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.5)),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.lock_reset,
          title: 'Reset Password',
          subtitle: 'Receive a password reset link via email',
          onTap: () async {
            if (user?.email != null) {
              final error = await ref.read(authNotifierProvider.notifier).resetPassword(user!.email!);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(error ?? 'Reset email sent! Check your inbox.'),
                  backgroundColor: error != null ? AppColors.error : AppColors.success,
                ));
              }
            }
          },
        ),
        const SizedBox(height: 32),
        const Text('DANGER ZONE', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.5)),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.delete_forever,
          title: 'Delete Account',
          subtitle: 'Permanently remove all your data',
          color: AppColors.error,
          onTap: () => _confirmDelete(context, ref),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white10, foregroundColor: Colors.white),
          onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
          child: const Text('LOG OUT'),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Account?'),
        content: const Text('This action is irreversible. All your match history and squad data will be lost.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              ref.read(authNotifierProvider.notifier).deleteAccount();
              Navigator.pop(ctx);
            },
            child: const Text('DELETE', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? color;

  const _SettingsTile({required this.icon, required this.title, required this.subtitle, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppColors.primary),
        title: Text(title, style: TextStyle(color: color ?? Colors.white, fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        onTap: onTap,
      ),
    );
  }
}

class _SliverTabDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _SliverTabDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: AppColors.background, child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabDelegate oldDelegate) => false;
}
