import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eFootClash/core/theme/app_colors.dart';
import 'package:eFootClash/features/analytics/domain/entities/leaderboard_entry_entity.dart';
import 'package:eFootClash/features/analytics/presentation/providers/analytics_provider.dart';
import 'package:eFootClash/features/tournament/presentation/providers/tournament_provider.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  final String tournamentId;

  const AnalyticsScreen({super.key, required this.tournamentId});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tournamentAsync = ref.watch(tournamentProvider(widget.tournamentId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: tournamentAsync.when(
          data: (t) => Text(t?.name ?? 'Analytics'),
          loading: () => const Text('Analytics'),
          // Fixed unnecessary_underscores
          error: (_, _) => const Text('Analytics'),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'GOLDEN BOOT'),
            Tab(text: 'TOURNAMENT MVP'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(goldenBootProvider(widget.tournamentId));
              ref.invalidate(motmLeaderboardProvider(widget.tournamentId));
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _LeaderboardTab(
            tournamentId: widget.tournamentId,
            mode: _LeaderboardMode.golden,
          ),
          _LeaderboardTab(
            tournamentId: widget.tournamentId,
            mode: _LeaderboardMode.motm,
          ),
        ],
      ),
    );
  }
}

enum _LeaderboardMode { golden, motm }

class _LeaderboardTab extends ConsumerWidget {
  final String tournamentId;
  final _LeaderboardMode mode;

  const _LeaderboardTab({required this.tournamentId, required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = mode == _LeaderboardMode.golden
        ? ref.watch(goldenBootProvider(tournamentId))
        : ref.watch(motmLeaderboardProvider(tournamentId));

    return dataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Error: $e',
          style: const TextStyle(color: AppColors.error),
        ),
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  mode == _LeaderboardMode.golden
                      ? Icons.sports_soccer
                      : Icons.star_outline,
                  color: AppColors.textDisabled,
                  size: 64,
                ),
                const SizedBox(height: 12),
                Text(
                  mode == _LeaderboardMode.golden
                      ? 'No goals recorded yet'
                      : 'No MOTM awards yet',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: entries.length,
          itemBuilder: (_, i) {
            return _LeaderboardRow(entry: entries[i], mode: mode);
          },
        );
      },
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final LeaderboardEntryEntity entry;
  final _LeaderboardMode mode;

  const _LeaderboardRow({required this.entry, required this.mode});

  @override
  Widget build(BuildContext context) {
    final isFirst = entry.rank == 1;
    final rankColor = entry.rank == 1
        ? const Color(0xFFFFD700)
        : entry.rank == 2
        ? const Color(0xFFC0C0C0)
        : entry.rank == 3
        ? const Color(0xFFCD7F32)
        : AppColors.textSecondary;

    final cardTypeColor = AppColors.cardTypeColor(entry.cardType);
    final count = mode == _LeaderboardMode.golden
        ? entry.goals
        : entry.motmCount;
    final countLabel = mode == _LeaderboardMode.golden ? 'goals' : 'MOTM';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isFirst
            ? AppColors.primary.withValues(alpha: 0.12)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFirst
              ? AppColors.primary.withValues(alpha: 0.4)
              : AppColors.border,
        ),
        boxShadow: isFirst
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 12,
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Rank
            SizedBox(
              width: 36,
              child: Text(
                '#${entry.rank}',
                style: TextStyle(
                  color: rankColor,
                  fontSize: isFirst ? 18 : 14,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 10),

            // Player avatar
            _buildAvatar(entry.cardImageUrl),
            const SizedBox(width: 12),

            // Name + card type
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.playerName,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: isFirst ? 16 : 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: cardTypeColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: cardTypeColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          entry.cardType,
                          style: TextStyle(
                            color: cardTypeColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        entry.teamTag,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Count badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isFirst
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                border: isFirst
                    ? Border.all(
                        color: AppColors.accentVolt.withValues(alpha: 0.5),
                      )
                    : null,
              ),
              child: Column(
                children: [
                  Text(
                    '$count',
                    style: TextStyle(
                      color: isFirst
                          ? AppColors.accentVolt
                          : AppColors.textPrimary,
                      fontSize: isFirst ? 22 : 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    countLabel,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          // Fixed unnecessary_underscores
          placeholder: (_, _) => _placeholder(),
          // Fixed unnecessary_underscores
          errorWidget: (_, _, _) => _placeholder(),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.primary.withValues(alpha: 0.2),
      child: Text(
        entry.playerName.isNotEmpty ? entry.playerName[0].toUpperCase() : '?',
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
  }
}
