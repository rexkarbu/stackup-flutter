import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/backlog_game.dart';
import '../models/game_enums.dart';
import 'game_providers.dart';

class GameStats {
  final int totalGames;
  final double totalHours;
  final double completionRate;
  final int backlogCount;
  final int playingCount;
  final int completedCount;
  final int droppedCount;
  final Map<GamePlatform, int> platformDistribution;
  final List<BacklogGame> topRatedGames;
  final double totalSpent;
  final double? averageCostPerHour;

  const GameStats({
    required this.totalGames,
    required this.totalHours,
    required this.completionRate,
    required this.backlogCount,
    required this.playingCount,
    required this.completedCount,
    required this.droppedCount,
    required this.platformDistribution,
    required this.topRatedGames,
    required this.totalSpent,
    required this.averageCostPerHour,
  });

  factory GameStats.empty() {
    return const GameStats(
      totalGames: 0,
      totalHours: 0.0,
      completionRate: 0.0,
      backlogCount: 0,
      playingCount: 0,
      completedCount: 0,
      droppedCount: 0,
      platformDistribution: {},
      topRatedGames: [],
      totalSpent: 0.0,
      averageCostPerHour: null,
    );
  }
}

final statsSummaryProvider = Provider<AsyncValue<GameStats>>((ref) {
  final gamesAsync = ref.watch(allGamesStreamProvider);

  return gamesAsync.whenData((games) {
    if (games.isEmpty) {
      return GameStats.empty();
    }

    final totalGames = games.length;
    double totalHours = 0.0;
    double totalSpent = 0.0;
    int backlogCount = 0;
    int playingCount = 0;
    int completedCount = 0;
    int droppedCount = 0;
    final Map<GamePlatform, int> platformMap = {};
    final List<BacklogGame> ratedList = [];

    for (final game in games) {
      totalHours += game.hoursPlayed;
      if (game.purchasePrice != null && game.purchasePrice! > 0) {
        totalSpent += game.purchasePrice!;
      }

      switch (game.status) {
        case GameStatus.backlog:
          backlogCount++;
          break;
        case GameStatus.playing:
          playingCount++;
          break;
        case GameStatus.completed:
          completedCount++;
          if (game.rating != null && game.rating! > 0) {
            ratedList.add(game);
          }
          break;
        case GameStatus.dropped:
          droppedCount++;
          break;
      }

      platformMap[game.platform] = (platformMap[game.platform] ?? 0) + 1;
    }

    final completionRate = totalGames > 0 ? (completedCount / totalGames) * 100 : 0.0;
    final averageCostPerHour =
        (totalHours > 0 && totalSpent > 0) ? (totalSpent / totalHours) : null;

    // Urutkan top rated games descending
    ratedList.sort((a, b) => (b.rating ?? 0.0).compareTo(a.rating ?? 0.0));

    // Urutkan distribusi platform berdasarkan count terbanyak
    final sortedPlatformEntries = platformMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final sortedPlatformMap = Map.fromEntries(sortedPlatformEntries);

    return GameStats(
      totalGames: totalGames,
      totalHours: totalHours,
      completionRate: completionRate,
      backlogCount: backlogCount,
      playingCount: playingCount,
      completedCount: completedCount,
      droppedCount: droppedCount,
      platformDistribution: sortedPlatformMap,
      topRatedGames: ratedList.take(5).toList(),
      totalSpent: totalSpent,
      averageCostPerHour: averageCostPerHour,
    );
  });
});
