import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:efootball_fixture_generator/core/utils/supabase_client.dart';
import 'package:efootball_fixture_generator/features/quick_tap/data/datasources/quick_tap_remote_datasource.dart';
import 'package:efootball_fixture_generator/features/quick_tap/data/repositories/quick_tap_repository_impl.dart';
import 'package:efootball_fixture_generator/features/quick_tap/domain/repositories/quick_tap_repository.dart';
import 'package:efootball_fixture_generator/features/squad/domain/entities/squad_item_entity.dart';

// ── Infrastructure ─────────────────────────────────────────────
final quickTapRemoteDatasourceProvider =
    Provider<QuickTapRemoteDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return QuickTapRemoteDatasourceImpl(client);
});

final quickTapRepositoryProvider = Provider<QuickTapRepository>((ref) {
  final ds = ref.watch(quickTapRemoteDatasourceProvider);
  return QuickTapRepositoryImpl(ds);
});

// ── Goal counts per squad item ─────────────────────────────────
/// Map<squadItemId, goalCount>
final goalCountsProvider =
    StateProvider<Map<String, int>>((_) => {});

/// Selected MOTM squad item id
final selectedMotmProvider = StateProvider<String?>((_) => null);

// ── Quick-tap state notifier ───────────────────────────────────
class QuickTapState {
  final Map<String, int> goalCounts;
  final String? selectedMotmId;
  final bool isSaving;
  final String? errorMessage;

  const QuickTapState({
    this.goalCounts = const {},
    this.selectedMotmId,
    this.isSaving = false,
    this.errorMessage,
  });

  QuickTapState copyWith({
    Map<String, int>? goalCounts,
    String? selectedMotmId,
    bool? isSaving,
    String? errorMessage,
    bool clearMotm = false,
    bool clearError = false,
  }) {
    return QuickTapState(
      goalCounts: goalCounts ?? this.goalCounts,
      selectedMotmId:
          clearMotm ? null : selectedMotmId ?? this.selectedMotmId,
      isSaving: isSaving ?? this.isSaving,
      errorMessage:
          clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  int goalCountFor(String squadItemId) =>
      goalCounts[squadItemId] ?? 0;

  int totalGoalsForTeam(List<SquadItemEntity> squad) =>
      squad.fold(0, (sum, item) => sum + goalCountFor(item.squadItemId));
}

class QuickTapNotifier extends Notifier<QuickTapState> {
  @override
  QuickTapState build() => const QuickTapState();

  void tapGoal(String squadItemId) {
    final current = Map<String, int>.from(state.goalCounts);
    current[squadItemId] = (current[squadItemId] ?? 0) + 1;
    state = state.copyWith(goalCounts: current);
  }

  void untapGoal(String squadItemId) {
    final current = Map<String, int>.from(state.goalCounts);
    final existing = current[squadItemId] ?? 0;
    if (existing > 0) {
      current[squadItemId] = existing - 1;
    }
    state = state.copyWith(goalCounts: current);
  }

  void selectMotm(String squadItemId) {
    final already = state.selectedMotmId == squadItemId;
    state = state.copyWith(
      selectedMotmId: already ? null : squadItemId,
      clearMotm: already,
    );
  }

  /// Validate goal totals against the score then persist to Supabase.
  Future<String?> confirmResult({
    required String matchId,
    required int homeScore,
    required int awayScore,
    required List<SquadItemEntity> homeSquad,
    required List<SquadItemEntity> awaySquad,
  }) async {
    final homeTapped = state.totalGoalsForTeam(homeSquad);
    final awayTapped = state.totalGoalsForTeam(awaySquad);

    if (homeTapped != homeScore) {
      return 'Home team goals tapped ($homeTapped) must equal score ($homeScore)';
    }
    if (awayTapped != awayScore) {
      return 'Away team goals tapped ($awayTapped) must equal score ($awayScore)';
    }

    state = state.copyWith(isSaving: true, clearError: true);

    final repo = ref.read(quickTapRepositoryProvider);

    // Clear previous events for this match first
    await repo.clearEventsForMatch(matchId);

    // Log goals
    for (final entry in state.goalCounts.entries) {
      final squadItemId = entry.key;
      final count = entry.value;
      for (int i = 0; i < count; i++) {
        await repo.logGoal(matchId: matchId, squadItemId: squadItemId);
      }
    }

    // Log MOTM
    if (state.selectedMotmId != null) {
      await repo.logMotm(
          matchId: matchId, squadItemId: state.selectedMotmId!);
    }

    // Finalize
    await repo.finalizeMatch(matchId);

    state = state.copyWith(isSaving: false);
    return null; // success
  }

  void reset() {
    state = const QuickTapState();
  }
}

final quickTapNotifierProvider =
    NotifierProvider<QuickTapNotifier, QuickTapState>(QuickTapNotifier.new);
