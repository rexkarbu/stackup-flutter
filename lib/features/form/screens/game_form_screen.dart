import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<void> _saveGame() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final hours = double.tryParse(_hoursController.text.trim()) ?? 0.0;
      final repo = ref.read(gameRepositoryProvider);

      if (widget.game == null) {
        // Mode Tambah Baru
        final newGame = BacklogGame()
          ..title = _titleController.text.trim()
          ..platform = _platform
          ..status = _status
          ..genres = _genres
          ..hoursPlayed = hours
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
                decoration: const InputDecoration(
                  hintText: 'Misal: The Witcher 3: Wild Hunt',
                  prefixIcon: Icon(Icons.videogame_asset_outlined,
                      color: AppColors.textMuted, size: 20),
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
