import 'dart:io';
import 'dart:ui' show Rect;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:efootball_fixture_generator/core/constants/app_constants.dart';
import 'package:efootball_fixture_generator/features/ocr_scanner/domain/entities/match_stats_entity.dart';

class OcrLocalDatasource {
  /// Scans [imageFile] with ML Kit text recognition and extracts match stats.
  Future<MatchStatsEntity> scanMatchResult(File imageFile) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await recognizer.processImage(inputImage);

      return _parseStats(recognizedText);
    } finally {
      recognizer.close();
    }
  }

  MatchStatsEntity _parseStats(RecognizedText recognizedText) {
    // Collect all text blocks with their bounding rects
    final allBlocks = <_TextBlock>[];
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        for (final element in line.elements) {
          // Fixed unnecessary_null_comparison and unnecessary_non_null_assertion
          allBlocks.add(_TextBlock(
            text: element.text,
            rect: element.boundingBox,
          ));
        }
      }
    }

    // Also collect line-level text for pattern matching
    final allLines = <String>[];
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        allLines.add(line.text.trim());
      }
    }

    final fullText = allLines.join('\n');

    int? homeScore;
    int? awayScore;
    int? homePossession;
    int? awayPossession;
    int? homeShots;
    int? awayShots;
    int? homeShotsOnTarget;
    int? awayShotsOnTarget;
    int? homeFouls;
    int? awayFouls;

    // ── Score pattern ──────────────────────────────────────────
    final scoreMatch = RegExp(r'\b(\d+)\s*-\s*(\d+)\b').firstMatch(fullText);
    if (scoreMatch != null) {
      homeScore = int.tryParse(scoreMatch.group(1)!);
      awayScore = int.tryParse(scoreMatch.group(2)!);
    }

    // ── Helper: find stat values near an anchor keyword ────────
    // Strategy: find the anchor block, then find the nearest numeric
    // blocks to its left and right (or above/below) by Y proximity.
    // Fixed no_leading_underscores_for_local_identifiers
    List<int?> extractStatPair(String anchorKeyword) {
      // Find anchor in blocks
      _TextBlock? anchor;
      for (final b in allBlocks) {
        if (b.text.toLowerCase().contains(anchorKeyword.toLowerCase())) {
          anchor = b;
          break;
        }
      }

      if (anchor == null) {
        // Try line-level
        for (int i = 0; i < allLines.length; i++) {
          if (allLines[i].toLowerCase().contains(anchorKeyword.toLowerCase())) {
            // Look at previous and next lines for numbers
            final nums = <int?>[];
            // Try to find numbers on the same or adjacent lines
            for (int j = i - 2; j <= i + 2; j++) {
              if (j < 0 || j >= allLines.length) continue;
              final matches =
                  RegExp(r'\b(\d+)%?\b').allMatches(allLines[j]);
              for (final m in matches) {
                final val = int.tryParse(m.group(1)!);
                if (val != null && val <= 100) nums.add(val);
              }
            }
            if (nums.length >= 2) {
              return [nums[0], nums[1]];
            }
          }
        }
        return [null, null];
      }

      final anchorY = anchor.rect.center.dy;
      final anchorX = anchor.rect.center.dx;

      // Find numeric blocks near the anchor's Y
      final nearbyNums = allBlocks
          .where((b) {
            if (b == anchor) return false;
            final num = int.tryParse(b.text.replaceAll('%', ''));
            return num != null &&
                (b.rect.center.dy - anchorY).abs() < 40;
          })
          .toList()
        ..sort((a, b) => a.rect.center.dx.compareTo(b.rect.center.dx));

      if (nearbyNums.isEmpty) return [null, null];

      // Separate left (home) and right (away) of anchor
      final leftNums =
          nearbyNums.where((b) => b.rect.center.dx < anchorX).toList();
      final rightNums =
          nearbyNums.where((b) => b.rect.center.dx > anchorX).toList();

      int? left = leftNums.isNotEmpty
          ? int.tryParse(leftNums.last.text.replaceAll('%', ''))
          : null;
      int? right = rightNums.isNotEmpty
          ? int.tryParse(rightNums.first.text.replaceAll('%', ''))
          : null;

      // If no spatial info, fall back to first two numbers found
      if (left == null && right == null && nearbyNums.length >= 2) {
        left = int.tryParse(nearbyNums[0].text.replaceAll('%', ''));
        right = int.tryParse(nearbyNums[1].text.replaceAll('%', ''));
      }

      return [left, right];
    }

    // ── Possession ─────────────────────────────────────────────
    final possession = extractStatPair('Possession');
    if (possession[0] != null &&
        possession[1] != null &&
        (possession[0]! + possession[1]!) <= 105) {
      homePossession = possession[0];
      awayPossession = possession[1];
    }

    // ── Total Shots ────────────────────────────────────────────
    final shots = extractStatPair('Total Shots');
    homeShots = shots[0];
    awayShots = shots[1];
    if (homeShots == null) {
      final shots2 = extractStatPair('Shots');
      homeShots = shots2[0];
      awayShots = shots2[1];
    }

    // ── Shots on Target ────────────────────────────────────────
    final sot = extractStatPair('Shots on Target');
    homeShotsOnTarget = sot[0];
    awayShotsOnTarget = sot[1];
    if (homeShotsOnTarget == null) {
      final sot2 = extractStatPair('on Target');
      homeShotsOnTarget = sot2[0];
      awayShotsOnTarget = sot2[1];
    }

    // ── Fouls ──────────────────────────────────────────────────
    final fouls = extractStatPair('Fouls');
    homeFouls = fouls[0];
    awayFouls = fouls[1];

    // ── Confidence ─────────────────────────────────────────────
    int parsed = 0;
    if (homeScore != null) parsed++;
    if (awayScore != null) parsed++;
    if (homePossession != null) parsed++;
    if (awayPossession != null) parsed++;
    if (homeShots != null) parsed++;
    if (awayShots != null) parsed++;
    if (homeShotsOnTarget != null) parsed++;
    if (awayShotsOnTarget != null) parsed++;
    if (homeFouls != null || awayFouls != null) parsed++;

    final confidence = parsed / AppConstants.ocrTotalFields;

    if (confidence < AppConstants.ocrMinConfidence) {
      throw OcrFailure(
        message:
            'Could not confidently parse match stats. Confidence: ${(confidence * 100).toStringAsFixed(0)}%. Please enter manually.',
        confidence: confidence,
      );
    }

    return MatchStatsEntity(
      homeScore: homeScore ?? 0,
      awayScore: awayScore ?? 0,
      homePossession: homePossession,
      awayPossession: awayPossession,
      homeShots: homeShots,
      awayShots: awayShots,
      homeShotsOnTarget: homeShotsOnTarget,
      awayShotsOnTarget: awayShotsOnTarget,
      homeFouls: homeFouls,
      awayFouls: awayFouls,
      confidence: confidence,
    );
  }
}

class _TextBlock {
  final String text;
  final Rect rect;

  const _TextBlock({required this.text, required this.rect});
}

// Re-export failure so it can be caught
class OcrFailure implements Exception {
  final String message;
  final double confidence;
  const OcrFailure({required this.message, this.confidence = 0.0});
  @override
  String toString() => message;
}
