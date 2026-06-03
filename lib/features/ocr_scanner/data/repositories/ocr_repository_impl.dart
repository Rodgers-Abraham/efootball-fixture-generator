import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:eFootClash/core/errors/failures.dart';
import 'package:eFootClash/features/ocr_scanner/data/datasources/ocr_local_datasource.dart'
    as ds;
import 'package:eFootClash/features/ocr_scanner/domain/entities/match_stats_entity.dart';
import 'package:eFootClash/features/ocr_scanner/domain/repositories/ocr_repository.dart';

class OcrRepositoryImpl implements OcrRepository {
  final ds.OcrLocalDatasource _datasource;

  OcrRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, MatchStatsEntity>> scanMatchResult(
    File imageFile,
  ) async {
    try {
      final stats = await _datasource.scanMatchResult(imageFile);
      return Right(stats);
    } on ds.OcrFailure catch (e) {
      return Left(Failure.ocr(message: e.message, confidence: e.confidence));
    } catch (e) {
      return Left(Failure.ocr(message: e.toString()));
    }
  }
}
