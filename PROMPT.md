# PROMPT BUILD: StackUp — Game Backlog & Priority Tracker (Flutter)

Copy dan paste seluruh isi prompt di bawah ini ke **Antigravity IDE** untuk mengeksekusi pembuatan aplikasi secara utuh.

---

```markdown
# Role & Objective
Kamu adalah Senior Flutter & Mobile App Architect. Tugasmu adalah membangun aplikasi Android bernama **"StackUp"** secara utuh dan siap dijalankan (production-ready MVP), sebuah aplikasi pelacak tumpukan game (game backlog tracker) dengan fokus utama pada **progress dan antrean prioritas bermain** (Up Next queue) yang bekerja secara **offline-first**.

---

## 1. TECH STACK & DEPENDENCIES

Pastikan menggunakan dependencies yang stabil dan kompatibel:
- **Framework**: Flutter (Android target, Material 3, Dark Mode default)
- **State Management**: `flutter_riverpod` (v2.5+)
- **Local Database**: `isar` (v3.1.0+) & `isar_flutter_libs` (dengan `build_runner` & `isar_generator`)
- **Image Picker & File**: `image_picker`, `path_provider`, `path`
- **UI & Icons**: `flutter_rating_bar` (atau custom star widget), `intl`, icons Material / Cupertino

### Rekomendasi `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  path_provider: ^2.1.2
  path: ^1.9.0
  image_picker: ^1.0.7
  flutter_rating_bar: ^4.0.1
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.8
  isar_generator: ^3.1.0+1
  flutter_lints: ^3.0.0

# CATATAN ISAR COMPATIBILITY:
# Jika terjadi konflik versi `analyzer` pada Flutter terbaru (Dart 3.3+) saat `flutter pub get`
# atau `build_runner`, tambahkan override berikut:
dependency_overrides:
  analyzer: ^6.4.1
```
*(Alternatif jika Isar v3 tetap bentrok pada Flutter SDK environment Anda: gunakan `isar_community` / `isar_community_generator` versi ^3.1.0+2, atau `sqflite` / `drift` dengan tetap mempertahankan pola Repository yang sama).*

---

## 2. STRUKTUR PROYEK (Feature-First)

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── database/
│   │   └── isar_service.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── app_colors.dart
│   └── utils/
│       ├── file_helper.dart
│       └── formatters.dart
├── models/
│   ├── game_enums.dart
│   └── backlog_game.dart (Isar collection)
├── repositories/
│   ├── game_repository.dart
│   └── isar_game_repository.dart
├── providers/
│   ├── game_providers.dart
│   ├── filter_providers.dart
│   └── stats_providers.dart
└── features/
    ├── navigation/
    │   └── main_scaffold.dart
    ├── backlog/
    │   ├── screens/backlog_screen.dart
    │   └── widgets/
    │       ├── game_card.dart
    │       ├── filter_sheet.dart
    │       └── search_bar_widget.dart
    ├── up_next/
    │   ├── screens/up_next_screen.dart
    │   └── widgets/up_next_item.dart
    ├── detail/
    │   ├── screens/game_detail_screen.dart
    │   └── widgets/
    │       ├── hours_dialog.dart
    │       └── rating_dialog.dart
    ├── form/
    │   ├── screens/game_form_screen.dart
    │   └── widgets/image_picker_field.dart
    └── stats/
        ├── screens/stats_screen.dart
        └── widgets/stat_card.dart
```

---

## 3. MODEL DATA & SCHEMA ISAR

### Enums (`lib/models/game_enums.dart`):
```dart
enum GameStatus {
  backlog('Backlog'),
  playing('Sedang Dimainkan'),
  completed('Selesai'),
  dropped('Di-drop');

  final String label;
  const GameStatus(this.label);
}

enum GamePlatform {
  pc('PC', '💻'),
  ps5('PlayStation 5', '🎮'),
  ps4('PlayStation 4', '🎮'),
  switch_('Nintendo Switch', '🕹️'),
  xbox('Xbox Series/One', '❎'),
  mobile('Mobile', '📱'),
  other('Lainnya', '🎲');

  final String label;
  final String icon;
  const GamePlatform(this.label, this.icon);
}

enum GameSort {
  priorityAsc('Prioritas (Up Next)'),
  titleAsc('Judul (A-Z)'),
  dateAddedDesc('Terbaru Ditambahkan'),
  ratingDesc('Rating Tertinggi'),
  hoursPlayedDesc('Jam Main Terbanyak');

  final String label;
  const GameSort(this.label);
}
```

