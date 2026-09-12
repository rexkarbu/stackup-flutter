import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/rawg_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/backlog_game.dart';
import '../../../models/game_enums.dart';
import '../../../providers/game_providers.dart';
import '../widgets/image_picker_field.dart';

class GameFormScreen extends ConsumerStatefulWidget {
  final BacklogGame? game;

  const GameFormScreen({super.key, this.game});

  @override
  ConsumerState<GameFormScreen> createState() => _GameFormScreenState();
}

class _GameFormScreenState extends ConsumerState<GameFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _hoursController;
  late final TextEditingController _priceController;
  late final TextEditingController _notesController;
  late final TextEditingController _genreInputController;

  String? _coverPath;
  late GamePlatform _platform;
  late GameStatus _status;
  late List<String> _genres;

  bool _isSaving = false;

  final List<String> _suggestedGenres = [
    'Action',
    'RPG',
    'Adventure',
    'Shooter',
    'Indie',
    'Strategy',
    'Puzzle',
    'Horror',
    'Open World',
    'Platformer',
  ];

  @override
  void initState() {
    super.initState();
    final g = widget.game;

    _titleController = TextEditingController(text: g?.title ?? '');
    _hoursController = TextEditingController(
      text: g != null
          ? (g.hoursPlayed % 1 == 0
              ? g.hoursPlayed.toInt().toString()
              : g.hoursPlayed.toString())
          : '0',
    );
    _priceController = TextEditingController(
      text: g?.purchasePrice != null ? g!.purchasePrice!.toInt().toString() : '',
    );
    _notesController = TextEditingController(text: g?.notes ?? '');
    _genreInputController = TextEditingController();

    _coverPath = g?.coverPath;
    _platform = g?.platform ?? GamePlatform.pc;
    _status = g?.status ?? GameStatus.backlog;
    _genres = g != null ? List<String>.from(g.genres) : [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _hoursController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    _genreInputController.dispose();
    super.dispose();
  }

  void _addGenre(String genre) {
    final trimmed = genre.trim();
    if (trimmed.isNotEmpty && !_genres.contains(trimmed)) {
      setState(() {
        _genres.add(trimmed);
      });
      _genreInputController.clear();
    }
  }

  void _removeGenre(String genre) {
    setState(() {
      _genres.remove(genre);
    });
  }

  Future<bool> _showApiKeyDialog() async {
    final controller = TextEditingController(text: RawgService.apiKey);
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Row(
          children: [
            Icon(Icons.vpn_key_rounded, color: AppColors.secondary, size: 22),
            SizedBox(width: 8),
            Text(
              'RAWG API Key',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan API Key RAWG Anda untuk menggunakan fitur pencarian metadata otomatis dan unduh cover resmi.',
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
              decoration: const InputDecoration(
                hintText: '32-karakter API key...',
                prefixIcon: Icon(Icons.key, color: AppColors.textMuted, size: 18),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Dapatkan free key di rawg.io/apidocs',
              style: TextStyle(fontSize: 11.5, color: AppColors.secondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                RawgService.apiKey = controller.text.trim();
                Navigator.of(ctx).pop(true);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _searchRawgMetadata() async {
    if (RawgService.apiKey.isEmpty) {
      final saved = await _showApiKeyDialog();
      if (!saved || RawgService.apiKey.isEmpty) return;
    }

    final query = _titleController.text.trim();
    if (query.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ketik judul game terlebih dahulu'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.85,
          expand: false,
          builder: (scrollContext, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome,
                          color: AppColors.secondary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Hasil Pencarian RAWG: "$query"',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            size: 18, color: AppColors.textMuted),
                        onPressed: () => Navigator.of(sheetContext).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.cardBorder),
                Expanded(
                  child: FutureBuilder<List<RawgGameResult>>(
                    future: RawgService.search(query),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline_rounded,
                                    color: Colors.redAccent, size: 36),
                                const SizedBox(height: 8),
                                Text(
                                  'Gagal memuat data dari RAWG:\n${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final results = snapshot.data ?? [];
                      if (results.isEmpty) {
                        return const Center(
                          child: Text(
                            'Tidak ada game ditemukan untuk kata kunci ini.',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: results.length,
                        separatorBuilder: (_, __) =>
                            const Divider(color: AppColors.cardBorder, height: 1),
                        itemBuilder: (context, index) {
                          final item = results[index];
                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 6),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: AppColors.card,
                                child: item.imageUrl != null
                                    ? Image.network(
                                        item.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(
                                          Icons.sports_esports_outlined,
                                          color: AppColors.textMuted,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.sports_esports_outlined,
                                        color: AppColors.textMuted,
                                      ),
                              ),
                            ),
                            title: Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              [
                                if (item.releaseYear != null)
                                  '${item.releaseYear}',
                                if (item.genres.isNotEmpty)
                                  item.genres.take(2).join(', '),
                              ].join(' • '),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: AppColors.textMuted,
                            ),
                            onTap: () {
                              Navigator.of(sheetContext).pop();
                              _applyRawgResult(item);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _applyRawgResult(RawgGameResult item) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: Card(
          color: AppColors.card,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 14),
                Text(
                  'Menerapkan metadata & cover...',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    String? localCoverPath;
    if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
      localCoverPath = await RawgService.downloadAndSaveCover(item.imageUrl!);
    }

    if (mounted) {
      Navigator.of(context).pop(); // Dismiss loading dialog

      setState(() {
        _titleController.text = item.title;
        for (final g in item.genres) {
          final trimmed = g.trim();
          if (trimmed.isNotEmpty && !_genres.contains(trimmed)) {
            _genres.add(trimmed);
          }
        }
        if (localCoverPath != null) {
          _coverPath = localCoverPath;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Metadata & Cover berhasil diterapkan!'),
          backgroundColor: Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _saveGame() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final hours = double.tryParse(_hoursController.text.trim()) ?? 0.0;
      final priceClean =
          _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final price = priceClean.isNotEmpty ? double.tryParse(priceClean) : null;
      final repo = ref.read(gameRepositoryProvider);

      if (widget.game == null) {
        // Mode Tambah Baru
        final newGame = BacklogGame()
          ..title = _titleController.text.trim()
          ..platform = _platform
          ..status = _status
          ..genres = _genres
          ..hoursPlayed = hours
          ..purchasePrice = price
          ..notes = _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim()
          ..coverPath = _coverPath
          ..dateAdded = DateTime.now();

        if (_status == GameStatus.backlog) {
          final maxP = await repo.getMaxPriority();
          newGame.priority = maxP + 1;
        }

        if (_status == GameStatus.playing) {
          newGame.dateStarted = DateTime.now();
        } else if (_status == GameStatus.completed) {
          newGame.dateStarted = DateTime.now();
          newGame.dateCompleted = DateTime.now();
          newGame.rating = 4.0;
        }

        await repo.saveGame(newGame);
      } else {
        // Mode Edit
        final g = widget.game!;
        g.title = _titleController.text.trim();
        g.platform = _platform;
        g.genres = _genres;
        g.hoursPlayed = hours;
        g.purchasePrice = price;
        g.notes = _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim();
        g.coverPath = _coverPath;

        // Cek transisi status
        if (g.status != _status) {
          g.status = _status;
          if (_status == GameStatus.playing && g.dateStarted == null) {
            g.dateStarted = DateTime.now();
          } else if (_status == GameStatus.completed) {
            g.dateCompleted ??= DateTime.now();
            g.rating ??= 4.0;
          }
        }

        await repo.saveGame(g);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan game: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.game != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Game' : 'Tambah Game Baru',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.secondary,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: _isSaving ? null : _saveGame,
              icon: _isSaving
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.secondary),
                    )
                  : const Icon(Icons.check_rounded, size: 20),
              label: Text(_isSaving ? 'Menyimpan...' : 'Simpan'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Cover Image Picker
              ImagePickerField(
                key: ValueKey(_coverPath),
                initialImagePath: _coverPath,
                onImageSelected: (path) {
                  _coverPath = path;
                },
              ),
              const SizedBox(height: 20),

              // Title Field
              const Text(
                'JUDUL GAME *',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Misal: The Witcher 3: Wild Hunt',
                  prefixIcon: const Icon(Icons.videogame_asset_outlined,
                      color: AppColors.textMuted, size: 20),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.auto_awesome,
                        color: AppColors.secondary),
                    tooltip: 'Cari Metadata via RAWG',
                    onPressed: _searchRawgMetadata,
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Judul game tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Platform ChoiceChips
              const Text(
                'PLATFORM',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: GamePlatform.values.map((p) {
                  final isSelected = _platform == p;
                  final color = AppColors.getPlatformColor(p);
                  return ChoiceChip(
                    avatar: Text(p.icon, style: const TextStyle(fontSize: 12)),
                    label: Text(p.label),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _platform = p);
                      }
                    },
                    selectedColor: color.withValues(alpha: 0.25),
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12.5,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Status ChoiceChips
              const Text(
                'STATUS AWAL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: GameStatus.values.map((s) {
                  final isSelected = _status == s;
                  final color = AppColors.getStatusColor(s);
                  return ChoiceChip(
                    label: Text(s.label),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _status = s);
                      }
                    },
                    selectedColor: color.withValues(alpha: 0.25),
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      color: isSelected ? color : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12.5,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Genre Tags Input
              const Text(
                'GENRE & TAGS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _genreInputController,
                      style: const TextStyle(
                          color: AppColors.textPrimary, fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Ketik genre lalu tekan (+)...',
                        isDense: true,
                        prefixIcon: Icon(Icons.tag_rounded,
                            color: AppColors.textMuted, size: 18),
                      ),
                      onSubmitted: _addGenre,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.add_rounded, size: 20),
                    onPressed: () =>
                        _addGenre(_genreInputController.text),
                  ),
                ],
              ),
              if (_genres.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _genres.map((g) {
                    return Chip(
                      label: Text(g),
                      deleteIcon: const Icon(Icons.close_rounded, size: 14),
                      onDeleted: () => _removeGenre(g),
                      backgroundColor: AppColors.card,
                      labelStyle: const TextStyle(
                          fontSize: 12, color: AppColors.textPrimary),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 8),
              // Suggested Genres
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: _suggestedGenres
                    .where((s) => !_genres.contains(s))
                    .take(6)
                    .map((s) {
                  return ActionChip(
                    label: Text('+ $s'),
                    labelStyle: const TextStyle(
                        fontSize: 11, color: AppColors.textMuted),
                    backgroundColor: AppColors.surface,
                    onPressed: () => _addGenre(s),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Hours Played Field
              const Text(
                'JAM BERMAIN (OPSIONAL)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _hoursController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: '0',
                  suffixText: 'Jam',
                  prefixIcon: Icon(Icons.schedule_rounded,
                      color: AppColors.textMuted, size: 20),
                ),
              ),
              const SizedBox(height: 20),

              // Purchase Price Field
              const Text(
                'HARGA BELI (OPSIONAL)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Harga Beli (Rp)',
                  prefixText: 'Rp ',
                  hintText: 'Kosongkan jika gratis / langganan',
                  prefixIcon: Icon(Icons.payments_outlined,
                      color: AppColors.textMuted, size: 20),
                ),
              ),
              const SizedBox(height: 20),

              // Notes Field
              const Text(
                'CATATAN PRIBADI',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText:
                      'Tulis review singkat, cheat, target build, atau rencana bermain...',
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isSaving ? null : _saveGame,
                  child: Text(
                    _isSaving
                        ? 'Menyimpan...'
                        : (isEdit ? 'Simpan Perubahan' : 'Tambahkan ke Backlog'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
