import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/backlog_game.dart';

class IsarService {
  static Isar? _instance;

  static Future<Isar> init() async {
    if (_instance != null && _instance!.isOpen) {
      return _instance!;
    }

    final existing = Isar.getInstance();
    if (existing != null && existing.isOpen) {
      _instance = existing;
      return existing;
    }

    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [BacklogGameSchema],
      directory: dir.path,
      name: 'stackup_db',
      inspector: true,
    );
    return _instance!;
  }

  static Isar get instance {
    if (_instance == null || !_instance!.isOpen) {
      throw StateError('IsarService belum diinisialisasi. Panggil IsarService.init() terlebih dahulu.');
    }
    return _instance!;
  }
}
