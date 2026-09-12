import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/game_enums.dart';
import '../../../providers/filter_providers.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/game_card.dart';
import '../widgets/search_bar_widget.dart';

class BacklogScreen extends ConsumerWidget {
  const BacklogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatus = ref.watch(statusFilterProvider);
    final selectedPlatform = ref.watch(platformFilterProvider);
    final gamesAsync = ref.watch(filteredGamesStreamProvider);

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Header Sliver
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App Bar Brand Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.layers_rounded,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'StackUp',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  Text(
                                    'Game Backlog & Tracker',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Search Bar & Filter Button
                      Row(
                        children: [
                          const Expanded(child: SearchBarWidget()),
                          const SizedBox(width: 10),
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: selectedPlatform != null
                                  ? AppColors.primary.withValues(alpha: 0.2)
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedPlatform != null
                                    ? AppColors.primary
                                    : AppColors.cardBorder,
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.tune_rounded,
                                color: selectedPlatform != null
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                size: 22,
                              ),
                              tooltip: 'Filter Platform & Urutan',
                              onPressed: () => FilterSheet.show(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Status Horizontal Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Chip "Semua"
                            _buildStatusChip(
                              label: 'Semua',
                              isSelected: selectedStatus == null,
                              color: AppColors.primary,
                              onTap: () {
                                ref.read(statusFilterProvider.notifier).state = null;
                              },
                            ),
                            const SizedBox(width: 8),
                            ...GameStatus.values.map((s) {
                              final isSelected = selectedStatus == s;
                              final color = AppColors.getStatusColor(s);
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _buildStatusChip(
                                  label: s.label,
                                  isSelected: isSelected,
                                  color: color,
                                  onTap: () {
                                    ref.read(statusFilterProvider.notifier).state =
                                        isSelected ? null : s;
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: gamesAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Terjadi kesalahan memuat data: $err',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            ),
            data: (games) {
              if (games.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                itemCount: games.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return GameCard(game: games[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.18) : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? color : AppColors.cardBorder,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? color : AppColors.textSecondary,
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
                Icons.sports_esports_outlined,
                size: 48,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak ada game ditemukan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Coba ubah kata kunci pencarian atau filter, atau tambahkan game baru dengan tombol (+)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
