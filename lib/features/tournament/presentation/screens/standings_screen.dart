import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:efootball_fixture_generator/core/theme/app_colors.dart';
import 'package:efootball_fixture_generator/features/tournament/presentation/providers/tournament_provider.dart';

class StandingsScreen extends ConsumerWidget {
  final String tournamentId;

  const StandingsScreen({super.key, required this.tournamentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final standingsAsync = ref.watch(standingsProvider(tournamentId));
    final tournamentAsync = ref.watch(tournamentProvider(tournamentId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: tournamentAsync.when(
          data: (t) => Text('${t?.name ?? 'Tournament'} Standings'),
          loading: () => const Text('Standings'),
          // Fixed unnecessary_underscores
          error: (_, _) => const Text('Standings'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(standingsProvider(tournamentId)),
          ),
        ],
      ),
      body: standingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: AppColors.error)),
        ),
        data: (standings) {
          if (standings.isEmpty) {
            return const Center(
              child: Text(
                'No completed matches yet.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: standings.length,
                  itemBuilder: (_, i) {
                    final entry = standings[i];
                    final rank = i + 1;
                    return _StandingsRow(entry: entry, rank: rank);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.surface,
      child: const Row(
        children: [
          SizedBox(width: 28, child: Text('#', style: _headerStyle)),
          SizedBox(width: 8),
          Expanded(child: Text('TEAM', style: _headerStyle)),
          _ColHeader('P', 28),
          _ColHeader('W', 28),
          _ColHeader('D', 28),
          _ColHeader('L', 28),
          _ColHeader('GF', 32),
          _ColHeader('GA', 32),
          _ColHeader('GD', 32),
          _ColHeader('PTS', 40),
        ],
      ),
    );
  }
}

const _headerStyle = TextStyle(
  color: AppColors.textSecondary,
  fontSize: 11,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.0,
);

class _ColHeader extends StatelessWidget {
  final String label;
  final double width;

  const _ColHeader(this.label, this.width);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(label, style: _headerStyle, textAlign: TextAlign.center),
    );
  }
}

class _StandingsRow extends StatelessWidget {
  final StandingEntry entry;
  final int rank;

  const _StandingsRow({required this.entry, required this.rank});

  @override
  Widget build(BuildContext context) {
    final isTop3 = rank <= 3;
    final rankColor = rank == 1
        ? const Color(0xFFFFD700)
        : rank == 2
            ? const Color(0xFFC0C0C0)
            : rank == 3
                ? const Color(0xFFCD7F32)
                : AppColors.textSecondary;

    return GestureDetector(
      onTap: () => context.push('/profile/${entry.userId}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        decoration: BoxDecoration(
          color: isTop3
              ? AppColors.primary.withValues(alpha: rank == 1 ? 0.12 : 0.06)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: rank == 1
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
              : null,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '$rank',
                style: TextStyle(
                  color: rankColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.username,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    entry.teamTag,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            _StatCell('${entry.played}', 28),
            _StatCell('${entry.wins}', 28, color: AppColors.success),
            _StatCell('${entry.draws}', 28, color: AppColors.warning),
            _StatCell('${entry.losses}', 28, color: AppColors.error),
            _StatCell('${entry.goalsFor}', 32),
            _StatCell('${entry.goalsAgainst}', 32),
            _StatCell(
              entry.goalDifference >= 0
                  ? '+${entry.goalDifference}'
                  : '${entry.goalDifference}',
              32,
              color: entry.goalDifference > 0
                  ? AppColors.success
                  : entry.goalDifference < 0
                      ? AppColors.error
                      : AppColors.textSecondary,
            ),
            _StatCell(
              '${entry.points}',
              40,
              color: AppColors.accentVolt,
              bold: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final double width;
  final Color color;
  final bool bold;

  const _StatCell(
    this.value,
    this.width, {
    this.color = AppColors.textPrimary,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        value,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
