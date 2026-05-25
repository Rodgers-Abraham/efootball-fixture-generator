import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:efootball_fixture_generator/core/utils/supabase_client.dart';
import 'package:efootball_fixture_generator/features/quick_tap/data/datasources/quick_tap_remote_datasource.dart';
import 'package:efootball_fixture_generator/features/quick_tap/data/repositories/quick_tap_repository_impl.dart';
import 'package:efootball_fixture_generator/features/quick_tap/domain/repositories/quick_tap_repository.dart';
import 'package:efootball_fixture_generator/features/tournament/presentation/providers/tournament_provider.dart';

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

// ── Quick-tap state ──────────────────────────────────────────
class QuickTapState {
  final Map<String, int> goals;
  final String? motmSquadItemId;
  final bool isSaving;

  const QuickTapState({
    this.goals = const {},
    this.motmSquadItemId,
    this.isSaving = false,
  });

  QuickTapState copyWith({
    Map<String, int>? goals,
    String? motmSquadItemId,
    bool? isSaving,
  }) {
    return QuickTapState(
      goals: goals ?? this.goals,
      motmSquadItemId: motmSquadItemId ?? this.motmSquadItemId,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class QuickTapNotifier extends FamilyNotifier<QuickTapState, String> {
  @override
  QuickTapState build(String arg) => const QuickTapState();

  void incrementGoal(String squadItemId) {
    final newGoals = Map<String, int>.from(state.goals);
    newGoals[squadItemId] = (newGoals[squadItemId] ?? 0) + 1;
    state = state.copyWith(goals: newGoals);
  }

  void setMotm(String squadItemId) {
    state = state.copyWith(motmSquadItemId: squadItemId);
  }

  Future<bool> saveResults(String tournamentId) async {
    state = state.copyWith(isSaving: true);
    final repo = ref.read(quickTapRepositoryProvider);
    final matchId = arg;

    try {
      // 1. Clear existing events
      await repo.clearEventsForMatch(matchId);

      // 2. Save goals
      for (final entry in state.goals.entries) {
        for (int i = 0; i < entry.value; i++) {
          await repo.logGoal(matchId: matchId, squadItemId: entry.key);
        }
      }

      // 3. Save MOTM
      if (state.motmSquadItemId != null) {
        await repo.logMotm(matchId: matchId, squadItemId: state.motmSquadItemId!);
      }

      // 4. Update match total scores and finalize
      // We calculate totals based on state.goals
      // Note: This logic assumes we know which squad item belongs to home/away.
      // For simplicity in this UI-first refactor, we let the backend or repository 
      // handle the final match object aggregation if needed, or we fetch the match here.
      
      await repo.finalizeMatch(matchId);
      
      // Invalidate relevant providers
      ref.invalidate(matchesProvider(tournamentId));
      ref.invalidate(matchProvider(matchId));
      
      return true;
    } catch (_) {
      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}

final quickTapNotifierProvider =
    NotifierProvider.family<QuickTapNotifier, QuickTapState, String>(
        QuickTapNotifier.new);
