import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:efootball_fixture_generator/core/theme/app_colors.dart';
import 'package:efootball_fixture_generator/features/tournament/presentation/providers/tournament_provider.dart';

Future<void> showJoinCodeDialog(BuildContext context, WidgetRef ref) {
  return showDialog(
    context: context,
    builder: (ctx) => _JoinCodeDialog(ref: ref),
  );
}

class _JoinCodeDialog extends StatefulWidget {
  final WidgetRef ref;
  const _JoinCodeDialog({required this.ref});

  @override
  State<_JoinCodeDialog> createState() => _JoinCodeDialogState();
}

class _JoinCodeDialogState extends State<_JoinCodeDialog> {
  final _ctrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    final code = _ctrl.text.trim().toUpperCase();
    if (code.length != 6) {
      setState(() => _error = 'Enter a valid 6-character code');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await widget.ref
        .read(tournamentListProvider.notifier)
        .joinByCode(code);

    if (!mounted) return;
    setState(() => _loading = false);

    if (result.error != null) {
      setState(() => _error = result.error);
    } else {
      Navigator.of(context).pop();
      context.push('/tournament/${result.tournament!.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.qr_code_scanner_outlined, color: AppColors.primary),
          SizedBox(width: 10),
          Text('Join Tournament',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 18)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter the 6-character invite code shared by the tournament creator.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            maxLength: 6,
            textCapitalization: TextCapitalization.characters,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 8,
            ),
            decoration: InputDecoration(
              hintText: 'ABC123',
              hintStyle: TextStyle(
                color: AppColors.textDisabled,
                fontSize: 24,
                letterSpacing: 8,
              ),
              counterText: '',
              errorText: _error,
            ),
            onChanged: (v) {
              final upper = v.toUpperCase();
              if (upper != v) {
                _ctrl.value = _ctrl.value.copyWith(
                  text: upper,
                  selection: TextSelection.collapsed(offset: upper.length),
                );
              }
              if (_error != null) setState(() => _error = null);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _join,
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('JOIN'),
        ),
      ],
    );
  }
}
