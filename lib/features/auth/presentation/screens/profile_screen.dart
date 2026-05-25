import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:efootball_fixture_generator/core/theme/app_colors.dart';
import 'package:efootball_fixture_generator/features/auth/domain/entities/user_entity.dart';
import 'package:efootball_fixture_generator/features/auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  bool _saving = false;

  late TextEditingController _usernameCtrl;
  late TextEditingController _teamTagCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = ref.read(authNotifierProvider).valueOrNull;
    _usernameCtrl = TextEditingController(text: user?.username ?? '');
    _teamTagCtrl = TextEditingController(text: user?.teamTag ?? '');
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _teamTagCtrl.dispose();
    super.dispose();
  }

  void _startEditing(UserEntity user) {
    _usernameCtrl.text = user.username;
    _teamTagCtrl.text = user.teamTag;
    setState(() => _isEditing = true);
  }

  Future<void> _pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (image != null) {
      setState(() => _saving = true);
      final error = await ref.read(authNotifierProvider.notifier).uploadAvatar(File(image.path));
      
      if (!mounted) return;
      setState(() => _saving = false);

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final error = await ref.read(authNotifierProvider.notifier).updateProfile(
          username: _usernameCtrl.text.trim(),
          teamTag: _teamTagCtrl.text.trim().toUpperCase(),
        );

    if (!mounted) return;
    setState(() {
      _saving = false;
      if (error == null) _isEditing = false;
    });

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('PROFILE'),
        actions: [
          authAsync.when(
            data: (user) => user == null
                ? const SizedBox.shrink()
                : _isEditing
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: _saving
                                ? null
                                : () => setState(() => _isEditing = false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: _saving ? null : _save,
                            child: _saving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Text('Save',
                                    style: TextStyle(color: AppColors.primary)),
                          ),
                        ],
                      )
                    : IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Edit Profile',
                        onPressed: () => _startEditing(user),
                      ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: authAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: AppColors.textSecondary)),
        ),
        data: (user) {
          if (user == null) return const SizedBox.shrink();
          return _isEditing
              ? _EditBody(
                  formKey: _formKey,
                  usernameCtrl: _usernameCtrl,
                  teamTagCtrl: _teamTagCtrl,
                  saving: _saving,
                )
              : _ViewBody(
                  user: user,
                  onSignOut: () =>
                      ref.read(authNotifierProvider.notifier).signOut(),
                  onAvatarTap: _pickAndUploadAvatar,
                );
        },
      ),
    );
  }
}

// ── View mode ──────────────────────────────────────────────────
class _ViewBody extends ConsumerWidget {
  final UserEntity user;
  final VoidCallback onSignOut;
  final VoidCallback onAvatarTap;

  const _ViewBody({
    required this.user, 
    required this.onSignOut,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trophyAsync = ref.watch(userTrophiesProvider(user.id));

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      children: [
        // Avatar
        Center(
          child: Stack(
            children: [
              GestureDetector(
                onTap: onAvatarTap,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundImage: user.avatarUrl != null
                      ? NetworkImage(user.avatarUrl!)
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
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onAvatarTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.background, width: 3),
                    ),
                    child: const Icon(Icons.camera_alt,
                        color: Colors.black, size: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Center(
          child: Text(
            user.username,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Text(
              user.teamTag,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // 🏆 Trophy Cabinet
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface,
                AppColors.primary.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.trophyGold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.emoji_events, color: AppColors.trophyGold, size: 32),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  trophyAsync.when(
                    data: (count) => Text(
                      '$count',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    loading: () => const SizedBox(
                      width: 20, height: 20, 
                      child: CircularProgressIndicator(strokeWidth: 2)
                    ),
                    error: (_, _) => const Text('0'),
                  ),
                  const Text(
                    'Tournament Victories',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Details card
        _InfoCard(children: [
          _InfoRow(icon: Icons.person_outline, label: 'Username',
              value: user.username),
          const Divider(height: 1, indent: 52),
          _InfoRow(icon: Icons.tag, label: 'Team Tag', value: user.teamTag),
          if (user.email != null) ...[
            const Divider(height: 1, indent: 52),
            _InfoRow(icon: Icons.email_outlined, label: 'Email',
                value: user.email!),
          ],
        ]),
        const SizedBox(height: 32),

        // Sign out
        OutlinedButton.icon(
          onPressed: onSignOut,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error, width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          icon: const Icon(Icons.logout),
          label: const Text('SIGN OUT'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(label,
          style: const TextStyle(
              color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
      subtitle: Text(value,
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700)),
    );
  }
}

// ── Edit mode ──────────────────────────────────────────────────
class _EditBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameCtrl;
  final TextEditingController teamTagCtrl;
  final bool saving;

  const _EditBody({
    required this.formKey,
    required this.usernameCtrl,
    required this.teamTagCtrl,
    required this.saving,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'EDIT ACCOUNT DETAILS',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: usernameCtrl,
            enabled: !saving,
            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Username is required' : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: teamTagCtrl,
            enabled: !saving,
            maxLength: 3,
            textCapitalization: TextCapitalization.characters,
            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w900, letterSpacing: 2),
            decoration: const InputDecoration(
              labelText: 'Team Tag (3 letters)',
              prefixIcon: Icon(Icons.tag),
            ),
            onChanged: (v) {
              final upper = v.toUpperCase();
              if (upper != v) {
                teamTagCtrl.value = teamTagCtrl.value.copyWith(
                  text: upper,
                  selection:
                      TextSelection.collapsed(offset: upper.length),
                );
              }
            },
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Team tag is required';
              if (v.trim().length != 3) return 'Must be exactly 3 characters';
              return null;
            },
          ),
        ],
      ),
    );
  }
}
