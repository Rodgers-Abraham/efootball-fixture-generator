import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:efootball_fixture_generator/core/theme/app_colors.dart';

class LoginPromptDialog extends StatelessWidget {
  final String featureName;

  const LoginPromptDialog({super.key, required this.featureName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.lock_outline, color: AppColors.primary),
          const SizedBox(width: 12),
          const Text('Account Required'),
        ],
      ),
      content: Text(
        'You need to be signed in to $featureName. Create an account to save your progress, track trophies, and share tournaments!',
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('MAYBE LATER', style: TextStyle(color: AppColors.textDisabled)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            context.push('/login');
          },
          child: const Text('SIGN IN'),
        ),
      ],
    );
  }
}

void showLoginPrompt(BuildContext context, String featureName) {
  showDialog(
    context: context,
    builder: (context) => LoginPromptDialog(featureName: featureName),
  );
}
