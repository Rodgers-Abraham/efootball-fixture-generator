import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        title: const Text('Profile'),
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
            error: (_, __) => const SizedBox.shrink(),
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
                );
        },
      ),
    );
  }
}

// ── View mode ──────────────────────────────────────────────────
class _ViewBody extends StatelessWidget {
  final UserEntity user;
  final VoidCallback onSignOut;

  const _ViewBody({required this.user, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Avatar
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 52,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                backgroundImage: user.avatarUrl != null
                    ? NetworkImage(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null
                    ? Text(
                        user.teamTag,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                  child: const Icon(Icons.sports_soccer,
                      color: Colors.white, size: 14),
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
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4)),
            ),
            child: Text(
              user.teamTag,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
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
            side: const BorderSide(color: AppColors.error),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          icon: const Icon(Icons.logout),
          label: const Text('SIGN OUT'),
        ),
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
        borderRadius: BorderRadius.circular(12),
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
      leading: Icon(icon, color: AppColors.primary, size: 20),
      title: Text(label,
          style: const TextStyle(
              color: AppColors.textSecondary, fontSize: 12)),
      subtitle: Text(value,
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600)),
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
            'EDIT PROFILE',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: usernameCtrl,
            enabled: !saving,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Username is required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: teamTagCtrl,
            enabled: !saving,
            maxLength: 3,
            textCapitalization: TextCapitalization.characters,
            style: const TextStyle(color: AppColors.textPrimary),
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
