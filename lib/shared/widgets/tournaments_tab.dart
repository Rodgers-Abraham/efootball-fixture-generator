import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:efootball_fixture_generator/core/constants/app_constants.dart';
import 'package:efootball_fixture_generator/core/theme/app_colors.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/entities/tournament_entity.dart';
import 'package:efootball_fixture_generator/features/tournament/presentation/providers/tournament_provider.dart';
import 'package:efootball_fixture_generator/features/tournament/presentation/widgets/join_code_dialog.dart';

class TournamentsTab extends ConsumerWidget {
  const TournamentsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentsAsync = ref.watch(tournamentListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tournaments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            tooltip: 'Join with Code',
            onPressed: () => showJoinCodeDialog(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Create Tournament',
            onPressed: () => context.push(AppConstants.routeTournamentCreate),
          ),
        ],
      ),
      body: tournamentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  color: AppColors.error, size: 48),
              const SizedBox(height: 12),
              Text('Error: $e',
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(tournamentListProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (tournaments) {
          if (tournaments.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events_outlined,
                      color: AppColors.textDisabled, size: 72),
                  const SizedBox(height: 16),
                  const Text(
                    'No tournaments yet.',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap + to create your first tournament',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('CREATE TOURNAMENT'),
                    onPressed: () => context.push(
                        AppConstants.routeTournamentCreate),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(tournamentListProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tournaments.length,
              itemBuilder: (_, i) => _TournamentCard(
                tournament: tournaments[i],
                onTap: () => context
                    .push('/tournament/${tournaments[i].id}'),
                onDelete: () => ref
                    .read(tournamentListProvider.notifier)
                    .deleteTournament(tournaments[i].id),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TournamentCard extends StatelessWidget {
  final TournamentEntity tournament;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _TournamentCard({
    required this.tournament,
    required this.onTap,
    required this.onDelete,
  });

  Color get _statusColor {
    switch (tournament.status) {
      case 'active':
        return AppColors.success;
      case 'completed':
        return AppColors.textSecondary;
      default:
        return AppColors.warning;
    }
  }

  String get _formatLabel {
    switch (tournament.format) {
      case AppConstants.formatRoundRobin:
        return 'Round Robin';
      case AppConstants.formatSingleElimination:
        return 'Single Elimination';
      case AppConstants.formatDoubleElimination:
        return 'Double Elimination';
      default:
        return tournament.format;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.emoji_events,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tournament.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _formatLabel,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.textDisabled,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${tournament.participantIds.length} players',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Status chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                tournament.status.toUpperCase(),
                style: TextStyle(
                  color: _statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Delete
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.textDisabled, size: 18),
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Tournament?'),
        content: Text('Are you sure you want to delete "${tournament.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) onDelete();
  }
}
