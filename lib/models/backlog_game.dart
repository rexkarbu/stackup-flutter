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

  // Harga beli dalam Rupiah (nullable / opsional)
  double? purchasePrice;

  // Hitung biaya per jam bermain (getter)
  double? get costPerHour {
    if (purchasePrice == null || purchasePrice! <= 0 || hoursPlayed <= 0) return null;
    return purchasePrice! / hoursPlayed;
  }

  String? notes;

  late DateTime dateAdded;
  DateTime? dateStarted;
  DateTime? dateCompleted;

  Map<String, dynamic> toJson() => {
        'title': title,
        'platform': platform.name,
        'genres': genres,
        'status': status.name,
        'priority': priority,
        'rating': rating,
        'hoursPlayed': hoursPlayed,
        'purchasePrice': purchasePrice,
        'notes': notes,
        'dateAdded': dateAdded.toIso8601String(),
        'dateStarted': dateStarted?.toIso8601String(),
        'dateCompleted': dateCompleted?.toIso8601String(),
      };

  static BacklogGame fromJson(Map<String, dynamic> json) {
    final game = BacklogGame()
      ..title = json['title'] as String? ?? 'Untitled'
      ..platform = GamePlatform.values.firstWhere(
        (e) => e.name == json['platform'],
        orElse: () => GamePlatform.other,
      )
      ..genres = (json['genres'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          []
      ..status = GameStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => GameStatus.backlog,
      )
      ..priority = json['priority'] as int? ?? 0
      ..rating = (json['rating'] as num?)?.toDouble()
      ..hoursPlayed = (json['hoursPlayed'] as num?)?.toDouble() ?? 0.0
      ..purchasePrice = (json['purchasePrice'] as num?)?.toDouble()
      ..notes = json['notes'] as String?
      ..dateAdded = json['dateAdded'] != null
          ? DateTime.tryParse(json['dateAdded'] as String) ?? DateTime.now()
          : DateTime.now()
      ..dateStarted = json['dateStarted'] != null
          ? DateTime.tryParse(json['dateStarted'] as String)
          : null
      ..dateCompleted = json['dateCompleted'] != null
          ? DateTime.tryParse(json['dateCompleted'] as String)
          : null;
    return game;
  }
}
