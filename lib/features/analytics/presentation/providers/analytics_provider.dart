import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:efootball_fixture_generator/core/utils/supabase_client.dart';
import 'package:efootball_fixture_generator/features/analytics/data/datasources/analytics_remote_datasource.dart';
import 'package:efootball_fixture_generator/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:efootball_fixture_generator/features/analytics/domain/entities/leaderboard_entry_entity.dart';
import 'package:efootball_fixture_generator/features/analytics/domain/repositories/analytics_repository.dart';

// ── Infrastructure ─────────────────────────────────────────────
final analyticsRemoteDatasourceProvider =
    Provider<AnalyticsRemoteDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AnalyticsRemoteDatasourceImpl(client);
});

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  final ds = ref.watch(analyticsRemoteDatasourceProvider);
  return AnalyticsRepositoryImpl(ds);
});

// ── Leaderboards ───────────────────────────────────────────────
final goldenBootProvider =
    FutureProvider.autoDispose.family<List<LeaderboardEntryEntity>, String>(
  (ref, tournamentId) async {
    final repo = ref.watch(analyticsRepositoryProvider);
    final result = await repo.getGoldenBoot(tournamentId);
    return result.fold((_) => [], (list) => list);
  },
);

final motmLeaderboardProvider =
    FutureProvider.autoDispose.family<List<LeaderboardEntryEntity>, String>(
  (ref, tournamentId) async {
    final repo = ref.watch(analyticsRepositoryProvider);
    final result = await repo.getMotmLeaderboard(tournamentId);
    return result.fold((_) => [], (list) => list);
  },
);
