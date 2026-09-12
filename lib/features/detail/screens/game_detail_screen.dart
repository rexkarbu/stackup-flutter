import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/backlog_game.dart';
import '../../../models/game_enums.dart';
import '../../../providers/game_providers.dart';
import '../../form/screens/game_form_screen.dart';
import '../widgets/hours_dialog.dart';
import '../widgets/rating_dialog.dart';

class GameDetailScreen extends ConsumerWidget {
  final int gameId;

  const GameDetailScreen({super.key, required this.gameId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameAsync = ref.watch(gameDetailStreamProvider(gameId));

    return gameAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('Gagal memuat detail game: $err',
              style: const TextStyle(color: Colors.redAccent)),
        ),
      ),
      data: (game) {
        if (game == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text(
                'Game tidak ditemukan (mungkin telah dihapus)',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          );
        }

        return _buildContent(context, ref, game);
      },
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, BacklogGame game) {
    final platformColor = AppColors.getPlatformColor(game.platform);
    final statusColor = AppColors.getStatusColor(game.status);
    final hasCover = game.coverPath != null &&
        game.coverPath!.isNotEmpty &&
        File(game.coverPath!).existsSync();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible Hero Cover Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.background,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Game',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GameFormScreen(game: game),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Colors.redAccent),
                tooltip: 'Hapus Game',
                onPressed: () => _confirmDelete(context, ref, game),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image or fallback
                  hasCover
                      ? Image.file(
                          File(game.coverPath!),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: AppColors.card,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(game.platform.icon,
                                    style: const TextStyle(fontSize: 54)),
                                const SizedBox(height: 8),
                                const Icon(Icons.sports_esports_rounded,
                                    size: 32, color: AppColors.textMuted),
                              ],
                            ),
                          ),
                        ),

                  // Gradient Dark Overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.5),
                          Colors.transparent,
                          AppColors.background.withValues(alpha: 0.85),
                          AppColors.background,
                        ],
                        stops: const [0.0, 0.35, 0.75, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    game.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.6,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Platform & Genre Badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Platform Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: platformColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: platformColor.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(game.platform.icon,
                                style: const TextStyle(fontSize: 13)),
                            const SizedBox(width: 5),
                            Text(
                              game.platform.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: platformColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          game.status.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),

                      // Genre Badges
                      ...game.genres.map((g) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Text(
                            g,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Quick Status Changer
                  const Text(
                    'STATUS PERMAINAN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildStatusSelector(context, ref, game),
                  const SizedBox(height: 24),

                  // Hours Played Card
                  _buildHoursPlayedCard(context, ref, game),
                  const SizedBox(height: 20),

                  // Rating Section (if Completed)
                  if (game.status == GameStatus.completed) ...[
                    _buildRatingCard(context, ref, game),
                    const SizedBox(height: 20),
                  ],

                  // Timeline Dates Card
                  _buildTimelineCard(game),
                  const SizedBox(height: 20),

                  // Personal Notes Section
                  _buildNotesCard(game),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSelector(
      BuildContext context, WidgetRef ref, BacklogGame game) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: GameStatus.values.map((status) {
          final isSelected = game.status == status;
          final color = AppColors.getStatusColor(status);

          return Expanded(
            child: GestureDetector(
              onTap: () => _handleStatusChange(context, ref, game, status),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? color : Colors.transparent,
                    width: 1.2,
                  ),
                ),
                child: Text(
                  status.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? color : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _handleStatusChange(
    BuildContext context,
    WidgetRef ref,
    BacklogGame game,
    GameStatus newStatus,
  ) {
    if (game.status == newStatus) return;

    if (newStatus == GameStatus.completed) {
      // Buka dialog rating sebelum mengubah status ke completed
      RatingDialog.show(
        context,
        initialRating: game.rating ?? 4.0,
        onRatingSelected: (rating) {
          ref.read(gameRepositoryProvider).updateStatus(
                game.id,
                GameStatus.completed,
                rating: rating,
              );
        },
      );
    } else {
      ref.read(gameRepositoryProvider).updateStatus(game.id, newStatus);
    }
  }

  Widget _buildHoursPlayedCard(
      BuildContext context, WidgetRef ref, BacklogGame game) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.timer_outlined,
                    color: AppColors.secondary, size: 24),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Waktu Bermain',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    Formatters.formatHours(game.hoursPlayed),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Tambah Jam', style: TextStyle(fontSize: 12.5)),
            onPressed: () {
              HoursDialog.show(
                context,
                currentHours: game.hoursPlayed,
                onSave: (newHours) {
                  ref.read(gameRepositoryProvider).updateHours(game.id, newHours);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard(
      BuildContext context, WidgetRef ref, BacklogGame game) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.star_rounded,
                    color: Colors.amber, size: 24),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rating Pribadi',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: game.rating ?? 0.0,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 18.0,
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        Formatters.formatRating(game.rating),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.textSecondary),
            tooltip: 'Ubah Rating',
            onPressed: () {
              RatingDialog.show(
                context,
                initialRating: game.rating ?? 4.0,
                onRatingSelected: (newRating) {
                  ref.read(gameRepositoryProvider).updateStatus(
                        game.id,
                        GameStatus.completed,
                        rating: newRating,
                      );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(BacklogGame game) {
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
          const Text(
            'RIWAYAT STATUS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          _buildTimelineRow(
            icon: Icons.bookmark_add_outlined,
            title: 'Ditambahkan ke Backlog',
            date: Formatters.formatDate(game.dateAdded),
          ),
          if (game.dateStarted != null) ...[
            const SizedBox(height: 8),
            _buildTimelineRow(
              icon: Icons.play_arrow_outlined,
              title: 'Mulai Dimainkan',
              date: Formatters.formatDate(game.dateStarted),
            ),
          ],
          if (game.dateCompleted != null) ...[
            const SizedBox(height: 8),
            _buildTimelineRow(
              icon: Icons.emoji_events_outlined,
              title: 'Selesai Ditamatkan',
              date: Formatters.formatDate(game.dateCompleted),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineRow({
    required IconData icon,
    required String title,
    required String date,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
        Text(
          date,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesCard(BacklogGame game) {
    final hasNotes = game.notes != null && game.notes!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.notes_rounded, size: 16, color: AppColors.textMuted),
              SizedBox(width: 6),
              Text(
                'CATATAN PRIBADI',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            hasNotes ? game.notes! : 'Belum ada catatan untuk game ini.',
            style: TextStyle(
              fontSize: 13.5,
              color: hasNotes ? AppColors.textPrimary : AppColors.textMuted,
              height: 1.5,
              fontStyle: hasNotes ? FontStyle.normal : FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, BacklogGame game) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Game?'),
        content: Text(
          'Apakah kamu yakin ingin menghapus "${game.title}" dari library? Tindakan ini permanen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(gameRepositoryProvider).deleteGame(game.id);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
