import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:efootball_fixture_generator/core/constants/app_constants.dart';
import 'package:efootball_fixture_generator/core/theme/app_colors.dart';
import 'package:efootball_fixture_generator/features/quick_tap/presentation/providers/quick_tap_provider.dart';
import 'package:efootball_fixture_generator/features/quick_tap/presentation/widgets/player_tap_chip.dart';
import 'package:efootball_fixture_generator/features/squad/domain/entities/squad_item_entity.dart';
import 'package:efootball_fixture_generator/features/squad/presentation/providers/squad_provider.dart';
import 'package:efootball_fixture_generator/features/tournament/presentation/providers/tournament_provider.dart';

class QuickTapDashboardScreen extends ConsumerStatefulWidget {
  final String tournamentId;
  final String matchId;

  const QuickTapDashboardScreen({
    super.key,
    required this.tournamentId,
    required this.matchId,
  });

  @override
  ConsumerState<QuickTapDashboardScreen> createState() =>
      _QuickTapDashboardScreenState();
}

class _QuickTapDashboardScreenState
    extends ConsumerState<QuickTapDashboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  List<SquadItemEntity> _homeSquad = [];
  List<SquadItemEntity> _awaySquad = [];
  bool _loadingSquads = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    ref.read(quickTapNotifierProvider.notifier).reset();
    _loadSquads();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSquads() async {
    final match = ref.read(matchProvider(widget.matchId)).valueOrNull;
    if (match == null) {
      // Wait for it
      await Future.delayed(const Duration(milliseconds: 500));
    }

    final matchData = await Supabase.instance.client
        .from(AppConstants.matchesTable)
        .select('home_user_id, away_user_id')
        .eq('id', widget.matchId)
        .maybeSingle();

    if (matchData == null) {
      setState(() => _loadingSquads = false);
      return;
    }

    final homeUserId = matchData['home_user_id'] as String?;
    final awayUserId = matchData['away_user_id'] as String?;

    final squadRepo = ref.read(squadRepositoryProvider);

    if (homeUserId != null) {
      final result = await squadRepo.getUserSquad(homeUserId);
      _homeSquad = result.fold((_) => [], (s) => s);
    }

    if (awayUserId != null) {
      final result = await squadRepo.getUserSquad(awayUserId);
      _awaySquad = result.fold((_) => [], (s) => s);
    }

    if (mounted) setState(() => _loadingSquads = false);
  }

  Future<void> _confirm(int homeScore, int awayScore) async {
    final error = await ref
        .read(quickTapNotifierProvider.notifier)
        .confirmResult(
          matchId: widget.matchId,
          homeScore: homeScore,
          awayScore: awayScore,
          homeSquad: _homeSquad,
          awaySquad: _awaySquad,
        );

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Match result saved!')),
      );
      context.go('/tournament/${widget.tournamentId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final matchAsync = ref.watch(matchProvider(widget.matchId));
    final tapState = ref.watch(quickTapNotifierProvider);

    return matchAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Quick Tap')),
        body: Center(
          child: Text('Error: $e',
              style: const TextStyle(color: AppColors.error)),
        ),
      ),
      data: (match) {
        if (match == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(title: const Text('Quick Tap')),
            body: const Center(
              child: Text('Match not found',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          );
        }

        final homeScore = match.homeScore ?? 0;
        final awayScore = match.awayScore ?? 0;
        final homeTag = match.homeTeamTag ?? 'HME';
        final awayTag = match.awayTeamTag ?? 'AWY';

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text('Round ${match.round} · Match ${match.matchNumber}'),
          ),
          body: Column(
            children: [
              // Score header
              _buildScoreHeader(
                homeTag: homeTag,
                awayTag: awayTag,
                homeScore: homeScore,
                awayScore: awayScore,
              ),

              // Tab bar
              Container(
                color: AppColors.surface,
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'GOALSCORERS'),
                    Tab(text: 'MAN OF THE MATCH'),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: _loadingSquads
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          // Goals tab
                          _GoalsTab(
                            homeTag: homeTag,
                            awayTag: awayTag,
                            homeSquad: _homeSquad,
                            awaySquad: _awaySquad,
                            tapState: tapState,
                            onTapGoal: (id) => ref
                                .read(quickTapNotifierProvider.notifier)
                                .tapGoal(id),
                            onUntapGoal: (id) => ref
                                .read(quickTapNotifierProvider.notifier)
                                .untapGoal(id),
                          ),
                          // MOTM tab
                          _MotmTab(
                            homeTag: homeTag,
                            awayTag: awayTag,
                            homeSquad: _homeSquad,
                            awaySquad: _awaySquad,
                            tapState: tapState,
                            onSelect: (id) => ref
                                .read(quickTapNotifierProvider.notifier)
                                .selectMotm(id),
                          ),
                        ],
                      ),
              ),

              // Confirm button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: tapState.isSaving
                        ? null
                        : () => _confirm(homeScore, awayScore),
                    child: tapState.isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.textPrimary,
                            ),
                          )
                        : const Text('CONFIRM RESULT'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScoreHeader({
    required String homeTag,
    required String awayTag,
    required int homeScore,
    required int awayScore,
  }) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            homeTag,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4)),
            ),
            child: Text(
              '$homeScore - $awayScore',
              style: const TextStyle(
                color: AppColors.accentNeon,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            awayTag,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Goals Tab ────────────────────────────────────────────────────
class _GoalsTab extends StatelessWidget {
  final String homeTag;
  final String awayTag;
  final List<SquadItemEntity> homeSquad;
  final List<SquadItemEntity> awaySquad;
  final QuickTapState tapState;
  final ValueChanged<String> onTapGoal;
  final ValueChanged<String> onUntapGoal;

  const _GoalsTab({
    required this.homeTag,
    required this.awayTag,
    required this.homeSquad,
    required this.awaySquad,
    required this.tapState,
    required this.onTapGoal,
    required this.onUntapGoal,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTeamSection(homeTag, homeSquad),
          const SizedBox(height: 20),
          _buildTeamSection(awayTag, awaySquad),
        ],
      ),
    );
  }

  Widget _buildTeamSection(String tag, List<SquadItemEntity> squad) {
    final totalGoals =
        squad.fold(0, (s, i) => s + tapState.goalCountFor(i.squadItemId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Team $tag',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            const Spacer(),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$totalGoals goals',
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
        if (squad.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'No squad loaded for this team',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: squad.map((item) {
              return PlayerTapChip(
                squadItem: item,
                count: tapState.goalCountFor(item.squadItemId),
                isMotmMode: false,
                onTap: () => onTapGoal(item.squadItemId),
                onLongPress: () => onUntapGoal(item.squadItemId),
              );
            }).toList(),
          ),
      ],
    );
  }
}

// ── MOTM Tab ─────────────────────────────────────────────────────
class _MotmTab extends StatelessWidget {
  final String homeTag;
  final String awayTag;
  final List<SquadItemEntity> homeSquad;
  final List<SquadItemEntity> awaySquad;
  final QuickTapState tapState;
  final ValueChanged<String> onSelect;

  const _MotmTab({
    required this.homeTag,
    required this.awayTag,
    required this.homeSquad,
    required this.awaySquad,
    required this.tapState,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final allPlayers = [...homeSquad, ...awaySquad];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tap to select the Man of the Match',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          if (allPlayers.isEmpty)
            const Text(
              'No players loaded',
              style: TextStyle(color: AppColors.textSecondary),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allPlayers.map((item) {
                return PlayerTapChip(
                  squadItem: item,
                  isMotmMode: true,
                  isMotmSelected:
                      tapState.selectedMotmId == item.squadItemId,
                  onTap: () => onSelect(item.squadItemId),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
