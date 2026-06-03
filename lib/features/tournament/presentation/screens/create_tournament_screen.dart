import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eFootClash/core/constants/app_constants.dart';
import 'package:eFootClash/core/theme/app_colors.dart';
import 'package:eFootClash/features/tournament/presentation/providers/tournament_provider.dart';

class CreateTournamentScreen extends ConsumerStatefulWidget {
  const CreateTournamentScreen({super.key});

  @override
  ConsumerState<CreateTournamentScreen> createState() =>
      _CreateTournamentScreenState();
}

class _CreateTournamentScreenState
    extends ConsumerState<CreateTournamentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _format = AppConstants.formatRoundRobin;
  bool _loading = false;
  bool _loadingUsers = false;

  List<Map<String, dynamic>> _allUsers = [];
  final Set<String> _selectedUserIds = {};

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _loadingUsers = true);
    try {
      final rows = await Supabase.instance.client
          .from(AppConstants.usersTable)
          .select('id, username, team_tag')
          .order('username');
      setState(() => _allUsers = List<Map<String, dynamic>>.from(rows));
    } catch (_) {
    } finally {
      setState(() => _loadingUsers = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // NOTE: Removed requirement for at least 2 participants.
    // Users can now create an empty tournament and have others join later.

    setState(() => _loading = true);

    final tournament = await ref
        .read(tournamentListProvider.notifier)
        .createTournament(
          name: _nameController.text.trim(),
          format: _format,
          participantIds: _selectedUserIds.toList(),
        );

    if (!mounted) return;
    setState(() => _loading = false);

    if (tournament != null) {
      context.go('/tournament/${tournament.id}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create tournament')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('New Tournament')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Name
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Tournament Name',
                prefixIcon: Icon(Icons.emoji_events_outlined),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 20),

            // Format
            const Text(
              'FORMAT',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            _buildFormatSelector(),
            const SizedBox(height: 24),

            // Participants
            Row(
              children: [
                const Text(
                  'PARTICIPANTS',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_selectedUserIds.length} selected',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildUserList(),
            const SizedBox(height: 32),

            // Submit
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textPrimary,
                        ),
                      )
                    : const Text('CREATE TOURNAMENT'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatSelector() {
    final formats = [
      (
        AppConstants.formatRoundRobin,
        'Round Robin',
        Icons.format_list_bulleted,
      ),
      (
        AppConstants.formatSingleElimination,
        'Single Elimination',
        Icons.account_tree_outlined,
      ),
      (
        AppConstants.formatDoubleElimination,
        'Double Elimination',
        Icons.device_hub,
      ),
    ];

    return Column(
      children: formats.map((f) {
        final selected = _format == f.$1;
        return GestureDetector(
          onTap: () => setState(() => _format = f.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  f.$3,
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  f.$2,
                  style: TextStyle(
                    color: selected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                const Spacer(),
                if (selected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 18,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUserList() {
    if (_loadingUsers) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_allUsers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Text(
            'No registered users found',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: _allUsers.asMap().entries.map((entry) {
          final i = entry.key;
          final user = entry.value;
          final userId = user['id'] as String;
          final username = user['username'] as String;
          final teamTag = user['team_tag'] as String;
          final isSelected = _selectedUserIds.contains(userId);
          final isLast = i == _allUsers.length - 1;

          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                  child: Text(
                    teamTag,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                title: Text(username),
                subtitle: Text(teamTag),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : const Icon(
                        Icons.radio_button_unchecked,
                        color: AppColors.textDisabled,
                      ),
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedUserIds.remove(userId);
                    } else {
                      _selectedUserIds.add(userId);
                    }
                  });
                },
              ),
              if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}
