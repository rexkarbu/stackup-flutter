import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileHelper {
  /// Menyalin file dari cache/temporary directory ke ApplicationDocumentsDirectory
  /// agar tidak hilang saat cache dibersihkan oleh sistem operasi.
  static Future<String> saveCoverImagePermanently(String sourcePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(sourcePath)}';
    final destinationPath = path.join(appDir.path, 'covers', fileName);

    // Pastikan folder 'covers' dibuat jika belum ada
    final coversDir = Directory(path.join(appDir.path, 'covers'));
    if (!await coversDir.exists()) {
      await coversDir.create(recursive: true);
    }

    final sourceFile = File(sourcePath);
    final savedFile = await sourceFile.copy(destinationPath);
    return savedFile.path;
  }

  /// Menghapus file cover lokal jika file tersebut ada
  static Future<void> deleteCoverImage(String? filePath) async {
    if (filePath == null || filePath.isEmpty) return;
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Abaikan jika file gagal dihapus (misal file terkunci atau izin terbatas)
    }
  }
}
