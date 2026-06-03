import 'package:flutter/material.dart';
import 'package:eFootClash/core/theme/app_colors.dart';
import 'package:eFootClash/features/squad/domain/entities/player_card_entity.dart';

/// Vertical card chip for squad grid slots.
/// Image on top, name + type badge below.
class PlayerCardChip extends StatelessWidget {
  final PlayerCardEntity card;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const PlayerCardChip({
    super.key,
    required this.card,
    this.isSelected = false,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = AppColors.cardTypeColor(card.cardType);
    final typeLabel = AppColors.cardTypeLabel(card.cardType);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.accentVolt : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accentVolt.withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Main content — vertical layout
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Card image - Reduced height to 64 to prevent overflows
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(9),
                  ),
                  child: _buildImage(),
                ),
                // Name + badge row - reduced padding
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        card.playerName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: badgeColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(
                                color: badgeColor.withValues(alpha: 0.6),
                              ),
                            ),
                            child: Text(
                              typeLabel,
                              style: TextStyle(
                                color: badgeColor,
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${card.maxRating}',
                            style: const TextStyle(
                              color: AppColors.accentVolt,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Remove button
            if (onRemove != null)
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final url = card.cardImageUrl;
    if (url != null && url.isNotEmpty) {
      return Container(
        color: Colors.black26, // Background for the card space
        child: Image.network(
          url,
          width: double.infinity,
          height: 64,
          fit: BoxFit.contain, // Changed from cover to show the full card
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : _imagePlaceholder(),
          // Fixed unnecessary_underscores
          errorBuilder: (_, _, _) => _imagePlaceholder(),
        ),
      );
    }
    return _imagePlaceholder();
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 64, // Reduced from 72
      color: AppColors.primary.withValues(alpha: 0.1),
      child: const Icon(Icons.person, color: AppColors.textDisabled, size: 32),
    );
  }
}
