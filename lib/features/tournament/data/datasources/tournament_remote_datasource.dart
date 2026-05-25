import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:efootball_fixture_generator/core/constants/app_constants.dart';
import 'package:efootball_fixture_generator/features/tournament/data/models/match_model.dart';
import 'package:efootball_fixture_generator/features/tournament/data/models/tournament_model.dart';

abstract class TournamentRemoteDatasource {
  Future<List<TournamentModel>> getTournaments();
  Future<TournamentModel> getTournament(String id);
  Future<TournamentModel> createTournament({
    required String name,
    required String format,
    required String createdBy,
    required List<String> participantIds,
  });
  Future<TournamentModel> joinByCode({
    required String code,
    required String userId,
  });
  Future<TournamentModel> updateTournamentStatus({
    required String id,
    required String status,
  });
  Future<void> deleteTournament(String id);
  Future<List<MatchModel>> getMatches(String tournamentId);
  Future<MatchModel> getMatch(String matchId);
  Future<List<MatchModel>> saveMatches(List<MatchModel> matches);
  Future<MatchModel> updateMatchResult({
    required String matchId,
    required int homeScore,
    required int awayScore,
    int? homePossession,
    int? awayPossession,
    int? homeShots,
    int? awayShots,
    int? homeShotsOnTarget,
    int? awayShotsOnTarget,
    int? homeFouls,
    int? awayFouls,
  });
}

class TournamentRemoteDatasourceImpl implements TournamentRemoteDatasource {
  final SupabaseClient _client;

  TournamentRemoteDatasourceImpl(this._client);

  @override
  Future<List<TournamentModel>> getTournaments() async {
    final rows = await _client
        .from(AppConstants.tournamentsTable)
        .select()
        .order('created_at', ascending: false);

    final tournaments = <TournamentModel>[];
    for (final row in rows) {
      final t = TournamentModel.fromJson(row);
      final participants = await _getParticipantIds(t.id);
      tournaments.add(t.copyWith(participantIds: participants));
    }
    return tournaments;
  }

  @override
  Future<TournamentModel> getTournament(String id) async {
    final row = await _client
        .from(AppConstants.tournamentsTable)
        .select()
        .eq('id', id)
        .single();

    final t = TournamentModel.fromJson(row);
    final participants = await _getParticipantIds(t.id);
    return t.copyWith(participantIds: participants);
  }

  @override
  Future<TournamentModel> createTournament({
    required String name,
    required String format,
    required String createdBy,
    required List<String> participantIds,
  }) async {
    final code = _generateInviteCode();

    final inserted = await _client
        .from(AppConstants.tournamentsTable)
        .insert({
          'name': name,
          'format': format,
          'created_by': createdBy,
          'status': 'pending',
          'invite_code': code,
        })
        .select()
        .single();

    final tournamentId = inserted['id'] as String;

    // Add participants
    if (participantIds.isNotEmpty) {
      final participantRows = participantIds
          .asMap()
          .entries
          .map((e) => {
                'tournament_id': tournamentId,
                'user_id': e.value,
                'seed': e.key + 1,
              })
          .toList();

      await _client
          .from(AppConstants.tournamentParticipantsTable)
          .insert(participantRows);
    }

    return TournamentModel.fromJson(inserted).copyWith(
      participantIds: participantIds,
    );
  }

  @override
  Future<TournamentModel> updateTournamentStatus({
    required String id,
    required String status,
  }) async {
    final updated = await _client
        .from(AppConstants.tournamentsTable)
        .update({'status': status})
        .eq('id', id)
        .select()
        .single();

    final t = TournamentModel.fromJson(updated);
    final participants = await _getParticipantIds(t.id);
    return t.copyWith(participantIds: participants);
  }

  @override
  Future<void> deleteTournament(String id) async {
    await _client
        .from(AppConstants.tournamentsTable)
        .delete()
        .eq('id', id);
  }

  @override
  Future<List<MatchModel>> getMatches(String tournamentId) async {
    final rows = await _client
        .from(AppConstants.matchesTable)
        .select()
        .eq('tournament_id', tournamentId)
        .order('round')
        .order('match_number');

    return rows.map((r) => MatchModel.fromJson(r)).toList();
  }

  @override
  Future<MatchModel> getMatch(String matchId) async {
    final row = await _client
        .from(AppConstants.matchesTable)
        .select()
        .eq('id', matchId)
        .single();

    return MatchModel.fromJson(row);
  }

  @override
  Future<List<MatchModel>> saveMatches(List<MatchModel> matches) async {
    final rows = matches
        .map((m) => {
              'tournament_id': m.tournamentId,
              'round': m.round,
              'match_number': m.matchNumber,
              'home_user_id': m.homeUserId,
              'away_user_id': m.awayUserId,
              'status': AppConstants.matchScheduled,
            })
        .toList();

    final inserted = await _client
        .from(AppConstants.matchesTable)
        .insert(rows)
        .select();

    return inserted.map((r) => MatchModel.fromJson(r)).toList();
  }

  @override
  Future<MatchModel> updateMatchResult({
    required String matchId,
    required int homeScore,
    required int awayScore,
    int? homePossession,
    int? awayPossession,
    int? homeShots,
    int? awayShots,
    int? homeShotsOnTarget,
    int? awayShotsOnTarget,
    int? homeFouls,
    int? awayFouls,
  }) async {
    final updated = await _client
        .from(AppConstants.matchesTable)
        .update({
          'home_score': homeScore,
          'away_score': awayScore,
          'home_possession': ?homePossession,
          'away_possession': ?awayPossession,
          'home_shots': ?homeShots,
          'away_shots': ?awayShots,
          'home_shots_on_target': ?homeShotsOnTarget,
          'away_shots_on_target': ?awayShotsOnTarget,
          'home_fouls': ?homeFouls,
          'away_fouls': ?awayFouls,
          'status': AppConstants.matchCompleted,
          'played_at': DateTime.now().toIso8601String(),
        })
        .eq('id', matchId)
        .select()
        .single();

    return MatchModel.fromJson(updated);
  }

  @override
  Future<TournamentModel> joinByCode({
    required String code,
    required String userId,
  }) async {
    final row = await _client
        .from(AppConstants.tournamentsTable)
        .select()
        .eq('invite_code', code.toUpperCase().trim())
        .single();

    final tournament = TournamentModel.fromJson(row);

    await _client.from(AppConstants.tournamentParticipantsTable).insert({
      'tournament_id': tournament.id,
      'user_id': userId,
    });

    final participants = await _getParticipantIds(tournament.id);
    return tournament.copyWith(participantIds: participants);
  }

  Future<List<String>> _getParticipantIds(String tournamentId) async {
    final rows = await _client
        .from(AppConstants.tournamentParticipantsTable)
        .select('user_id')
        .eq('tournament_id', tournamentId)
        .order('seed');

    return rows.map((r) => r['user_id'] as String).toList();
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rng = Random.secure();
    return String.fromCharCodes(
      List.generate(6, (_) => chars.codeUnitAt(rng.nextInt(chars.length))),
    );
  }
}
