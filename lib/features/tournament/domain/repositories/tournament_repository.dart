import 'package:dartz/dartz.dart';
import 'package:efootball_fixture_generator/core/errors/failures.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/entities/bracket_entity.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/entities/match_entity.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/entities/tournament_entity.dart';

abstract class TournamentRepository {
  // Tournaments
  Future<Either<Failure, List<TournamentEntity>>> getTournaments();
  Future<Either<Failure, TournamentEntity>> getTournament(String id);
  Future<Either<Failure, TournamentEntity>> createTournament({
    required String name,
    required String format,
    required String createdBy,
    required List<String> participantIds,
  });
  Future<Either<Failure, TournamentEntity>> updateTournamentStatus({
    required String id,
    required String status,
  });
  Future<Either<Failure, Unit>> deleteTournament(String id);
  Future<Either<Failure, TournamentEntity>> joinByCode({
    required String code,
    required String userId,
  });

  // Matches & bracket
  Future<Either<Failure, BracketEntity>> getBracket(String tournamentId);
  Future<Either<Failure, List<MatchEntity>>> getMatches(String tournamentId);
  Future<Either<Failure, MatchEntity>> getMatch(String matchId);
  Future<Either<Failure, List<MatchEntity>>> saveMatches(
      List<MatchEntity> matches);
  Future<Either<Failure, MatchEntity>> updateMatchResult({
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