### Entity Collection (`lib/models/backlog_game.dart`):
```dart
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

  // Rating 1.0 - 5.0 (Tetap disimpan di DB jika status berganti, tapi hanya ditampilkan di UI jika status == completed)
  double? rating;

  // BEST PRACTICE PATH RELATIF:
  // Hanya simpan nama file (misal: '1710000000_cover.jpg'), BUKAN path absolut penuh.
  // Gunakan FileHelper untuk me-resolve path lengkap via getApplicationDocumentsDirectory().
  String? coverFileName;

  // Jam bermain (akumulatif, misal: 14.5 jam)
  double hoursPlayed = 0.0;

  String? notes;

  late DateTime dateAdded;
  DateTime? dateStarted;
  DateTime? dateCompleted;
}
```

---

## 4. CORE UTILS: FILE HELPER (PATH RELATIF & COVER MANAGEMENT)

Buat `lib/core/utils/file_helper.dart` untuk manajemen file cover yang tangguh terhadap update aplikasi:
```dart
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileHelper {
  /// Salin file dari temporary cache (image_picker) ke penyimpanan permanen
  /// dan kembalikan NAMA FILE saja (bukan path absolut).
  static Future<String> saveCoverImage(File sourceFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final coversDir = Directory(p.join(appDir.path, 'covers'));
    if (!await coversDir.exists()) {
      await coversDir.create(recursive: true);
    }
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(sourceFile.path)}';
    final permanentFile = File(p.join(coversDir.path, fileName));
    await sourceFile.copy(permanentFile.path);
    return fileName;
  }

  /// Resolve nama file menjadi File objek dengan path absolut saat ini
  static Future<File?> getCoverFile(String? fileName) async {
    if (fileName == null || fileName.isEmpty) return null;
    final appDir = await getApplicationDocumentsDirectory();
    final file = File(p.join(appDir.path, 'covers', fileName));
    return await file.exists() ? file : null;
  }

  /// Hapus file cover fisik dari disk jika game dihapus atau cover diganti
  static Future<void> deleteCoverFile(String? fileName) async {
    if (fileName == null || fileName.isEmpty) return;
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final file = File(p.join(appDir.path, 'covers', fileName));
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }
}
```

---

## 5. DESIGN SYSTEM & UI/UX

- **Mode Gelap Default**: Gamer-centric minimalis. Background `#12131C`, Surface `#1E1F2E`, Card `#27293D`, Accent Indigo/Purple `#6366F1` atau Cyan `#06B6D4`.
- **Status Color Palette**:
  - `Backlog`: Amber/Orange (`#F59E0B`)
  - `Sedang Dimainkan`: Cyan/Sky (`#06B6D4`)
  - `Selesai`: Emerald/Green (`#10B981`)
  - `Di-drop`: Slate/Grey (`#64748B`)
- **Platform Badge**: Chips ringkas dengan ikon emoji dan warna spesifik platform.
- **Card Design**: Rounded corner (12px), cover aspect ratio 3:4 atau 16:9 yang rapi, fallback ke placeholder icon jika tidak ada cover.

---

## 6. DETAIL SPESIFIKASI FITUR & SCREEN

### A. Main Navigation (`MainScaffold`)
Bottom Navigation Bar Material 3 dengan 3 tab:
1. **Backlog** (Ikon: `Icons.grid_view_rounded` / `Icons.sports_esports`)
2. **Up Next** (Ikon: `Icons.format_list_numbered_rounded` / `Icons.playlist_play_rounded`)
3. **Stats** (Ikon: `Icons.insights_rounded` / `Icons.bar_chart_rounded`)
Floating Action Button (+) di tab Backlog untuk membuka `GameFormScreen` (Tambah Game).

---

### B. Screen 1: Backlog Catalog (`BacklogScreen`)
- **Top Header**: Judul "StackUp", Search Bar interaktif (filter real-time judul).
- **Filter & Sort Bar**:
  - Filter horizontal chips: Semua, Backlog, Dimainkan, Selesai, Di-drop.
  - Action button: Filter by Platform & Sort (Judul A-Z, Tanggal Ditambahkan, Rating, Jam Main).
