import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:eFootClash/core/errors/failures.dart';
import 'package:eFootClash/features/ocr_scanner/domain/entities/match_stats_entity.dart';

abstract class OcrRepository {
  Future<Either<Failure, MatchStatsEntity>> scanMatchResult(File imageFile);
}
