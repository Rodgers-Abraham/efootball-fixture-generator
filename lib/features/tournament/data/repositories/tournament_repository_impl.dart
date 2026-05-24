import 'package:dartz/dartz.dart';
import 'package:efootball_fixture_generator/core/errors/failures.dart';
import 'package:efootball_fixture_generator/features/tournament/data/datasources/tournament_remote_datasource.dart';
import 'package:efootball_fixture_generator/features/tournament/data/models/match_model.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/entities/bracket_entity.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/entities/match_entity.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/entities/tournament_entity.dart';
import 'package:efootball_fixture_generator/features/tournament/domain/repositories/tournament_repository.dart';

class TournamentRepositoryImpl implements TournamentRepository {
  final TournamentRemoteDatasource _datasource;

  TournamentRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<TournamentEntity>>> getTournaments() async {
    try {
      final models = await _datasource.getTournaments();
      return Right(models.map((m) => m.toEntity()).toList());
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TournamentEntity>> getTournament(String id) async {
    try {
      final model = await _datasource.getTournament(id);
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TournamentEntity>> createTournament({
    required String name,
    required String format,
    required String createdBy,
    required List<String> participantIds,
  }) async {
    try {
      final model = await _datasource.createTournament(
        name: name,
        format: format,
        createdBy: createdBy,
        participantIds: participantIds,
      );
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TournamentEntity>> updateTournamentStatus({
    required String id,
    required String status,
  }) async {
    try {
      final model = await _datasource.updateTournamentStatus(id: id, status: status);
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTournament(String id) async {
    try {
      await _datasource.deleteTournament(id);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TournamentEntity>> joinByCode({
    required String code,
    required String userId,
  }) async {
    try {
      final model = await _datasource.joinByCode(code: code, userId: userId);
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BracketEntity>> getBracket(String tournamentId) async {
    try {
      final tournament = await _datasource.getTournament(tournamentId);
      final matches = await _datasource.getMatches(tournamentId);

      // Group by round
      final roundMap = <int, List<MatchEntity>>{};
      for (final m in matches) {
        final round = roundMap.putIfAbsent(m.round, () => []);
        round.add(m.toEntity());
      }

      final roundNums = roundMap.keys.toList()..sort();
      final rounds = roundNums.map((r) => roundMap[r]!).toList();

      return Right(BracketEntity(
        tournamentId: tournamentId,
        format: tournament.format,
        rounds: rounds,
      ));
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MatchEntity>>> getMatches(
      String tournamentId) async {
    try {
      final models = await _datasource.getMatches(tournamentId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MatchEntity>> getMatch(String matchId) async {
    try {
      final model = await _datasource.getMatch(matchId);
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MatchEntity>>> saveMatches(
      List<MatchEntity> matches) async {
    try {
      final models =
          matches.map((e) => MatchModel.fromEntity(e)).toList();
      final saved = await _datasource.saveMatches(models);
      return Right(saved.map((m) => m.toEntity()).toList());
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final model = await _datasource.updateMatchResult(
        matchId: matchId,
        homeScore: homeScore,
        awayScore: awayScore,
        homePossession: homePossession,
        awayPossession: awayPossession,
        homeShots: homeShots,
        awayShots: awayShots,
        homeShotsOnTarget: homeShotsOnTarget,
        awayShotsOnTarget: awayShotsOnTarget,
        homeFouls: homeFouls,
        awayFouls: awayFouls,
      );
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }
}
