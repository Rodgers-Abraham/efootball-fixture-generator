import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eFootClash/core/theme/app_colors.dart';
import 'package:eFootClash/features/tournament/presentation/providers/tournament_provider.dart';

/// The analytics tab shows a list of tournaments to pick one for analytics.
class AnalyticsTab extends ConsumerWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentsAsync = ref.watch(tournamentListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Analytics')),
      body: tournamentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Error: $e',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
        data: (tournaments) {
          if (tournaments.isEmpty) {
            return const Center(
              child: Text(
                'No tournaments to analyze yet.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tournaments.length,
            itemBuilder: (_, i) {
              final t = tournaments[i];
              return GestureDetector(
                onTap: () => context.push('/analytics/${t.id}'),
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
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.bar_chart,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          t.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