- **Game List/Grid**: Tampilan kartu game responsif (ListView atau 2-column Grid).
  - Tiap item menampilkan: Cover thumbnail (via `FileHelper.getCoverFile`), judul, badge platform, status pill, jam bermain, bintang rating (jika selesai).
  - Tap kartu: Buka `GameDetailScreen`.
- **Empty State**: Ilustrasi/pesan ramah jika list kosong atau filter tidak menemukan game.

---

### C. Screen 2: Up Next Queue (`UpNextScreen`) — *Pembeda Utama*
- Menampilkan **hanya game dengan status `GameStatus.backlog`**, diurutkan ascending berdasarkan field `priority`.
- Menggunakan `ReorderableListView.builder`:
  - Beri `padding: const EdgeInsets.only(bottom: 96, left: 16, right: 16, top: 8)` agar item paling bawah tidak tertutup BottomNavigationBar.
  - Setiap card memiliki drag-handle (`Icons.drag_handle_rounded`) di sisi kanan.
  - Terdapat badge nomor urut urutan di sisi kiri (#1, #2, #3...).
  - Tombol aksi cepat: Tombol "Mainkan Sekarang" (ikon play) yang langsung mengubah status game menjadi `Sedang Dimainkan` dan auto-set `dateStarted = DateTime.now()`.
- **Reorder Logic**:
  ```dart
  void onReorder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    // Update urutan list lokal lalu update field priority seluruh item di Isar DB dalam satu batch write transaction
  }
  ```
- **Empty State**: Pesan motivasi jika tidak ada backlog yang mengantre.

---

### D. Screen 3: Detail Game (`GameDetailScreen`)
- **Header**: Hero image cover besar dengan gradient overlay ke warna background.
- **Title & Metadata Section**:
  - Judul game (h1).
  - Platform pill & tags genre (chips).
  - Tanggal: Ditambahkan, Mulai Dimainkan, Tanggal Selesai.
- **Quick Status Changer**: SegmentedButton / Dropdown untuk ganti status langsung (`Backlog` / `Sedang Dimainkan` / `Selesai` / `Di-drop`).
  - *Aturan Bisnis Transisi Status*:
    - **Pindah ke `Sedang Dimainkan`**: jika `dateStarted` masih null, otomatis isi `DateTime.now()`.
    - **Pindah ke `Selesai`**: munculkan popup rating (1.0 - 5.0) & isi `dateCompleted = DateTime.now()`.
    - **Pindah kembali ke `Backlog`** (dari Dimainkan / Selesai / Di-drop): otomatis set `priority = (maxPrioritySaatIni + 1)` agar masuk ke antrean Up Next terbawah tanpa bentrok indeks.
- **Rating Retention Rule**:
  - Jika game yang sudah `Selesai` diubah statusnya menjadi status lain, simpan nilai `rating` sebelumnya di database (jangan dihapus), namun **hanya tampilkan widget rating di UI jika status == `completed`**.
- **Progress Tracking (Jam Main)**:
  - Tampilan jam main besar (misal: "18.5 jam").
  - Tombol `+ Tambah Jam` yang membuka dialog: bisa ketik total jam baru atau tombol cepat `+1 jam`, `+2 jam`, `+5 jam`.
- **Personal Notes Section**:
  - Catatan bebas (review pribadi, cheat, target build, kenangan bermain).
- **App Bar Actions**: Edit (`GameFormScreen`) dan Hapus (Dialog konfirmasi sebelum hapus permanen beserta pembersihan file cover-nya via `FileHelper.deleteCoverFile`).

---

### E. Screen 4: Add / Edit Game (`GameFormScreen`)
- Form validasi:
  1. **Cover Image**: Tombol pilih foto dari galeri via `image_picker`.
     - Simpan permanen via `FileHelper.saveCoverImage(pickedImage)` dan simpan return `fileName` ke field `coverFileName`.
  2. **Judul Game**: TextFormField (wajib diisi).
  3. **Platform**: Choice chips / dropdown (PC, PS5, PS4, Switch, Xbox, Mobile, Lainnya).
  4. **Status Awal**: Default `Backlog`.
  5. **Genre Tags**: Input multi-tag (chips yang bisa dihapus dan ditambahkan dengan menekan enter/tambah).
  6. **Hours Played**: TextFormField number/decimal.
  7. **Catatan Pribadi**: TextFormField multiline.
- Saat simpan game baru dengan status `Backlog`:
  - Berikan `priority = (maxPrioritySaatIni + 1)` agar otomatis berada di urutan terbawah Up Next queue.

---

### F. Screen 5: Statistik & Ringkasan (`StatsScreen`)
Menghitung analitik dari data Isar secara reaktif:
- **Header Summary Card**:
  - Total Semua Game dalam library.
  - Total Jam Main akumulatif seluruh game.
  - Completion Rate (%) = `(Game Selesai / Total Game) * 100`.
- **Breakdown per Status**: Baris/Card menghitung jumlah:
  - ⏳ Backlog
  - 🎮 Sedang Dimainkan
  - 🏆 Selesai
  - 🛑 Di-drop
- **Platform Breakdown**: Menampilkan distribusi game berdasarkan platform yang paling banyak dimiliki.
- **Top Rated Games**: List mini game dengan rating tertinggi (bintang 4.5 - 5).

---

## 7. ARSITEKTUR REPOSITORY & RIVERPOD

1. **`IsarService`**: Singleton / Provider yang menginisialisasi Isar instance dengan skema `BacklogGameSchema`.
2. **`GameRepository`**:
   - `watchAllGames({String? query, GameStatus? status, GamePlatform? platform, GameSort? sort})`: Stream list game reaktif.
   - `watchUpNextGames()`: Stream game dengan status `Backlog` terurut `priority ASC`.
   - `saveGame(BacklogGame game)`: Tambah atau update.
   - `deleteGame(int id)`: Hapus dari DB + panggil `FileHelper.deleteCoverFile`.
   - `updatePriorityOrder(List<BacklogGame> reorderedList)`: Batch write transaksi update `priority`.
   - `updateHours(int id, double hours)`: Update jam main.
   - `updateStatus(int id, GameStatus status, {double? rating})`: Update status terpadu dengan aturan transisi (auto date & priority jika kembali ke backlog).
   - `getMaxPriority()`: Helper untuk mendapatkan prioritas tertinggi saat ini.
3. **Riverpod Providers**:
   - `gameListStreamProvider`: Provider auto-refresh dari Isar stream.
   - `upNextStreamProvider`: Stream khusus Up Next.
   - `statsSummaryProvider`: Computed provider yang menghitung total jam, completion rate, dan distribusi.

---

## 8. CHECKLIST EKSEKUSI TAHAP DEMI TAHAP

Jalankan implementasi dengan langkah berikut secara berurutan:
1. Inisialisasi dependensi di `pubspec.yaml` (termasuk `dependency_overrides` jika diperlukan) dan jalankan `flutter pub get`.
2. Buat seluruh enum (`GameStatus`, `GamePlatform`, `GameSort`) dan entity `BacklogGame` (dengan `coverFileName`).
3. Jalankan `dart run build_runner build --delete-conflicting-outputs` untuk men-generate file `backlog_game.g.dart`.
4. Buat `FileHelper` di `core/utils/file_helper.dart` untuk penyimpanan cover berbasis nama file relatif.
5. Siapkan `IsarService` dan `IsarGameRepository`.
6. Buat tema aplikasi gelap (Dark gamer palette) di `app_theme.dart` & `app_colors.dart`.
7. Implementasikan Riverpod providers (`game_providers.dart`, `filter_providers.dart`, `stats_providers.dart`).
8. Bangun `MainScaffold` dengan 3 Bottom Navigation items.
9. Bangun `BacklogScreen` lengkap dengan search, filter chip, dan card game.
10. Bangun `UpNextScreen` dengan `ReorderableListView` (dengan bottom padding 96px) dan aksi ubah ke `Sedang Dimainkan`.
11. Bangun `GameDetailScreen` dengan hero cover, quick status, dialog jam main, dan dialog rating.
12. Bangun `GameFormScreen` dengan image picker (via `FileHelper`) dan genre chip builder.
13. Bangun `StatsScreen` dengan ringkasan metrik dan distribusi platform.
14. Pastikan tidak ada compiler warning atau error, dan seluruh operasi I/O database berjalan non-blocking (async).

Bangun seluruh kode sumber aplikasi **StackUp** secara lengkap, rapi, dan modular sesuai struktur file di atas!
```
