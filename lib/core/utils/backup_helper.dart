import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/backlog_game.dart';
import '../../repositories/game_repository.dart';

class BackupHelper {
  /// Ekspor seluruh game ke file JSON dan buka Share Sheet
  static Future<void> exportBackup(List<BacklogGame> games) async {
    final data = {
      'app': 'StackUp',
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'games': games.map((g) => g.toJson()).toList(),
    };
    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    final tempDir = await getTemporaryDirectory();
    final file = File(
        '${tempDir.path}/stackup_backup_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(jsonString);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Backup Data StackUp (${games.length} game)',
    );
  }

  /// Buka FilePicker, baca file .json, dan simpan game ke repository.
  /// Mengembalikan jumlah game yang berhasil diimpor.
  static Future<int?> importBackup(GameRepository repository) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.single.path == null) return null;

    final file = File(result.files.single.path!);
    final content = await file.readAsString();
    final dynamic decoded = jsonDecode(content);

    if (decoded is! Map<String, dynamic> || decoded['games'] is! List) {
      throw const FormatException('Format file backup tidak valid');
    }

    final gamesJson = decoded['games'] as List;
    int importedCount = 0;

    for (final item in gamesJson) {
      if (item is Map<String, dynamic>) {
        final game = BacklogGame.fromJson(item);
        await repository.saveGame(game);
        importedCount++;
      }
    }
    return importedCount;
  }
}
