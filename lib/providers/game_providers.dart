import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../core/database/isar_service.dart';
import '../models/backlog_game.dart';
import '../repositories/game_repository.dart';
import '../repositories/isar_game_repository.dart';

final isarProvider = Provider<Isar>((ref) {
  return IsarService.instance;
});

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return IsarGameRepository(isar);
});

final allGamesStreamProvider = StreamProvider<List<BacklogGame>>((ref) {
  final repo = ref.watch(gameRepositoryProvider);
  return repo.watchAllGames();
});

final upNextStreamProvider = StreamProvider<List<BacklogGame>>((ref) {
  final repo = ref.watch(gameRepositoryProvider);
  return repo.watchUpNextGames();
});

final gameDetailStreamProvider = StreamProvider.family<BacklogGame?, int>((ref, id) {
  final repo = ref.watch(gameRepositoryProvider);
  return repo.watchGameById(id);
});
