import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eFootClash/core/constants/app_constants.dart';
import 'package:eFootClash/features/quick_tap/data/models/goal_event_model.dart';

abstract class QuickTapRemoteDatasource {
  Future<GoalEventModel> logEvent({
    required String matchId,
    required String squadItemId,
    required String eventType,
  });

  Future<void> clearEventsForMatch(String matchId);

  Future<void> finalizeMatch(String matchId);
}

class QuickTapRemoteDatasourceImpl implements QuickTapRemoteDatasource {
  final SupabaseClient _client;

  QuickTapRemoteDatasourceImpl(this._client);

  @override
  Future<GoalEventModel> logEvent({
    required String matchId,
    required String squadItemId,
    required String eventType,
  }) async {
    final inserted = await _client
        .from(AppConstants.matchEventsTable)
        .insert({
          'match_id': matchId,
          'squad_item_id': squadItemId,
          'event_type': eventType,
        })
        .select()
        .single();

    return GoalEventModel.fromJson(inserted);
  }

  @override
  Future<void> clearEventsForMatch(String matchId) async {
    await _client
        .from(AppConstants.matchEventsTable)
        .delete()
        .eq('match_id', matchId);
  }

  @override
  Future<void> finalizeMatch(String matchId) async {
    await _client
        .from(AppConstants.matchesTable)
        .update({
          'status': AppConstants.matchCompleted,
          'played_at': DateTime.now().toIso8601String(),
        })
        .eq('id', matchId);
  }
}
