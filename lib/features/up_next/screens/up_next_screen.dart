import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/backlog_game.dart';
import '../../../models/game_enums.dart';
import '../../../providers/game_providers.dart';
import '../widgets/up_next_item.dart';

class UpNextScreen extends ConsumerWidget {
  const UpNextScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upNextAsync = ref.watch(upNextStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Up Next Queue',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Geser untuk mengatur prioritas antrean bermain',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
      body: upNextAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Gagal memuat antrean: $err',
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ),
        data: (games) {
          if (games.isEmpty) {
            return _buildEmptyState(context);
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
            itemCount: games.length,
            onReorderItem: (oldIndex, newIndex) async {
              final mutableList = List<BacklogGame>.from(games);
              final item = mutableList.removeAt(oldIndex);
              mutableList.insert(newIndex, item);

              await ref
                  .read(gameRepositoryProvider)
                  .updatePriorityOrder(mutableList);
            },
            itemBuilder: (context, index) {
              final game = games[index];
              return Container(
                key: ValueKey('up_next_${game.id}'),
                margin: const EdgeInsets.only(bottom: 12),
                child: UpNextItem(
                  game: game,
                  index: index,
                  onPlayNow: () async {
                    await ref
                        .read(gameRepositoryProvider)
                        .updateStatus(game.id, GameStatus.playing);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.surface,
                          content: Row(
                            children: [
                              const Icon(Icons.sports_esports_rounded,
                                  color: AppColors.secondary, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${game.title} kini Sedang Dimainkan!',
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: AppColors.cardBorder),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Icon(
                Icons.playlist_add_check_rounded,
                size: 48,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Antrean Up Next Kosong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Semua game backlog yang kamu tambahkan akan muncul di sini secara otomatis. Kamu bisa mengatur urutan prioritas main dengan drag & drop.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
