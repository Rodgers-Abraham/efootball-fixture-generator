import 'package:flutter/material.dart';

/// Sports-themed "Stadium & Pitch" color palette
abstract final class AppColors {
  // Backgrounds - Deep Stadium Navy
  static const Color background = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceVariant = Color(0xFF334155);

  // Core Theme - Pitch Green & Gold
  static const Color primary = Color(0xFF22C55E); // Pitch Green
  static const Color secondary = Color(0xFF16A34A); // Deep Grass
  static const Color accentNeon = Color(0xFF4ADE80); // Neon Highlight
  static const Color trophyGold = Color(0xFFFFD700); // Championship Gold

  // Text
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFF475569);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Borders & dividers
  static const Color border = Color(0xFF334155);
  static const Color borderNeon = Color(0xFF22C55E);

  // Card type badge colours
  static const Color cardTypeShowTime  = Color(0xFFFFD700); // gold
  static const Color cardTypePOTW      = Color(0xFF00E5FF); // cyan
  static const Color cardTypeBigTime   = Color(0xFF2ECC71); // green
  static const Color cardTypeHighlight = Color(0xFFFF6B35); // orange
  static const Color cardTypeEpic      = Color(0xFF9B59B6); // purple
  static const Color cardTypeStandard  = Color(0xFF95A5A6); // grey

  // Gradient stops
  static const List<Color> crimsonGradient = [primary, secondary];
  static const List<Color> darkGradient = [background, surface];

  static Color cardTypeColor(String cardType) {
    switch (cardType) {
      case 'Show Time':  return cardTypeShowTime;
      case 'POTW':       return cardTypePOTW;
      case 'Big Time':   return cardTypeBigTime;
      case 'Highlight':  return cardTypeHighlight;
      case 'Epic':       return cardTypeEpic;
      default:           return cardTypeStandard;
    }
  }

  /// Short label shown on card badges
  static String cardTypeLabel(String cardType) {
    switch (cardType) {
      case 'Show Time':  return 'ST';
      case 'POTW':       return 'POTW';
      case 'Big Time':   return 'BT';
      case 'Highlight':  return 'HL';
      case 'Epic':       return 'EP';
      default:           return 'STD';
    }
  }
}
