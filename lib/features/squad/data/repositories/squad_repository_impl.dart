import 'package:dartz/dartz.dart';
import 'package:eFootClash/core/errors/failures.dart';
import 'package:eFootClash/features/squad/data/datasources/squad_remote_datasource.dart';
import 'package:eFootClash/features/squad/domain/entities/player_card_entity.dart';
import 'package:eFootClash/features/squad/domain/entities/squad_item_entity.dart';
import 'package:eFootClash/features/squad/domain/repositories/squad_repository.dart';

class SquadRepositoryImpl implements SquadRepository {
  final SquadRemoteDatasource _datasource;

  SquadRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<PlayerCardEntity>>> searchCards(
    String query,
  ) async {
    try {
      final models = await _datasource.searchCards(query);
      return Right(models.map((m) => m.toEntity()).toList());
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SquadItemEntity>>> getUserSquad(
    String userId,
  ) async {
    try {
      final models = await _datasource.getUserSquad(userId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SquadItemEntity>> addCardToSquad({
    required String userId,
    required String masterCardId,
    required String position,
    required int slotIndex,
  }) async {
    try {
      final model = await _datasource.addCardToSquad(
        userId: userId,
        masterCardId: masterCardId,
        position: position,
        slotIndex: slotIndex,
      );
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeCardFromSquad(String squadItemId) async {
    try {
      await _datasource.removeCardFromSquad(squadItemId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateSquadItem({
    required String squadItemId,
    required String position,
    required int slotIndex,
  }) async {
    try {
      await _datasource.updateSquadItem(
        squadItemId: squadItemId,
        position: position,
        slotIndex: slotIndex,
      );
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }
}
