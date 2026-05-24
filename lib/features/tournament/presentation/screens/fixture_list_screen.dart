import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:efootball_fixture_generator/core/constants/app_constants.dart';
import 'package:efootball_fixture_generator/core/theme/app_colors.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/entities/match_entity.dart';
import 'package:efootball_fixture_generator/features/tournament/presentation/providers/tournament_provider.dart';
import 'package:efootball_fixture_generator/features/tournament/presentation/widgets/bracket_widget.dart';

void _showInviteCode(BuildContext context, String code) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Invite Code',
          style: TextStyle(color: AppColors.textPrimary)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Share this code with players to join the tournament.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4)),
            ),
            child: Text(
              code,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 10,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(content: Text('Code copied to clipboard')),
              );
            },
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Copy Code'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

class FixtureListScreen extends ConsumerWidget {
  final String tournamentId;

  const FixtureListScreen({super.key, required this.tournamentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentAsync = ref.watch(tournamentProvider(tournamentId));
    final bracketAsync = ref.watch(bracketProvider(tournamentId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: tournamentAsync.when(
          data: (t) => Text(t?.name ?? 'Fixtures'),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Fixtures'),
        ),
        actions: [
          tournamentAsync.when(
            data: (t) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (t?.inviteCode != null)
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    tooltip: 'Invite Code: ${t!.inviteCode}',
                    onPressed: () => _showInviteCode(context, t.inviteCode!),
                  ),
                if (t?.format == AppConstants.formatRoundRobin)
                  IconButton(
                    icon: const Icon(Icons.table_chart_outlined),
                    tooltip: 'Standings',
                    onPressed: () =>
                        context.push('/tournament/$tournamentId/standings'),
                  ),
              ],
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppConstants.routeTournamentCreate),
        icon: const Icon(Icons.add),
        label: const Text('New'),
      ),
      body: bracketAsync.when(
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
                onPressed: () => ref.invalidate(bracketProvider(tournamentId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (bracket) {
          if (bracket == null || bracket.rounds.isEmpty) {
            return const Center(
              child: Text('No fixtures generated yet.',
                  style: TextStyle(color: AppColors.textSecondary)),
            );
          }

          if (bracket.format == AppConstants.formatRoundRobin) {
            return _RoundRobinSchedule(
              tournamentId: tournamentId,
              rounds: bracket.rounds,
            );
          } else {
            return BracketWidget(rounds: bracket.rounds);
          }
        },
      ),
    );
  }
}

class _RoundRobinSchedule extends StatelessWidget {
  final String tournamentId;
  final List<List<MatchEntity>> rounds;

  const _RoundRobinSchedule({
    required this.tournamentId,
    required this.rounds,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rounds.length,
      itemBuilder: (_, roundIndex) {
        final round = rounds[roundIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 10),
              child: Text(
                'MATCHDAY ${roundIndex + 1}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            ...round.map((match) => _MatchTile(
                  match: match,
                  tournamentId: tournamentId,
                )),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}

class _MatchTile extends StatelessWidget {
  final MatchEntity match;
  final String tournamentId;

  const _MatchTile({required this.match, required this.tournamentId});

  @override
  Widget build(BuildContext context) {
    final completed = match.status == AppConstants.matchCompleted;

    return GestureDetector(
      onTap: () {
        if (!completed) {
          // Navigate to OCR scanner or quick tap
          showModalBottomSheet(
            context: context,
            backgroundColor: AppColors.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (_) => _MatchActionSheet(
              match: match,
              tournamentId: tournamentId,
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: completed
                ? AppColors.success.withValues(alpha: 0.3)
                : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            // Home
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    match.homeTeamTag ??
                        (match.homeUserId != null ? 'Player' : 'TBD'),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  if (match.homeUsername != null)
                    Text(
                      match.homeUsername!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),

            // Score / Status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: completed
                  ? Row(
                      children: [
                        Text(
                          '${match.homeScore}',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            '-',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Text(
                          '${match.awayScore}',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'PLAY',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
            ),

            // Away
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    match.awayTeamTag ??
                        (match.awayUserId != null ? 'Player' : 'TBD'),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  if (match.awayUsername != null)
                    Text(
                      match.awayUsername!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.end,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchActionSheet extends StatelessWidget {
  final MatchEntity match;
  final String tournamentId;

  const _MatchActionSheet({
    required this.match,
    required this.tournamentId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Enter Match Result',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${match.homeTeamTag ?? 'Home'} vs ${match.awayTeamTag ?? 'Away'}',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('SCAN SCREENSHOT'),
            onPressed: () {
              Navigator.pop(context);
              context.push(
                  '/tournament/$tournamentId/match/${match.id}/scan');
            },
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.touch_app_outlined),
            label: const Text('QUICK TAP'),
            onPressed: () {
              Navigator.pop(context);
              context.push(
                  '/tournament/$tournamentId/match/${match.id}/quick-tap');
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
