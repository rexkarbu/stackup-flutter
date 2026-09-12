import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/backup_helper.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/backlog_game.dart';
import '../../../models/game_enums.dart';
import '../../../providers/game_providers.dart';
import '../../../providers/stats_providers.dart';
import '../../detail/screens/game_detail_screen.dart';
import '../widgets/stat_card.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistik & Ringkasan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Analitik koleksi game dan pencapaianmu',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
      body: statsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Gagal memuat statistik: $err',
              style: const TextStyle(color: Colors.redAccent)),
        ),
        data: (stats) {
          if (stats.totalGames == 0) {
            return _buildEmptyState(context, ref);
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
            children: [
              // Summary 2-cards row
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'TOTAL GAME',
                      value: '${stats.totalGames}',
                      icon: Icons.sports_esports_rounded,
                      iconColor: AppColors.primary,
                      subtitle: 'Di seluruh library',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      title: 'WAKTU MAIN',
                      value: Formatters.formatHours(stats.totalHours),
                      icon: Icons.timer_outlined,
                      iconColor: AppColors.secondary,
                      subtitle: 'Akumulatif',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Investment & Cost-per-Hour Row
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'TOTAL INVESTASI',
                      value: Formatters.formatCurrency(stats.totalSpent),
                      icon: Icons.payments_outlined,
                      iconColor: const Color(0xFF10B981),
                      subtitle: 'Biaya pembelian game',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      title: 'RATA-RATA / JAM',
                      value: Formatters.formatCostPerHour(stats.averageCostPerHour),
                      icon: Icons.savings_outlined,
                      iconColor: Colors.amber,
                      subtitle: 'Efisiensi bermain',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Completion Rate Banner
              _buildCompletionCard(stats),
              const SizedBox(height: 24),

              // Breakdown per Status
              const Text(
                'STATUS BREAKDOWN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 12),
              _buildStatusBreakdown(stats),
              const SizedBox(height: 24),

              // Platform Breakdown
              const Text(
                'DISTRIBUSI PLATFORM',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 12),
              _buildPlatformDistribution(stats),
              const SizedBox(height: 24),

              // Top Rated Games
              if (stats.topRatedGames.isNotEmpty) ...[
                const Text(
                  'GAME DENGAN RATING TERTINGGI',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 12),
                ...stats.topRatedGames.map((game) {
                  return _buildTopRatedItem(context, game);
                }),
              ],

              // Backup & Restore Section
              const SizedBox(height: 24),
              const Text(
                'CADANGAN DATA (BACKUP & RESTORE)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 12),
              _buildBackupCard(context, ref),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCompletionCard(GameStats stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.emoji_events_rounded,
                      color: Colors.amber, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Tingkat Penyelesaian (Completion Rate)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '${stats.completionRate.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.statusCompleted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: stats.totalGames > 0
                  ? (stats.completedCount / stats.totalGames)
                  : 0,
              backgroundColor: AppColors.surface,
              color: AppColors.statusCompleted,
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${stats.completedCount} dari ${stats.totalGames} game telah kamu selesaikan',
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBreakdown(GameStats stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          _buildStatusProgressRow(
            label: GameStatus.backlog.label,
            count: stats.backlogCount,
            total: stats.totalGames,
            color: AppColors.statusBacklog,
            icon: Icons.bookmark_border_rounded,
          ),
          const SizedBox(height: 14),
          _buildStatusProgressRow(
            label: GameStatus.playing.label,
            count: stats.playingCount,
            total: stats.totalGames,
            color: AppColors.statusPlaying,
            icon: Icons.sports_esports_outlined,
          ),
          const SizedBox(height: 14),
          _buildStatusProgressRow(
            label: GameStatus.completed.label,
            count: stats.completedCount,
            total: stats.totalGames,
            color: AppColors.statusCompleted,
            icon: Icons.check_circle_outline_rounded,
          ),
          const SizedBox(height: 14),
          _buildStatusProgressRow(
            label: GameStatus.dropped.label,
            count: stats.droppedCount,
            total: stats.totalGames,
            color: AppColors.statusDropped,
            icon: Icons.cancel_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusProgressRow({
    required String label,
    required int count,
    required int total,
    required Color color,
    required IconData icon,
  }) {
    final percentage = total > 0 ? (count / total) : 0.0;

    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              '$count game',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.surface,
            color: color,
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformDistribution(GameStats stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: stats.platformDistribution.entries.map((entry) {
          final platform = entry.key;
          final count = entry.value;
          final percentage =
              stats.totalGames > 0 ? (count / stats.totalGames) : 0.0;
          final color = AppColors.getPlatformColor(platform);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(platform.icon, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        platform.label,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '$count game (${(percentage * 100).toStringAsFixed(0)}%)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: AppColors.surface,
                    color: color,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopRatedItem(BuildContext context, BacklogGame game) {
    final platformColor = AppColors.getPlatformColor(game.platform);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: platformColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(game.platform.icon, style: const TextStyle(fontSize: 18)),
        ),
        title: Text(
          game.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              game.platform.label,
              style: TextStyle(fontSize: 11, color: platformColor),
            ),
            const SizedBox(width: 6),
            const Text('•', style: TextStyle(color: AppColors.textMuted)),
            const SizedBox(width: 6),
            Text(
              Formatters.formatHours(game.hoursPlayed),
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                Formatters.formatRating(game.rating),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => GameDetailScreen(gameId: game.id),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
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
                Icons.insights_rounded,
                size: 48,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Data Statistik',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tambahkan game ke backlog untuk melihat ringkasan analitik, durasi bermain, dan completion rate.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            _buildBackupCard(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupCard(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.settings_backup_restore_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cadangan Data Lokal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Ekspor atau impor database game (.json)',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _handleExport(context, ref),
                  icon: const Icon(Icons.upload_rounded, size: 18),
                  label: const Text('Ekspor JSON'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppColors.cardBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _handleImport(context, ref),
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text('Impor JSON'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleExport(BuildContext context, WidgetRef ref) async {
    final games = ref.read(allGamesStreamProvider).valueOrNull ?? [];
    if (games.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada game untuk diekspor.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      await BackupHelper.exportBackup(games);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengekspor data: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleImport(BuildContext context, WidgetRef ref) async {
    final repository = ref.read(gameRepositoryProvider);
    try {
      final count = await BackupHelper.importBackup(repository);
      if (count != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil memulihkan $count game!'),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        final errorMsg = e is FormatException ? e.message : e.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengimpor data: $errorMsg'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
