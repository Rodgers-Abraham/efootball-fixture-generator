import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:efootball_fixture_generator/core/constants/app_constants.dart';
import 'package:efootball_fixture_generator/features/squad/data/models/player_card_model.dart';
import 'package:efootball_fixture_generator/features/squad/data/models/squad_item_model.dart';

abstract class SquadRemoteDatasource {
  Future<List<PlayerCardModel>> searchCards(String query);

  Future<List<SquadItemModel>> getUserSquad(String userId);

  Future<SquadItemModel> addCardToSquad({
    required String userId,
    required String masterCardId,
    required String position,
    required int slotIndex,
  });

  Future<void> removeCardFromSquad(String squadItemId);

  Future<void> updateSquadItem({
    required String squadItemId,
    required String position,
    required int slotIndex,
  });
}

class SquadRemoteDatasourceImpl implements SquadRemoteDatasource {
  final SupabaseClient _client;

  SquadRemoteDatasourceImpl(this._client);

  @override
  Future<List<PlayerCardModel>> searchCards(String query) async {
    final rows = await _client
        .from(AppConstants.playerCardsTable)
        .select()
        .ilike('player_name', '%$query%')
        .order('max_rating', ascending: false)
        .limit(AppConstants.defaultPageSize);

    return rows.map((r) => PlayerCardModel.fromJson(r)).toList();
  }

  @override
  Future<List<SquadItemModel>> getUserSquad(String userId) async {
    final rows = await _client
        .from(AppConstants.squadItemsTable)
        .select('*, player_cards(*)')
        .eq('user_id', userId)
        .order('slot_index');

    return rows.map((r) => SquadItemModel.fromJson(r)).toList();
  }

  @override
  Future<SquadItemModel> addCardToSquad({
    required String userId,
    required String masterCardId,
    required String position,
    required int slotIndex,
  }) async {
    final inserted = await _client
        .from(AppConstants.squadItemsTable)
        .insert({
          'user_id': userId,
          'master_card_id': masterCardId,
          'position': position,
          'slot_index': slotIndex,
        })
        .select('*, player_cards(*)')
        .single();

    return SquadItemModel.fromJson(inserted);
  }

  @override
  Future<void> removeCardFromSquad(String squadItemId) async {
    await _client
        .from(AppConstants.squadItemsTable)
        .delete()
        .eq('squad_item_id', squadItemId);
  }

  @override
  Future<void> updateSquadItem({
    required String squadItemId,
    required String position,
    required int slotIndex,
  }) async {
    await _client.from(AppConstants.squadItemsTable).update({
      'position': position,
      'slot_index': slotIndex,
    }).eq('squad_item_id', squadItemId);
  }
}
