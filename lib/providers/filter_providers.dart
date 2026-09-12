import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/backlog_game.dart';
import '../models/game_enums.dart';
import 'game_providers.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final statusFilterProvider = StateProvider<GameStatus?>((ref) => null);

final platformFilterProvider = StateProvider<GamePlatform?>((ref) => null);

final genreFilterProvider = StateProvider<String?>((ref) => null);

final availableGenresProvider = Provider<List<String>>((ref) {
  final games = ref.watch(allGamesStreamProvider).value ?? [];
  final genres = <String>{};
  for (final g in games) {
    genres.addAll(g.genres);
  }
  return genres.toList()..sort();
});

final sortOptionProvider = StateProvider<GameSort>((ref) => GameSort.dateAddedDesc);

final filteredGamesStreamProvider = StreamProvider<List<BacklogGame>>((ref) {
  final repo = ref.watch(gameRepositoryProvider);
  final query = ref.watch(searchQueryProvider);
  final status = ref.watch(statusFilterProvider);
  final platform = ref.watch(platformFilterProvider);
  final genre = ref.watch(genreFilterProvider);
  final sort = ref.watch(sortOptionProvider);

  return repo.watchAllGames(
    query: query,
    status: status,
    platform: platform,
    genre: genre,
    sort: sort,
  );
});
