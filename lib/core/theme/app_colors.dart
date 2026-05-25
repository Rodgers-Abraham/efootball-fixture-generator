import 'package:flutter/material.dart';

/// Cyber Stadium / Esports color palette
/// Spec: Absolute black canvas, deep dark containers, neon highlights.
abstract final class AppColors {
  // Backgrounds - Absolute Black & Deep Dark
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF121212);
  static const Color surfaceVariant = Color(0xFF1A1A1A);

  // Core Neon Accents
  static const Color primary = Color(0xFF00E5FF); // Neon Cyan
  static const Color secondary = Color(0xFF8B5CF6); // Electric Violet
  static const Color accentVolt = Color(0xFF00FF66); // Neon Volt Green
  static const Color accentNeon = Color(0xFF00FF66); // Alias for backward compatibility
  static const Color accentPurple = Color(0xFF963CFF); // Neon Purple
  static const Color trophyGold = Color(0xFFFFD700); // Championship Gold

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color textDisabled = Color(0xFF444444);

  // Status
  static const Color success = Color(0xFF00FF66);
  static const Color warning = Color(0xFFFFB300);
  static const Color error = Color(0xFFFF3D00);
  static const Color info = Color(0xFF00E5FF);

  // Borders & Glows
  static const Color border = Color(0xFF222222);
  static const Color borderNeon = Color(0xFF00E5FF);

  // Card type badge colours
  static const Color cardTypeShowTime  = Color(0xFFFFD700);
  static const Color cardTypePOTW      = Color(0xFF00E5FF);
  static const Color cardTypeBigTime   = Color(0xFF00FF66);
  static const Color cardTypeHighlight = Color(0xFFFF6B35);
  static const Color cardTypeEpic      = Color(0xFF963CFF);
  static const Color cardTypeStandard  = Color(0xFF777777);

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
