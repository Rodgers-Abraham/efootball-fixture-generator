import 'package:flutter/material.dart';
import 'package:efootball_fixture_generator/core/theme/app_colors.dart';
import 'package:efootball_fixture_generator/features/squad/domain/entities/squad_item_entity.dart';

/// Tappable player chip for the Quick-Tap dashboard.
/// [count] = goals for this player (shows badge when > 0)
/// [isMotmSelected] = highlighted as MOTM
/// [onTap] = increment goal / select MOTM
/// [onLongPress] = decrement goal (optional)
class PlayerTapChip extends StatelessWidget {
  final SquadItemEntity squadItem;
  final int count;
  final bool isMotmSelected;
  final bool isMotmMode;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const PlayerTapChip({
    super.key,
    required this.squadItem,
    this.count = 0,
    this.isMotmSelected = false,
    this.isMotmMode = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final active = isMotmMode ? isMotmSelected : count > 0;
    final card = squadItem.card;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isMotmSelected
                ? const Color(0xFFFFD700)
                : active
                    ? AppColors.accentVolt
                    : AppColors.border,
            width: active ? 1.5 : 1,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: isMotmSelected
                        ? const Color(0xFFFFD700).withValues(alpha: 0.3)
                        : AppColors.accentVolt.withValues(alpha: 0.25),
                    blurRadius: 10,
                    spreadRadius: 0,
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar + goal badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildAvatar(card.cardImageUrl),
                if (!isMotmMode && count > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                if (isMotmSelected)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFD700),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star,
                        size: 11,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            // Name
            Text(
              card.playerName.split(' ').last, // surname only for compactness
              style: TextStyle(
                color: active ? AppColors.textPrimary : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : _placeholderAvatar(),
          // Fixed unnecessary_underscores
          errorBuilder: (_, error, _) {
            debugPrint('AVATAR ERROR for $imageUrl: $error');
            return _placeholderAvatar();
          },
        ),
      );
    }
    return _placeholderAvatar();
  }

  Widget _placeholderAvatar() {
    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.primary.withValues(alpha: 0.25),
      child: Text(
        squadItem.card.playerName.isNotEmpty
            ? squadItem.card.playerName[0].toUpperCase()
            : '?',
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
