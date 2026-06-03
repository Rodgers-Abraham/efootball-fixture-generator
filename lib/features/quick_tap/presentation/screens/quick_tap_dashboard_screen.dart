import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eFootClash/core/theme/app_colors.dart';
import 'package:eFootClash/features/quick_tap/presentation/providers/quick_tap_provider.dart';
import 'package:eFootClash/features/squad/domain/entities/squad_item_entity.dart';
import 'package:eFootClash/features/squad/presentation/providers/squad_provider.dart';
import 'package:eFootClash/features/tournament/presentation/providers/tournament_provider.dart';
import 'package:eFootClash/shared/widgets/esports_components.dart';

class QuickTapDashboardScreen extends ConsumerWidget {
  final String tournamentId;
  final String matchId;

  const QuickTapDashboardScreen({
    super.key,
    required this.tournamentId,
    required this.matchId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchAsync = ref.watch(matchProvider(matchId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('TACTICAL VERIFICATION'),
        actions: [
          TextButton(
            onPressed: () async {
              final success = await ref
                  .read(quickTapNotifierProvider(matchId).notifier)
                  .saveResults(tournamentId);
              if (success && context.mounted) Navigator.pop(context);
            },
            child: const Text(
              'FINALIZE',
              style: TextStyle(
                color: AppColors.accentVolt,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
      body: matchAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (match) {
          if (match == null) {
            return const Center(child: Text('Match not found'));
          }

          return CustomScrollView(
            slivers: [
              // ── Home Squad Segment ────────────────────────────────
              _SliverSectionHeader(
                title: '${match.homeUsername} (HOME)',
                color: AppColors.primary,
              ),
              _TacticalGrid(
                matchId: matchId,
                userId: match.homeUserId!,
                teamTag: match.homeTeamTag ?? 'HT',
              ),

              // ── Away Squad Segment ────────────────────────────────
              _SliverSectionHeader(
                title: '${match.awayUsername} (AWAY)',
                color: AppColors.secondary,
              ),
              _TacticalGrid(
                matchId: matchId,
                userId: match.awayUserId!,
                teamTag: match.awayTeamTag ?? 'AT',
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
    );
  }
}

class _SliverSectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  const _SliverSectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
        child: Row(
          children: [
            Container(width: 4, height: 24, color: color),
            const SizedBox(width: 12),
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TacticalGrid extends ConsumerWidget {
  final String matchId;
  final String userId;
  final String teamTag;

  const _TacticalGrid({
    required this.matchId,
    required this.userId,
    required this.teamTag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final squadAsync = ref.watch(matchSquadProvider(userId));

    return squadAsync.when(
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => SliverToBoxAdapter(child: Text('Error: $e')),
      data: (squad) {
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index >= squad.length) return const SizedBox.shrink();
              final item = squad[index];
              return _InteractiveCard(
                matchId: matchId,
                squadItem: item,
                teamTag: teamTag,
              );
            }, childCount: 16),
          ),
        );
      },
    );
  }
}

class _InteractiveCard extends ConsumerWidget {
  final String matchId;
  final SquadItemEntity squadItem;
  final String teamTag;

  const _InteractiveCard({
    required this.matchId,
    required this.squadItem,
    required this.teamTag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quickTapNotifierProvider(matchId));
    final goals = state.goals[squadItem.squadItemId] ?? 0;
    final isMotm = state.motmSquadItemId == squadItem.squadItemId;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 150),
      tween: Tween(begin: 1.0, end: goals > 0 ? 1.05 : 1.0),
      builder: (context, scale, child) {
        return GestureDetector(
          onTap: () => ref
              .read(quickTapNotifierProvider(matchId).notifier)
              .incrementGoal(squadItem.squadItemId),
          onLongPress: () {
            ref
                .read(quickTapNotifierProvider(matchId).notifier)
                .setMotm(squadItem.squadItemId);
            Feedback.forLongPress(context);
          },
          child: EsportsPlayerCard(
            playerName: squadItem.card.playerName,
            teamTag: teamTag,
            imageUrl: squadItem.card.cardImageUrl,
            goals: goals,
            isMotm: isMotm,
            scale: scale,
            glowColor: goals > 0 ? AppColors.accentPurple : null,
          ),
        );
      },
    );
  }
}
