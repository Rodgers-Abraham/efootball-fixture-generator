import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eFootClash/core/constants/app_constants.dart';
import 'package:eFootClash/core/theme/app_colors.dart';
import 'package:eFootClash/features/auth/presentation/providers/auth_provider.dart';
import 'package:eFootClash/features/tournament/domain/entities/match_entity.dart';
import 'package:eFootClash/features/tournament/domain/entities/tournament_entity.dart';
import 'package:eFootClash/features/tournament/presentation/providers/tournament_provider.dart';
import 'package:eFootClash/features/tournament/presentation/widgets/bracket_widget.dart';

void _showInviteCode(BuildContext context, String code) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'INVITE PLAYERS',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w900,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Share this code with players to join the tournament.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Text(
              code,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(content: Text('Code copied to clipboard')),
              );
            },
            icon: const Icon(Icons.copy, size: 18, color: Colors.black),
            label: const Text('COPY INVITE CODE'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('CLOSE'),
        ),
      ],
    ),
  );
}

class FixtureListScreen extends ConsumerStatefulWidget {
  final String tournamentId;
  const FixtureListScreen({super.key, required this.tournamentId});
  @override
  ConsumerState<FixtureListScreen> createState() => _FixtureListScreenState();
}

class _FixtureListScreenState extends ConsumerState<FixtureListScreen> {
  bool _starting = false;

  Future<void> _handleStart(TournamentEntity tournament) async {
    if (tournament.participantIds.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least 2 players are needed to start.'),
        ),
      );
      return;
    }
    setState(() => _starting = true);
    final success = await ref
        .read(tournamentListProvider.notifier)
        .startTournament(widget.tournamentId);
    if (!mounted) return;
    setState(() => _starting = false);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to start tournament.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tournamentAsync = ref.watch(tournamentProvider(widget.tournamentId));
    final bracketAsync = ref.watch(bracketProvider(widget.tournamentId));
    final currentUser = ref.watch(authNotifierProvider).valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: tournamentAsync.when(
          data: (t) => Text(t?.name ?? 'FIXTURES'),
          loading: () => const Text('LOADING...'),
          error: (_, _) => const Text('FIXTURES'),
        ),
        actions: [
          tournamentAsync.when(
            data: (t) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (t?.format == AppConstants.formatRoundRobin)
                  IconButton(
                    icon: const Icon(Icons.table_chart_outlined),
                    tooltip: 'Standings',
                    onPressed: () => context.push(
                      '/tournament/${widget.tournamentId}/standings',
                    ),
                  ),
              ],
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: Column(
        children: [
          tournamentAsync.when(
            data: (t) {
              if (t == null || t.inviteCode == null || t.status == 'completed') {
                return const SizedBox.shrink();
              }
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.15),
                      AppColors.surface,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.people_alt_outlined,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'INVITE PLAYERS',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                          Text(
                            'Share code: ${t.inviteCode}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _showInviteCode(context, t.inviteCode!),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text(
                        'SHARE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          Expanded(
            child: bracketAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Error: $e',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          ref.invalidate(bracketProvider(widget.tournamentId)),
                      child: const Text('RETRY'),
                    ),
                  ],
                ),
              ),
              data: (bracket) {
                final tournament = tournamentAsync.valueOrNull;
                if (tournament?.status == 'pending') {
                  final isCreator = currentUser?.id == tournament?.createdBy;
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.hourglass_empty,
                            size: 64,
                            color: AppColors.textDisabled,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'TOURNAMENT PENDING',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Participants: ${tournament?.participantIds.length ?? 0}\nWaiting for players to join via code...',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (isCreator) ...[
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: _starting
                                    ? null
                                    : () => _handleStart(tournament!),
                                child: _starting
                                    ? const CircularProgressIndicator(
                                        color: Colors.black,
                                      )
                                    : const Text(
                                        'START TOURNAMENT & GENERATE FIXTURES',
                                      ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }
                if (bracket == null || bracket.rounds.isEmpty) {
                  return const Center(
                    child: Text(
                      'No fixtures generated yet.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }
                if (bracket.format == AppConstants.formatRoundRobin) {
                  return _RoundRobinSchedule(
                    tournamentId: widget.tournamentId,
                    rounds: bracket.rounds,
                  );
                } else {
                  return BracketWidget(rounds: bracket.rounds);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundRobinSchedule extends StatelessWidget {
  final String tournamentId;
  final List<List<MatchEntity>> rounds;
  const _RoundRobinSchedule({required this.tournamentId, required this.rounds});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            ...round.map(
              (match) => _MatchTile(match: match, tournamentId: tournamentId),
            ),
            const SizedBox(height: 12),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: completed
              ? AppColors.success.withValues(alpha: 0.2)
              : AppColors.border,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: InkWell(
                onTap: match.homeUserId != null
                    ? () => context.push('/profile/${match.homeUserId}')
                    : null,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        match.homeTeamTag ??
                            (match.homeUserId != null ? 'PLAYER' : 'TBD'),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                      if (match.homeUsername != null)
                        Text(
                          match.homeUsername!.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!completed) {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: AppColors.surface,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (_) => _MatchActionSheet(
                      match: match,
                      tournamentId: tournamentId,
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                color: AppColors.surfaceVariant.withValues(alpha: 0.2),
                child: Center(
                  child: completed
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${match.homeScore}',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                ':',
                                style: TextStyle(
                                  color: AppColors.textDisabled,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Text(
                              '${match.awayScore}',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.4),
                            ),
                          ),
                          child: const Text(
                            'VS',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: match.awayUserId != null
                    ? () => context.push('/profile/${match.awayUserId}')
                    : null,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        match.awayTeamTag ??
                            (match.awayUserId != null ? 'PLAYER' : 'TBD'),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                      if (match.awayUsername != null)
                        Text(
                          match.awayUsername!.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.end,
                        ),
                    ],
                  ),
                ),
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
  const _MatchActionSheet({required this.match, required this.tournamentId});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'ENTER MATCH RESULT',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${match.homeTeamTag ?? 'HOME'} vs ${match.awayTeamTag ?? 'AWAY'}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.black),
            label: const Text('SCAN SCREENSHOT'),
            onPressed: () {
              Navigator.pop(context);
              context.push('/tournament/$tournamentId/match/${match.id}/scan');
            },
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.touch_app_outlined),
            label: const Text('QUICK TAP MANUAL'),
            onPressed: () {
              Navigator.pop(context);
              context.push(
                '/tournament/$tournamentId/match/${match.id}/quick-tap',
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
