import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:efootball_fixture_generator/core/errors/failures.dart';
import 'package:efootball_fixture_generator/features/ocr_scanner/data/datasources/ocr_local_datasource.dart';
import 'package:efootball_fixture_generator/features/ocr_scanner/data/repositories/ocr_repository_impl.dart';
import 'package:efootball_fixture_generator/features/ocr_scanner/domain/entities/match_stats_entity.dart';
import 'package:efootball_fixture_generator/features/ocr_scanner/domain/repositories/ocr_repository.dart';

// ── Infrastructure ─────────────────────────────────────────────
final ocrLocalDatasourceProvider = Provider<OcrLocalDatasource>(
    (_) => OcrLocalDatasource());

final ocrRepositoryProvider = Provider<OcrRepository>((ref) {
  final ds = ref.watch(ocrLocalDatasourceProvider);
  return OcrRepositoryImpl(ds);
});

// ── Scan state ─────────────────────────────────────────────────
class OcrScanState {
  final File? selectedImage;
  final MatchStatsEntity? stats;
  final String? errorMessage;
  final bool isScanning;

  const OcrScanState({
    this.selectedImage,
    this.stats,
    this.errorMessage,
    this.isScanning = false,
  });

  OcrScanState copyWith({
    File? selectedImage,
    MatchStatsEntity? stats,
    String? errorMessage,
    bool? isScanning,
    bool clearStats = false,
    bool clearError = false,
    bool clearImage = false,
  }) {
    return OcrScanState(
      selectedImage: clearImage ? null : selectedImage ?? this.selectedImage,
      stats: clearStats ? null : stats ?? this.stats,
      errorMessage:
          clearError ? null : errorMessage ?? this.errorMessage,
      isScanning: isScanning ?? this.isScanning,
    );
  }
}

class OcrNotifier extends Notifier<OcrScanState> {
  @override
  OcrScanState build() => const OcrScanState();

  Future<void> scan(File imageFile) async {
    state = state.copyWith(
      selectedImage: imageFile,
      isScanning: true,
      clearStats: true,
      clearError: true,
    );

    final repo = ref.read(ocrRepositoryProvider);
    final result = await repo.scanMatchResult(imageFile);

    result.fold(
      (failure) {
        state = state.copyWith(
          isScanning: false,
          errorMessage: failure.displayMessage,
          clearStats: true,
        );
      },
      (stats) {
        state = state.copyWith(
          isScanning: false,
          stats: stats,
          clearError: true,
        );
      },
    );
  }

  void setManualStats(MatchStatsEntity stats) {
    state = state.copyWith(stats: stats, clearError: true);
  }

  void reset() {
    state = const OcrScanState();
  }
}

final ocrNotifierProvider =
    NotifierProvider<OcrNotifier, OcrScanState>(OcrNotifier.new);
