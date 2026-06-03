import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:eFootClash/core/theme/app_colors.dart';
import 'package:eFootClash/features/analytics/presentation/providers/analytics_provider.dart';
import 'package:eFootClash/features/tournament/presentation/providers/tournament_provider.dart';
import 'package:eFootClash/shared/widgets/esports_components.dart';

class TournamentDashboardScreen extends ConsumerWidget {
  const TournamentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentListAsync = ref.watch(tournamentListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: tournamentListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) {
          if (list.isEmpty) {
            return _buildEmptyState(context);
          }
          final activeTid = list.first.id;
          return _buildDashboard(context, ref, activeTid);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.sports_soccer,
            size: 64,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: 16),
          const Text(
            'No active tournaments',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.push('/tournament/create'),
            child: const Text('CREATE NEW'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    WidgetRef ref,
    String tournamentId,
  ) {
    final matchesAsync = ref.watch(matchesProvider(tournamentId));
    final goldenBootAsync = ref.watch(goldenBootProvider(tournamentId));

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'DASHBOARD',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: SliverStairedGridDelegate(
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                pattern: const [
                  StairedGridTile(1.0, 2 / 1.2), // Live Match (Full width)
                  StairedGridTile(
                    0.5,
                    1 / 1.5,
                  ), // Golden Boot (Left half, tall)
                  StairedGridTile(
                    0.5,
                    1 / 1,
                  ), // Scan Button (Right half, square)
                  StairedGridTile(
                    0.5,
                    1 / 1,
                  ), // Bracket State (Right half, square)
                ],
              ),
              delegate: SliverChildListDelegate([
                // 1. Live Match Tile
                matchesAsync.when(
                  data: (matches) {
                    if (matches.isEmpty) {
                      return const BentoTile(
                        label: 'Live Fixture',
                        child: Center(child: Text('No matches generated')),
                      );
                    }
                    final nextMatch = matches.firstWhere(
                      (m) => m.status == 'scheduled',
                      orElse: () => matches.first,
                    );
                    return LiveMatchTile(
                      homeName: nextMatch.homeUsername ?? 'HOME',
                      homeTag: nextMatch.homeTeamTag ?? 'HT',
                      awayName: nextMatch.awayUsername ?? 'AWAY',
                      awayTag: nextMatch.awayTeamTag ?? 'AT',
                      possession: 0.5,
                    );
                  },
                  loading: () => const BentoTile(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) =>
                      const BentoTile(child: Center(child: Icon(Icons.error))),
                ),

                // 2. Golden Boot Tile
                goldenBootAsync.when(
                  data: (entries) => BentoTile(
                    label: 'Golden Boot',
                    child: entries.isEmpty
                        ? const Center(
                            child: Icon(
                              Icons.star_outline,
                              color: AppColors.textDisabled,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                if (entries.length > 1)
                                  Positioned(
                                    top: 40,
                                    left: 10,
                                    right: 10,
                                    child: EsportsPlayerCard(
                                      playerName: entries[1].playerName,
                                      teamTag: entries[1].teamTag,
                                      imageUrl: entries[1].cardImageUrl,
                                      scale: 0.85,
                                    ),
                                  ),
                                EsportsPlayerCard(
                                  playerName: entries[0].playerName,
                                  teamTag: entries[0].teamTag,
                                  imageUrl: entries[0].cardImageUrl,
                                  isMotm: true,
                                ),
                              ],
                            ),
                          ),
                  ),
                  loading: () => const BentoTile(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) =>
                      const BentoTile(child: Center(child: Icon(Icons.error))),
                ),

                // 3. Scan Button Tile
                GestureDetector(
                  onTap: () {
                    matchesAsync.whenData((matches) {
                      if (matches.isEmpty) return;
                      final m = matches.firstWhere(
                        (m) => m.status != 'completed',
                        orElse: () => matches.first,
                      );
                      context.push(
                        '/tournament/$tournamentId/match/${m.id}/scan',
                      );
                    });
                  },
                  child: const BentoTile(
                    borderColor: AppColors.accentVolt,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.accentVolt,
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'SCAN\nSCREEN',
                          style: TextStyle(
                            color: AppColors.accentVolt,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // 4. Bracket State Tile
                GestureDetector(
                  onTap: () => context.push('/tournament/$tournamentId'),
                  child: BentoTile(
                    label: 'Bracket',
                    child: Center(
                      child: Icon(
                        Icons.account_tree_outlined,
                        color: AppColors.primary.withValues(alpha: 0.5),
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
