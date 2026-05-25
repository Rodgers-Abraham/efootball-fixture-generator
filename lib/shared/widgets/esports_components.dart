import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:efootball_fixture_generator/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

/// ── High Performance Esports Player Card ──────────────────────────
class EsportsPlayerCard extends StatelessWidget {
  final String playerName;
  final String teamTag;
  final String? imageUrl;
  final int? goals;
  final bool isMotm;
  final double scale;
  final Color? glowColor;

  const EsportsPlayerCard({
    super.key,
    required this.playerName,
    required this.teamTag,
    this.imageUrl,
    this.goals,
    this.isMotm = false,
    this.scale = 1.0,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isMotm ? AppColors.trophyGold : (glowColor ?? AppColors.border),
            width: isMotm ? 2 : 1,
          ),
          boxShadow: [
            if (glowColor != null || isMotm)
              BoxShadow(
                color: (glowColor ?? AppColors.trophyGold).withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Stack(
            children: [
              // Card Image Background
              _buildImage(),

              // MOTM Holographic Overlay
              if (isMotm)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.trophyGold.withValues(alpha: 0.1),
                          Colors.transparent,
                          AppColors.trophyGold.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                ),

              // Footer Capsule
              Positioned(
                bottom: 4,
                left: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Text(
                    '$playerName ($teamTag)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Goal Badge
              if (goals != null && goals! > 0)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.accentVolt,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$goals',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        color: AppColors.surface,
        child: const Center(child: Icon(Icons.person, color: AppColors.textDisabled)),
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.contain,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColors.surface,
        highlightColor: AppColors.surfaceVariant,
        child: Container(color: AppColors.surface),
      ),
      errorWidget: (context, url, error) => Container(color: AppColors.surface),
    );
  }
}

/// ── Bento Grid Tile Wrapper ───────────────────────────────────────
class BentoTile extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final String? label;

  const BentoTile({
    super.key,
    required this.child,
    this.borderColor,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor ?? AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: Stack(
          children: [
            Positioned.fill(child: child),
            if (label != null)
              Positioned(
                top: 12,
                left: 16,
                child: Text(
                  label!.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// ── Live Match Bento Block ────────────────────────────────────────
class LiveMatchTile extends StatelessWidget {
  final String homeName;
  final String homeTag;
  final String awayName;
  final String awayTag;
  final double possession; // 0.0 to 1.0

  const LiveMatchTile({
    super.key,
    required this.homeName,
    required this.homeTag,
    required this.awayName,
    required this.awayTag,
    required this.possession,
  });

  @override
  Widget build(BuildContext context) {
    return BentoTile(
      label: 'Live Fixture',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TeamInfo(name: homeName, tag: homeTag, align: CrossAxisAlignment.start),
                const Text('VS', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 18)),
                _TeamInfo(name: awayName, tag: awayTag, align: CrossAxisAlignment.end),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: possession,
                minHeight: 8,
                backgroundColor: AppColors.secondary.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${(possession * 100).toInt()}%', style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w800)),
                Text('${((1 - possession) * 100).toInt()}%', style: const TextStyle(color: AppColors.secondary, fontSize: 11, fontWeight: FontWeight.w800)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamInfo extends StatelessWidget {
  final String name;
  final String tag;
  final CrossAxisAlignment align;

  const _TeamInfo({required this.name, required this.tag, required this.align});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(tag, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1)),
        Text(name, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
