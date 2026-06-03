import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eFootClash/core/errors/failures.dart';
import 'package:eFootClash/core/theme/app_colors.dart';
import 'package:eFootClash/features/ocr_scanner/presentation/providers/ocr_provider.dart';
import 'package:eFootClash/features/ocr_scanner/presentation/screens/manual_entry_screen.dart';
import 'package:eFootClash/features/tournament/presentation/providers/tournament_provider.dart';

class OcrScannerScreen extends ConsumerStatefulWidget {
  final String tournamentId;
  final String matchId;

  const OcrScannerScreen({
    super.key,
    required this.tournamentId,
    required this.matchId,
  });

  @override
  ConsumerState<OcrScannerScreen> createState() => _OcrScannerScreenState();
}

class _OcrScannerScreenState extends ConsumerState<OcrScannerScreen> {
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final xFile = await _picker.pickImage(source: source, imageQuality: 95);
    if (xFile == null) return;
    await ref.read(ocrNotifierProvider.notifier).scan(File(xFile.path));
  }

  Future<void> _confirmAndProceed() async {
    final stats = ref.read(ocrNotifierProvider).stats;
    if (stats == null) return;

    final repo = ref.read(tournamentRepositoryProvider);
    final result = await repo.updateMatchResult(
      matchId: widget.matchId,
      homeScore: stats.homeScore,
      awayScore: stats.awayScore,
      homePossession: stats.homePossession,
      awayPossession: stats.awayPossession,
      homeShots: stats.homeShots,
      awayShots: stats.awayShots,
      homeShotsOnTarget: stats.homeShotsOnTarget,
      awayShotsOnTarget: stats.awayShotsOnTarget,
      homeFouls: stats.homeFouls,
      awayFouls: stats.awayFouls,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.displayMessage)));
      },
      (_) {
        ref.read(ocrNotifierProvider.notifier).reset();
        context.go(
          '/tournament/${widget.tournamentId}/match/${widget.matchId}/quick-tap',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(ocrNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Scan Result'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ManualEntryScreen()),
            ),
            child: const Text('Manual Entry'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image preview
            _buildImagePreview(scanState),
            const SizedBox(height: 20),

            // Action buttons
            _buildActionButtons(scanState.isScanning),
            const SizedBox(height: 24),

            // Scanning animation / result
            if (scanState.isScanning) _buildScanningIndicator(),
            if (scanState.errorMessage != null)
              _buildErrorCard(scanState.errorMessage!),
            if (scanState.stats != null) ...[
              _buildStatsCard(scanState),
              const SizedBox(height: 20),
              _buildConfidenceMeter(scanState.stats!.confidence),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _confirmAndProceed,
                child: const Text('CONFIRM & CONTINUE'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ManualEntryScreen()),
                ),
                child: const Text('EDIT MANUALLY'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(OcrScanState state) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 260,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: state.stats != null ? AppColors.accentVolt : AppColors.border,
          width: state.stats != null ? 2 : 1,
        ),
        boxShadow: state.stats != null
            ? [
                BoxShadow(
                  color: AppColors.accentVolt.withValues(alpha: 0.25),
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: state.selectedImage != null
          ? Image.file(state.selectedImage!, fit: BoxFit.cover)
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_search,
                  color: AppColors.textDisabled,
                  size: 64,
                ),
                const SizedBox(height: 12),
                const Text(
                  'No image selected',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
    );
  }

  Widget _buildActionButtons(bool isScanning) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isScanning ? null : () => _pickImage(ImageSource.camera),
            icon: const Icon(Icons.camera_alt_outlined, size: 18),
            label: const Text('Take Photo'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isScanning
                ? null
                : () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.upload_outlined, size: 18),
            label: const Text('Upload'),
          ),
        ),
      ],
    );
  }

  Widget _buildScanningIndicator() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Shimmer scan line animation
          Container(
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.accentVolt,
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              )
              .animate(onPlay: (c) => c.repeat())
              .shimmer(duration: 1200.ms, color: AppColors.accentVolt),
          const SizedBox(height: 16),
          const Text(
            'Scanning match data...',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          const LinearProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warning,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ManualEntryScreen(),
                    ),
                  ),
                  child: const Text('Enter Manually'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(OcrScanState state) {
    final s = state.stats!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Score
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${s.homeScore}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '-',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 28,
                  ),
                ),
              ),
              Text(
                '${s.awayScore}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _statRow(
            'Possession',
            s.homePossession,
            s.awayPossession,
            suffix: '%',
          ),
          _statRow('Total Shots', s.homeShots, s.awayShots),
          _statRow('Shots on Target', s.homeShotsOnTarget, s.awayShotsOnTarget),
          _statRow('Fouls', s.homeFouls, s.awayFouls),
        ],
      ),
    );
  }

  Widget _statRow(String label, int? home, int? away, {String suffix = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              home != null ? '$home$suffix' : '-',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              away != null ? '$away$suffix' : '-',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceMeter(double confidence) {
    final pct = (confidence * 100).toInt();
    final color = confidence >= 0.9
        ? AppColors.success
        : confidence >= 0.75
        ? AppColors.warning
        : AppColors.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'OCR CONFIDENCE',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              '$pct%',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: confidence,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
