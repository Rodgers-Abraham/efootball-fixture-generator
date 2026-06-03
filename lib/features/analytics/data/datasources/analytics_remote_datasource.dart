import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eFootClash/core/constants/app_constants.dart';
import 'package:eFootClash/features/analytics/domain/entities/leaderboard_entry_entity.dart';

abstract class AnalyticsRemoteDatasource {
  Future<List<LeaderboardEntryEntity>> getGoldenBoot(String tournamentId);
  Future<List<LeaderboardEntryEntity>> getMotmLeaderboard(String tournamentId);
}

class AnalyticsRemoteDatasourceImpl implements AnalyticsRemoteDatasource {
  final SupabaseClient _client;

  AnalyticsRemoteDatasourceImpl(this._client);

  @override
  Future<List<LeaderboardEntryEntity>> getGoldenBoot(
    String tournamentId,
  ) async {
    // Fetch all goal events for this tournament, join through squad_items and
    // player_cards, then aggregate in Dart.
    final rows = await _client
        .from(AppConstants.matchEventsTable)
        .select('''
          id,
          event_type,
          squad_item_id,
          squad_items!inner(
            user_id,
            player_cards!inner(
              player_name,
              card_type,
              card_image_url
            ),
            users!inner(team_tag)
          ),
          matches!inner(tournament_id)
        ''')
        .eq('event_type', AppConstants.eventGoal)
        .eq('matches.tournament_id', tournamentId);

    // Aggregate by squad_item_id
    final counts = <String, int>{};
    final meta = <String, Map<String, dynamic>>{};

    for (final row in rows) {
      final squadItemId = row['squad_item_id'] as String;
      counts[squadItemId] = (counts[squadItemId] ?? 0) + 1;
      if (!meta.containsKey(squadItemId)) {
        meta[squadItemId] = row;
      }
    }

    final entries = <LeaderboardEntryEntity>[];
    var rank = 1;
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sorted) {
      final row = meta[entry.key]!;
      final squadItem = row['squad_items'] as Map<String, dynamic>;
      final card = squadItem['player_cards'] as Map<String, dynamic>;
      final user = squadItem['users'] as Map<String, dynamic>;

      entries.add(
        LeaderboardEntryEntity(
          rank: rank++,
          playerName: card['player_name'] as String,
          teamTag: user['team_tag'] as String,
          cardType: card['card_type'] as String,
          goals: entry.value,
          cardImageUrl: card['card_image_url'] as String?,
          squadItemId: entry.key,
        ),
      );
    }

    return entries;
  }

  @override
  Future<List<LeaderboardEntryEntity>> getMotmLeaderboard(
    String tournamentId,
  ) async {
    final rows = await _client
        .from(AppConstants.matchEventsTable)
        .select('''
          id,
          event_type,
          squad_item_id,
          squad_items!inner(
            user_id,
            player_cards!inner(
              player_name,
              card_type,
              card_image_url
            ),
            users!inner(team_tag)
          ),
          matches!inner(tournament_id)
        ''')
        .eq('event_type', AppConstants.eventMotm)
        .eq('matches.tournament_id', tournamentId);

    final counts = <String, int>{};
    final meta = <String, Map<String, dynamic>>{};

    for (final row in rows) {
      final squadItemId = row['squad_item_id'] as String;
      counts[squadItemId] = (counts[squadItemId] ?? 0) + 1;
      if (!meta.containsKey(squadItemId)) {
        meta[squadItemId] = row;
      }
    }

    final entries = <LeaderboardEntryEntity>[];
    var rank = 1;
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sorted) {
      final row = meta[entry.key]!;
      final squadItem = row['squad_items'] as Map<String, dynamic>;
      final card = squadItem['player_cards'] as Map<String, dynamic>;
      final user = squadItem['users'] as Map<String, dynamic>;

      entries.add(
        LeaderboardEntryEntity(
          rank: rank++,
          playerName: card['player_name'] as String,
          teamTag: user['team_tag'] as String,
          cardType: card['card_type'] as String,
          motmCount: entry.value,
          cardImageUrl: card['card_image_url'] as String?,
          squadItemId: entry.key,
        ),
      );
    }

    return entries;
  }
}
