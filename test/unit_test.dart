import 'package:flutter_test/flutter_test.dart';
import 'package:stackup/core/utils/formatters.dart';
import 'package:stackup/models/backlog_game.dart';
import 'package:stackup/models/game_enums.dart';

void main() {
  group('Game Enums Tests', () {
    test('GameStatus has correct labels', () {
      expect(GameStatus.backlog.label, 'Backlog');
      expect(GameStatus.playing.label, 'Sedang Dimainkan');
      expect(GameStatus.completed.label, 'Selesai');
      expect(GameStatus.dropped.label, 'Di-drop');
    });

    test('GamePlatform has icons and labels', () {
      expect(GamePlatform.pc.label, 'PC');
      expect(GamePlatform.pc.icon, '💻');
      expect(GamePlatform.ps5.label, 'PlayStation 5');
      expect(GamePlatform.switch_.label, 'Nintendo Switch');
    });
  });

  group('Formatters Tests', () {
    test('formatHours formats correctly', () {
      expect(Formatters.formatHours(0), '0 jam');
      expect(Formatters.formatHours(15.0), '15 jam');
      expect(Formatters.formatHours(12.5), '12.5 jam');
      expect(Formatters.formatHours(null), '0 jam');
    });

    test('formatRating formats correctly', () {
      expect(Formatters.formatRating(null), '-');
      expect(Formatters.formatRating(0), '-');
      expect(Formatters.formatRating(4.0), '4');
      expect(Formatters.formatRating(4.5), '4.5');
    });

    test('formatDate handles null gracefully', () {
      expect(Formatters.formatDate(null), '-');
    });

    test('formatCurrency formats Rupiah correctly', () {
      expect(Formatters.formatCurrency(null), 'Gratis / N/A');
      expect(Formatters.formatCurrency(0), 'Gratis / N/A');
      expect(Formatters.formatCurrency(300000), 'Rp 300.000');
    });

    test('formatCostPerHour formats correctly', () {
      expect(Formatters.formatCostPerHour(null), '-');
      expect(Formatters.formatCostPerHour(10000), 'Rp 10.000 / jam');
    });
  });

  group('BacklogGame Entity Tests', () {
    test('BacklogGame initializes with defaults', () {
      final game = BacklogGame()
        ..title = 'Elden Ring'
        ..platform = GamePlatform.pc
        ..status = GameStatus.backlog
        ..dateAdded = DateTime(2025, 1, 1);

      expect(game.title, 'Elden Ring');
      expect(game.platform, GamePlatform.pc);
      expect(game.status, GameStatus.backlog);
      expect(game.priority, 0);
      expect(game.hoursPlayed, 0.0);
      expect(game.purchasePrice, isNull);
      expect(game.costPerHour, isNull);
      expect(game.rating, isNull);
      expect(game.genres, isEmpty);
    });

    test('costPerHour getter calculates correctly', () {
      final game = BacklogGame()
        ..title = 'Cyberpunk 2077'
        ..platform = GamePlatform.pc
        ..status = GameStatus.playing
        ..purchasePrice = 300000
        ..hoursPlayed = 30
        ..dateAdded = DateTime(2025, 1, 1);

      expect(game.costPerHour, 10000.0);
    });
  });
}
