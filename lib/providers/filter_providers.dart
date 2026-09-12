import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/backlog_game.dart';
import '../models/game_enums.dart';
import 'game_providers.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final statusFilterProvider = StateProvider<GameStatus?>((ref) => null);

final platformFilterProvider = StateProvider<GamePlatform?>((ref) => null);

final sortOptionProvider = StateProvider<GameSort>((ref) => GameSort.dateAddedDesc);

final filteredGamesStreamProvider = StreamProvider<List<BacklogGame>>((ref) {
  final repo = ref.watch(gameRepositoryProvider);
  final query = ref.watch(searchQueryProvider);
  final status = ref.watch(statusFilterProvider);
  final platform = ref.watch(platformFilterProvider);
  final sort = ref.watch(sortOptionProvider);

  return repo.watchAllGames(
    query: query,
    status: status,
    platform: platform,
    sort: sort,
  );
});
