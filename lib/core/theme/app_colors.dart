import 'package:flutter/material.dart';
import '../../models/game_enums.dart';

class AppColors {
  // Background & Surface
  static const Color background = Color(0xFF12131C);
  static const Color surface = Color(0xFF1E1F2E);
  static const Color card = Color(0xFF27293D);
  static const Color cardBorder = Color(0xFF33354E);

  // Accents
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryHover = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF06B6D4); // Cyan
  static const Color accent = Color(0xFF8B5CF6); // Purple

  // Status Colors
  static const Color statusBacklog = Color(0xFFF59E0B); // Amber
  static const Color statusPlaying = Color(0xFF06B6D4); // Cyan
  static const Color statusCompleted = Color(0xFF10B981); // Emerald
  static const Color statusDropped = Color(0xFF64748B); // Slate

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Helper for Status Color
  static Color getStatusColor(GameStatus status) {
    switch (status) {
      case GameStatus.backlog:
        return statusBacklog;
      case GameStatus.playing:
        return statusPlaying;
      case GameStatus.completed:
        return statusCompleted;
      case GameStatus.dropped:
        return statusDropped;
    }
  }

  // Helper for Platform Color
  static Color getPlatformColor(GamePlatform platform) {
    switch (platform) {
      case GamePlatform.pc:
        return const Color(0xFF38BDF8);
      case GamePlatform.ps5:
        return const Color(0xFF3B82F6);
      case GamePlatform.ps4:
        return const Color(0xFF2563EB);
      case GamePlatform.switch_:
        return const Color(0xFFEF4444);
      case GamePlatform.xbox:
        return const Color(0xFF22C55E);
      case GamePlatform.mobile:
        return const Color(0xFFA855F7);
      case GamePlatform.other:
        return const Color(0xFFE2E8F0);
    }
  }
}
