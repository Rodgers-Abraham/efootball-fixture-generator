import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:efootball_fixture_generator/core/utils/supabase_client.dart';
import 'package:efootball_fixture_generator/features/auth/presentation/providers/auth_provider.dart';
import 'package:efootball_fixture_generator/features/squad/data/datasources/squad_remote_datasource.dart';
import 'package:efootball_fixture_generator/features/squad/data/repositories/squad_repository_impl.dart';
import 'package:efootball_fixture_generator/features/squad/domain/entities/player_card_entity.dart';
import 'package:efootball_fixture_generator/features/squad/domain/entities/squad_item_entity.dart';
import 'package:efootball_fixture_generator/features/squad/domain/repositories/squad_repository.dart';

// ── Datasource & repository ────────────────────────────────────
final squadRemoteDatasourceProvider = Provider<SquadRemoteDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SquadRemoteDatasourceImpl(client);
});

final squadRepositoryProvider = Provider<SquadRepository>((ref) {
  final ds = ref.watch(squadRemoteDatasourceProvider);
  return SquadRepositoryImpl(ds);
});

// ── Card search ────────────────────────────────────────────────
final cardSearchQueryProvider = StateProvider<String>((ref) => '');

final cardSearchResultsProvider =
    FutureProvider.autoDispose<List<PlayerCardEntity>>((ref) async {
  final query = ref.watch(cardSearchQueryProvider);
  if (query.trim().isEmpty) return [];
  final repo = ref.watch(squadRepositoryProvider);
  final result = await repo.searchCards(query);
  return result.fold((_) => [], (cards) => cards);
});

// ── User squad ─────────────────────────────────────────────────
final userSquadProvider =
    AsyncNotifierProvider<UserSquadNotifier, List<SquadItemEntity>>(
        UserSquadNotifier.new);

class UserSquadNotifier extends AsyncNotifier<List<SquadItemEntity>> {
  @override
  Future<List<SquadItemEntity>> build() async {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    if (user == null) return [];
    final repo = ref.read(squadRepositoryProvider);
    final result = await repo.getUserSquad(user.id);
    return result.fold((_) => [], (items) => items);
  }

  Future<void> addCard({
    required String masterCardId,
    required String position,
    required int slotIndex,
  }) async {
    final user = ref.read(authNotifierProvider).valueOrNull;
    if (user == null) return;

    final repo = ref.read(squadRepositoryProvider);
    final result = await repo.addCardToSquad(
      userId: user.id,
      masterCardId: masterCardId,
      position: position,
      slotIndex: slotIndex,
    );

    result.fold(
      (_) {},
      (newItem) {
        final current = state.valueOrNull ?? [];
        // Replace existing item at slot, or add
        final updated = [
          ...current.where((i) => i.slotIndex != slotIndex),
          newItem,
        ]..sort((a, b) => a.slotIndex.compareTo(b.slotIndex));
        state = AsyncData(updated);
      },
    );
  }

  Future<void> removeCard(String squadItemId) async {
    final repo = ref.read(squadRepositoryProvider);
    final result = await repo.removeCardFromSquad(squadItemId);
    result.fold(
      (_) {},
      (_) {
        final current = state.valueOrNull ?? [];
        state = AsyncData(
          current.where((i) => i.squadItemId != squadItemId).toList(),
        );
      },
    );
  }
}
