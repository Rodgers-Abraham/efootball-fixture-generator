import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:efootball_fixture_generator/core/errors/failures.dart';
import 'package:efootball_fixture_generator/features/ocr_scanner/domain/entities/match_stats_entity.dart';

abstract class OcrRepository {
  Future<Either<Failure, MatchStatsEntity>> scanMatchResult(File imageFile);
}
