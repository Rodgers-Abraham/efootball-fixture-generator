import 'package:flutter/material.dart';

/// Midnight Crimson color palette
abstract final class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF12121A);
  static const Color surfaceVariant = Color(0xFF1A1A26);

  // Crimson spectrum
  static const Color primary = Color(0xFFC0392B);
  static const Color secondary = Color(0xFFE74C3C);
  static const Color accentNeon = Color(0xFFFF6B6B);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8B8B9E);
  static const Color textDisabled = Color(0xFF3D3D4F);

  // Status
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);

  // Borders & dividers
  static const Color border = Color(0xFF1E1E2E);
  static const Color borderNeon = Color(0xFFFF6B6B);

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
