import 'package:isar/isar.dart';
import 'game_enums.dart';

part 'backlog_game.g.dart';

@collection
class BacklogGame {
  Id id = Isar.autoIncrement;

  late String title;

  @enumerated
  late GamePlatform platform;

  List<String> genres = [];

  @enumerated
  late GameStatus status;

  // Nilai 0, 1, 2... untuk urutan manual di Up Next queue
  int priority = 0;

  // Hanya diisi jika status == GameStatus.completed (1.0 - 5.0)
  double? rating;

  // Path lokal di ApplicationDocumentsDirectory (BUKAN path cache temp)
  String? coverPath;

  // Jam bermain (akumulatif, misal: 14.5 jam)
  double hoursPlayed = 0.0;

  String? notes;

  late DateTime dateAdded;
  DateTime? dateStarted;
  DateTime? dateCompleted;
}
