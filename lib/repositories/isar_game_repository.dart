import 'package:isar/isar.dart';
import '../core/utils/file_helper.dart';
import '../models/backlog_game.dart';
import '../models/game_enums.dart';
import 'game_repository.dart';

class IsarGameRepository implements GameRepository {
  final Isar _isar;

  IsarGameRepository(this._isar);

  @override
  Stream<List<BacklogGame>> watchAllGames({
    String? query,
    GameStatus? status,
    GamePlatform? platform,
    GameSort? sort,
  }) {
    return _isar.backlogGames.where().watch(fireImmediately: true).map((games) {
      var filtered = games;

      // Filter Status
      if (status != null) {
        filtered = filtered.where((g) => g.status == status).toList();
      }

      // Filter Platform
      if (platform != null) {
        filtered = filtered.where((g) => g.platform == platform).toList();
      }

      // Filter Judul / Search Query
      if (query != null && query.trim().isNotEmpty) {
        final q = query.trim().toLowerCase();
        filtered = filtered.where((g) => g.title.toLowerCase().contains(q)).toList();
      }

      // Sorting
      final sortOption = sort ?? GameSort.dateAddedDesc;
      switch (sortOption) {
        case GameSort.titleAsc:
          filtered.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
          break;
        case GameSort.dateAddedDesc:
          filtered.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
          break;
        case GameSort.ratingDesc:
          filtered.sort((a, b) {
            final rA = a.rating ?? 0.0;
            final rB = b.rating ?? 0.0;
            return rB.compareTo(rA);
          });
          break;
        case GameSort.hoursPlayedDesc:
          filtered.sort((a, b) => b.hoursPlayed.compareTo(a.hoursPlayed));
          break;
      }

      return filtered;
    });
  }

  @override
  Stream<List<BacklogGame>> watchUpNextGames() {
    return _isar.backlogGames
        .filter()
        .statusEqualTo(GameStatus.backlog)
        .sortByPriority()
        .watch(fireImmediately: true);
  }

  @override
  Future<BacklogGame?> getGameById(int id) async {
    return _isar.backlogGames.get(id);
  }

  @override
  Stream<BacklogGame?> watchGameById(int id) {
    return _isar.backlogGames.watchObject(id, fireImmediately: true);
  }

  @override
  Future<void> saveGame(BacklogGame game) async {
    await _isar.writeTxn(() async {
      await _isar.backlogGames.put(game);
    });
  }

  @override
  Future<void> deleteGame(int id) async {
    final game = await _isar.backlogGames.get(id);
    if (game != null) {
      if (game.coverPath != null && game.coverPath!.isNotEmpty) {
        await FileHelper.deleteCoverImage(game.coverPath);
      }
      await _isar.writeTxn(() async {
        await _isar.backlogGames.delete(id);
      });
    }
  }

  @override
  Future<void> updatePriorityOrder(List<BacklogGame> reorderedList) async {
    await _isar.writeTxn(() async {
      for (int i = 0; i < reorderedList.length; i++) {
        reorderedList[i].priority = i;
      }
      await _isar.backlogGames.putAll(reorderedList);
    });
  }

  @override
  Future<void> updateHours(int id, double hours) async {
    final game = await _isar.backlogGames.get(id);
    if (game == null) return;

    game.hoursPlayed = hours;
    await _isar.writeTxn(() async {
      await _isar.backlogGames.put(game);
    });
  }

  @override
  Future<void> updateStatus(int id, GameStatus status, {double? rating}) async {
    final game = await _isar.backlogGames.get(id);
    if (game == null) return;

    game.status = status;

    if (status == GameStatus.playing) {
      game.dateStarted ??= DateTime.now();
    } else if (status == GameStatus.completed) {
      game.dateCompleted ??= DateTime.now();
      if (rating != null) {
        game.rating = rating;
      }
    } else if (status == GameStatus.backlog) {
      // Jika dikembalikan ke backlog
      game.dateCompleted = null;
    }

    await _isar.writeTxn(() async {
      await _isar.backlogGames.put(game);
    });
  }

  @override
  Future<int> getMaxPriority() async {
    final topGame = await _isar.backlogGames
        .filter()
        .statusEqualTo(GameStatus.backlog)
        .sortByPriorityDesc()
        .findFirst();

    return topGame?.priority ?? -1;
  }
}
