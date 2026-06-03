import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eFootClash/core/theme/app_colors.dart';
import 'package:eFootClash/features/ocr_scanner/domain/entities/match_stats_entity.dart';
import 'package:eFootClash/features/ocr_scanner/presentation/providers/ocr_provider.dart';

class ManualEntryScreen extends ConsumerStatefulWidget {
  const ManualEntryScreen({super.key});

  @override
  ConsumerState<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends ConsumerState<ManualEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _homeScoreCtrl = TextEditingController();
  final _awayScoreCtrl = TextEditingController();
  final _homePossCtrl = TextEditingController();
  final _awayPossCtrl = TextEditingController();
  final _homeShotsCtrl = TextEditingController();
  final _awayShotsCtrl = TextEditingController();
  final _homeSOTCtrl = TextEditingController();
  final _awaySOTCtrl = TextEditingController();
  final _homeFoulsCtrl = TextEditingController();
  final _awayFoulsCtrl = TextEditingController();

  @override
  void dispose() {
    for (final c in [
      _homeScoreCtrl,
      _awayScoreCtrl,
      _homePossCtrl,
      _awayPossCtrl,
      _homeShotsCtrl,
      _awayShotsCtrl,
      _homeSOTCtrl,
      _awaySOTCtrl,
      _homeFoulsCtrl,
      _awayFoulsCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final stats = MatchStatsEntity(
      homeScore: int.tryParse(_homeScoreCtrl.text) ?? 0,
      awayScore: int.tryParse(_awayScoreCtrl.text) ?? 0,
      homePossession: int.tryParse(_homePossCtrl.text),
      awayPossession: int.tryParse(_awayPossCtrl.text),
      homeShots: int.tryParse(_homeShotsCtrl.text),
      awayShots: int.tryParse(_awayShotsCtrl.text),
      homeShotsOnTarget: int.tryParse(_homeSOTCtrl.text),
      awayShotsOnTarget: int.tryParse(_awaySOTCtrl.text),
      homeFouls: int.tryParse(_homeFoulsCtrl.text),
      awayFouls: int.tryParse(_awayFoulsCtrl.text),
      confidence: 1.0,
    );

    ref.read(ocrNotifierProvider.notifier).setManualStats(stats);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Enter Match Stats')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Score row
            _sectionHeader('SCORE'),
            const SizedBox(height: 10),
            _twoColumnRow(
              leftController: _homeScoreCtrl,
              rightController: _awayScoreCtrl,
              leftLabel: 'Home',
              rightLabel: 'Away',
              required: true,
            ),
            const SizedBox(height: 20),

            _sectionHeader('POSSESSION (%)'),
            const SizedBox(height: 10),
            _twoColumnRow(
              leftController: _homePossCtrl,
              rightController: _awayPossCtrl,
              leftLabel: 'Home %',
              rightLabel: 'Away %',
            ),
            const SizedBox(height: 20),

            _sectionHeader('TOTAL SHOTS'),
            const SizedBox(height: 10),
            _twoColumnRow(
              leftController: _homeShotsCtrl,
              rightController: _awayShotsCtrl,
              leftLabel: 'Home',
              rightLabel: 'Away',
            ),
            const SizedBox(height: 20),

            _sectionHeader('SHOTS ON TARGET'),
            const SizedBox(height: 10),
            _twoColumnRow(
              leftController: _homeSOTCtrl,
              rightController: _awaySOTCtrl,
              leftLabel: 'Home',
              rightLabel: 'Away',
            ),
            const SizedBox(height: 20),

            _sectionHeader('FOULS'),
            const SizedBox(height: 10),
            _twoColumnRow(
              leftController: _homeFoulsCtrl,
              rightController: _awayFoulsCtrl,
              leftLabel: 'Home',
              rightLabel: 'Away',
            ),
            const SizedBox(height: 36),

            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('CONFIRM STATS'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _twoColumnRow({
    required TextEditingController leftController,
    required TextEditingController rightController,
    required String leftLabel,
    required String rightLabel,
    bool required = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: leftController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(labelText: leftLabel),
            validator: required
                ? (v) => (v == null || v.isEmpty) ? 'Required' : null
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: rightController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(labelText: rightLabel),
            validator: required
                ? (v) => (v == null || v.isEmpty) ? 'Required' : null
                : null,
          ),
        ),
      ],
    );
  }
}
