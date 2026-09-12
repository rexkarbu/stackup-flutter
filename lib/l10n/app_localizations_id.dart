// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'StackUp';

  @override
  String get appSubtitle => 'Game Backlog & Tracker';

  @override
  String get tabBacklog => 'Backlog';

  @override
  String get tabUpNext => 'Up Next';

  @override
  String get tabStats => 'Statistik';

  @override
  String get searchHint => 'Cari judul game...';

  @override
  String get filterAll => 'Semua';

  @override
  String get filterPlatform => 'PLATFORM';

  @override
  String get filterGenre => 'GENRE';

  @override
  String get filterSort => 'URUTKAN BERDASARKAN';

  @override
  String get reset => 'Reset';

  @override
  String get emptyBacklogTitle => 'Tidak ada game ditemukan';

  @override
  String get emptyBacklogDesc =>
      'Coba ubah kata kunci pencarian atau filter, atau tambahkan game baru dengan tombol (+)';

  @override
  String get playNow => 'Mainkan Sekarang';

  @override
  String get addGameTitle => 'Tambah Game';

  @override
  String get editGameTitle => 'Edit Game';

  @override
  String get save => 'Simpan';

  @override
  String get cancel => 'Batal';

  @override
  String get delete => 'Hapus';

  @override
  String get totalGames => 'Total Game';

  @override
  String get totalHours => 'Total Waktu';

  @override
  String get completionRate => 'Tingkat Selesai';

  @override
  String get costEfficiency => 'Efisiensi Biaya';

  @override
  String get backupTitle => 'Cadangan Data Lokal';

  @override
  String get exportJson => 'Ekspor JSON';

  @override
  String get importJson => 'Impor JSON';

  @override
  String get language => 'Bahasa Aplikasi';
}
