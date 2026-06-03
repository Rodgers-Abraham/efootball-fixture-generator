import 'package:dartz/dartz.dart';
import 'package:eFootClash/core/errors/failures.dart';
import 'package:eFootClash/features/squad/domain/entities/player_card_entity.dart';
import 'package:eFootClash/features/squad/domain/entities/squad_item_entity.dart';

abstract class SquadRepository {
  Future<Either<Failure, List<PlayerCardEntity>>> searchCards(String query);

  Future<Either<Failure, List<SquadItemEntity>>> getUserSquad(String userId);

  Future<Either<Failure, SquadItemEntity>> addCardToSquad({
    required String userId,
    required String masterCardId,
    required String position,
    required int slotIndex,
  });

  Future<Either<Failure, Unit>> removeCardFromSquad(String squadItemId);

  Future<Either<Failure, Unit>> updateSquadItem({
    required String squadItemId,
    required String position,
    required int slotIndex,
  });
}
