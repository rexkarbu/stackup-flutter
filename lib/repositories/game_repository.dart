import '../models/backlog_game.dart';
import '../models/game_enums.dart';

abstract class GameRepository {
  Stream<List<BacklogGame>> watchAllGames({
    String? query,
    GameStatus? status,
    GamePlatform? platform,
    GameSort? sort,
  });

  Stream<List<BacklogGame>> watchUpNextGames();

  Future<BacklogGame?> getGameById(int id);

  Stream<BacklogGame?> watchGameById(int id);

  Future<void> saveGame(BacklogGame game);

  Future<void> deleteGame(int id);

  Future<void> updatePriorityOrder(List<BacklogGame> reorderedList);

  Future<void> updateHours(int id, double hours);

  Future<void> updateStatus(int id, GameStatus status, {double? rating});

  Future<int> getMaxPriority();
}
