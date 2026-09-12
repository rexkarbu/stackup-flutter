import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/backlog_game.dart';
import '../../detail/screens/game_detail_screen.dart';

class UpNextItem extends StatelessWidget {
  final BacklogGame game;
  final int index;
  final VoidCallback onPlayNow;

  const UpNextItem({
    super.key,
    required this.game,
    required this.index,
    required this.onPlayNow,
  });

  @override
  Widget build(BuildContext context) {
    final platformColor = AppColors.getPlatformColor(game.platform);
    final hasCover = game.coverPath != null &&
        game.coverPath!.isNotEmpty &&
        File(game.coverPath!).existsSync();

    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => GameDetailScreen(gameId: game.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              // Priority Rank Badge
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: index == 0
                      ? AppColors.primary
                      : (index == 1
                          ? AppColors.secondary.withValues(alpha: 0.8)
                          : AppColors.surface),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: index < 2 ? Colors.transparent : AppColors.cardBorder,
                  ),
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: index < 2 ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 50,
                  height: 64,
                  child: hasCover
                      ? Image.file(
                          File(game.coverPath!),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
              ),
              const SizedBox(width: 12),

              // Title & Platform Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: platformColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(game.platform.icon,
                                  style: const TextStyle(fontSize: 10)),
                              const SizedBox(width: 4),
                              Text(
                                game.platform.label,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: platformColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (game.hoursPlayed > 0) ...[
                          const SizedBox(width: 6),
                          Text(
                            Formatters.formatHours(game.hoursPlayed),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Quick Action: "Mainkan Sekarang"
              IconButton(
                icon: const Icon(Icons.play_circle_fill_rounded),
                color: AppColors.secondary,
                iconSize: 32,
                tooltip: 'Mainkan Sekarang',
                onPressed: onPlayNow,
              ),

              // Drag Handle
              ReorderableDragStartListener(
                index: index,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.drag_handle_rounded,
                    color: AppColors.textMuted,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surface,
      child: Center(
        child: Text(
          game.platform.icon,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
