// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'StackUp';

  @override
  String get appSubtitle => 'Game Backlog & Tracker';

  @override
  String get tabBacklog => 'Backlog';

  @override
  String get tabUpNext => 'Up Next';

  @override
  String get tabStats => 'Stats';

  @override
  String get searchHint => 'Search game title...';

  @override
  String get filterAll => 'All';

  @override
  String get filterPlatform => 'PLATFORM';

  @override
  String get filterGenre => 'GENRE';

  @override
  String get filterSort => 'SORT BY';

  @override
  String get reset => 'Reset';

  @override
  String get emptyBacklogTitle => 'No games found';

  @override
  String get emptyBacklogDesc =>
      'Try changing search keywords or filters, or add a new game using the (+) button';

  @override
  String get playNow => 'Play Now';

  @override
  String get addGameTitle => 'Add Game';

  @override
  String get editGameTitle => 'Edit Game';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get totalGames => 'Total Games';

  @override
  String get totalHours => 'Total Time';

  @override
  String get completionRate => 'Completion Rate';

  @override
  String get costEfficiency => 'Cost Efficiency';

  @override
  String get backupTitle => 'Local Data Backup';

  @override
  String get exportJson => 'Export JSON';

  @override
  String get importJson => 'Import JSON';

  @override
  String get language => 'App Language';
}
