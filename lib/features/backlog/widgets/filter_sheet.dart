import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/game_enums.dart';
import '../../../providers/filter_providers.dart';

class FilterSheet extends ConsumerWidget {
  const FilterSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const FilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPlatform = ref.watch(platformFilterProvider);
    final selectedSort = ref.watch(sortOptionProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter & Urutkan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(platformFilterProvider.notifier).state = null;
                    ref.read(sortOptionProvider.notifier).state = GameSort.dateAddedDesc;
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: AppColors.secondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Platform Filter Section
            const Text(
              'PLATFORM',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // All Platforms Chip
                ChoiceChip(
                  label: const Text('Semua Platform'),
                  selected: selectedPlatform == null,
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(platformFilterProvider.notifier).state = null;
                    }
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.card,
                  labelStyle: TextStyle(
                    color: selectedPlatform == null ? Colors.white : AppColors.textSecondary,
                    fontWeight: selectedPlatform == null ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
                ...GamePlatform.values.map((p) {
                  final isSelected = selectedPlatform == p;
                  return ChoiceChip(
                    avatar: Text(p.icon, style: const TextStyle(fontSize: 12)),
                    label: Text(p.label),
                    selected: isSelected,
                    onSelected: (selected) {
                      ref.read(platformFilterProvider.notifier).state = selected ? p : null;
                    },
                    selectedColor: AppColors.getPlatformColor(p).withValues(alpha: 0.3),
                    backgroundColor: AppColors.card,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 13,
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 24),

            // Sort Section
            const Text(
              'URUTKAN BERDASARKAN',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 10),
            ...GameSort.values.map((sort) {
              final isSelected = selectedSort == sort;
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  sort.label,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_rounded, color: AppColors.primary, size: 20)
                    : null,
                onTap: () {
                  ref.read(sortOptionProvider.notifier).state = sort;
                  Navigator.of(context).pop();
                },
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
