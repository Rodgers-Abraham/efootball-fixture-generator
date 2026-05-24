import 'package:flutter/material.dart';
import 'package:efootball_fixture_generator/core/theme/app_colors.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/entities/match_entity.dart';

/// Visual bracket display for single/double elimination.
class BracketWidget extends StatelessWidget {
  final List<List<MatchEntity>> rounds;

  const BracketWidget({super.key, required this.rounds});

  @override
  Widget build(BuildContext context) {
    if (rounds.isEmpty) {
      return const Center(
        child: Text('No bracket data',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rounds.asMap().entries.map((entry) {
            final roundIndex = entry.key;
            final round = entry.value;
            return _RoundColumn(
              roundIndex: roundIndex,
              matches: round,
              totalRounds: rounds.length,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _RoundColumn extends StatelessWidget {
  final int roundIndex;
  final List<MatchEntity> matches;
  final int totalRounds;

  const _RoundColumn({
    required this.roundIndex,
    required this.matches,
    required this.totalRounds,
  });

  @override
  Widget build(BuildContext context) {
    final roundLabel = roundIndex == totalRounds - 1
        ? 'FINAL'
        : roundIndex == totalRounds - 2
            ? 'SEMI-FINAL'
            : 'ROUND ${roundIndex + 1}';

    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Round header
          Container(
            margin: const EdgeInsets.only(bottom: 12, right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
            ),
            child: Text(
              roundLabel,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ),
          // Matches
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: matches.map((m) => _MatchCard(match: m)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final MatchEntity match;

  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final completed = match.status == 'completed';

    return Container(
      margin: const EdgeInsets.only(right: 16, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: completed ? AppColors.success.withValues(alpha: 0.4) : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          _TeamRow(
            tag: match.homeTeamTag ?? match.homeUserId?.substring(0, 4) ?? 'TBD',
            score: match.homeScore,
            isWinner: completed &&
                (match.homeScore ?? 0) > (match.awayScore ?? 0),
          ),
          const Divider(height: 1),
          _TeamRow(
            tag: match.awayTeamTag ?? match.awayUserId?.substring(0, 4) ?? 'TBD',
            score: match.awayScore,
            isWinner: completed &&
                (match.awayScore ?? 0) > (match.homeScore ?? 0),
          ),
        ],
      ),
    );
  }
}

class _TeamRow extends StatelessWidget {
  final String tag;
  final int? score;
  final bool isWinner;

  const _TeamRow({
    required this.tag,
    this.score,
    this.isWinner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isWinner
            ? AppColors.success.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            tag,
            style: TextStyle(
              color: isWinner ? AppColors.success : AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const Spacer(),
          if (score != null)
            Text(
              '$score',
              style: TextStyle(
                color: isWinner ? AppColors.success : AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            )
          else
            const Text(
              '-',
              style: TextStyle(color: AppColors.textDisabled, fontSize: 14),
            ),
        ],
      ),
    );
  }
}
