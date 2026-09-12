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

  group('Backup & Serialization Tests', () {
    test('toJson serializes all fields correctly', () {
      final dateAdded = DateTime(2025, 1, 1, 10, 0);
      final dateStarted = DateTime(2025, 1, 2, 14, 30);
      final dateCompleted = DateTime(2025, 1, 10, 20, 0);

      final game = BacklogGame()
        ..title = 'The Witcher 3'
        ..platform = GamePlatform.pc
        ..genres = ['RPG', 'Open World']
        ..status = GameStatus.completed
        ..priority = 1
        ..rating = 4.8
        ..hoursPlayed = 85.5
        ..purchasePrice = 250000
        ..notes = 'Masterpiece RPG'
        ..dateAdded = dateAdded
        ..dateStarted = dateStarted
        ..dateCompleted = dateCompleted;

      final json = game.toJson();

      expect(json['title'], 'The Witcher 3');
      expect(json['platform'], 'pc');
      expect(json['genres'], ['RPG', 'Open World']);
      expect(json['status'], 'completed');
      expect(json['priority'], 1);
      expect(json['rating'], 4.8);
      expect(json['hoursPlayed'], 85.5);
      expect(json['purchasePrice'], 250000.0);
      expect(json['notes'], 'Masterpiece RPG');
      expect(json['dateAdded'], dateAdded.toIso8601String());
      expect(json['dateStarted'], dateStarted.toIso8601String());
      expect(json['dateCompleted'], dateCompleted.toIso8601String());
    });

    test('fromJson deserializes JSON map accurately', () {
      final jsonMap = {
        'title': 'Hades',
        'platform': 'switch_',
        'genres': ['Roguelike', 'Action'],
        'status': 'playing',
        'priority': 0,
        'rating': 4.5,
        'hoursPlayed': 42.0,
        'purchasePrice': 150000.0,
        'notes': 'Great soundtrack',
        'dateAdded': '2025-02-01T12:00:00.000',
        'dateStarted': '2025-02-02T15:00:00.000',
        'dateCompleted': null,
      };

      final game = BacklogGame.fromJson(jsonMap);

      expect(game.title, 'Hades');
      expect(game.platform, GamePlatform.switch_);
      expect(game.genres, ['Roguelike', 'Action']);
      expect(game.status, GameStatus.playing);
      expect(game.priority, 0);
      expect(game.rating, 4.5);
      expect(game.hoursPlayed, 42.0);
      expect(game.purchasePrice, 150000.0);
      expect(game.notes, 'Great soundtrack');
      expect(game.dateAdded, DateTime.parse('2025-02-01T12:00:00.000'));
      expect(game.dateStarted, DateTime.parse('2025-02-02T15:00:00.000'));
      expect(game.dateCompleted, isNull);
    });

    test('fromJson handles fallback defaults when values are missing', () {
      final jsonMap = <String, dynamic>{};

      final game = BacklogGame.fromJson(jsonMap);

      expect(game.title, 'Untitled');
      expect(game.platform, GamePlatform.other);
      expect(game.genres, isEmpty);
      expect(game.status, GameStatus.backlog);
      expect(game.priority, 0);
      expect(game.hoursPlayed, 0.0);
      expect(game.purchasePrice, isNull);
      expect(game.rating, isNull);
      expect(game.dateStarted, isNull);
      expect(game.dateCompleted, isNull);
      expect(game.dateAdded, isA<DateTime>());
    });
  });
}
