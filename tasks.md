# Roadmap & Tasks: StackUp (Game Backlog & Priority Tracker)

Dokumen ini melacak seluruh fase pengembangan aplikasi **StackUp**, mulai dari inisialisasi MVP (Minimum Viable Product) hingga rencana fitur lanjutan di masa mendatang.

---

## Ringkasan Status Proyek

| Fase | Deskripsi | Status |
| :--- | :--- | :--- |
| **Fase 1** | Foundation, Database & Core Architecture | ✅ **SELESAI** |
| **Fase 2** | Fitur Utama MVP & UI/UX Layar | ✅ **SELESAI** |
| **Fase 3** | Fitur Lanjutan & Produktivitas Gamer | ⏳ **TERENCANA (Next Sprint)** |
| **Fase 4** | Integrasi Eksternal, Polish & Rilis | ⏳ **TERENCANA** |

---

## Fase 1: Foundation, Database & Core Architecture (MVP)
> **Fokus**: Menyiapkan pondasi proyek, local database offline-first, state management, dan arsitektur data.

- [x] **1.1 Setup Project & Dependencies**
  - [x] Inisialisasi proyek Flutter (Android target, Material 3).
  - [x] Konfigurasi dependencies di `pubspec.yaml` (`flutter_riverpod`, `isar`, `isar_flutter_libs`, `image_picker`, `path_provider`, `flutter_rating_bar`, `intl`).
  - [x] Konfigurasi Android AGP 8 namespace injection & override `compileSdk 36` di `android/build.gradle.kts`.
  - [x] Konfigurasi `kotlin.incremental=false` di `android/gradle.properties` untuk kompatibilitas Windows multi-drive.
- [x] **1.2 Data Models & Enums**
  - [x] Enum `GameStatus` (`backlog`, `playing`, `completed`, `dropped`) di `lib/models/game_enums.dart`.
  - [x] Enum `GamePlatform` (`pc`, `ps5`, `ps4`, `switch_`, `xbox`, `mobile`, `other`) dengan label dan emoji ikon.
  - [x] Enum `GameSort` (`titleAsc`, `dateAddedDesc`, `ratingDesc`, `hoursPlayedDesc`).
  - [x] Entity `@collection` `BacklogGame` di `lib/models/backlog_game.dart`.
  - [x] Menjalankan `build_runner` untuk men-generate `backlog_game.g.dart`.
- [x] **1.3 Theme & Design System**
  - [x] Palet warna gamer dark di `lib/core/theme/app_colors.dart` (Background `#12131C`, Surface `#1E1F2E`, Card `#27293D`, Accent Indigo & Cyan, warna status, warna platform).
  - [x] Tema Material 3 terpadu di `lib/core/theme/app_theme.dart`.
- [x] **1.4 Core Utilities**
  - [x] `FileHelper` di `lib/core/utils/file_helper.dart` untuk menyalin cover foto dari temporary cache ke `ApplicationDocumentsDirectory/covers/` secara permanen dan menghapus file saat game dihapus.
  - [x] `Formatters` di `lib/core/utils/formatters.dart` untuk format tanggal, jam bermain, dan rating.
- [x] **1.5 Database & Repository Layer**
  - [x] `IsarService` di `lib/core/database/isar_service.dart` sebagai singleton inisialisasi Isar database.
  - [x] Interface `GameRepository` di `lib/repositories/game_repository.dart`.
  - [x] Implementasi `IsarGameRepository` di `lib/repositories/isar_game_repository.dart` (query filter dinamis, stream reaktif, batch update priority, dan rules transisi status).
- [x] **1.6 State Management (Riverpod)**
  - [x] `game_providers.dart`: Stream providers untuk all games, up next queue, dan detail game.
  - [x] `filter_providers.dart`: State providers untuk search query, status filter, platform filter, dan sort options.
  - [x] `stats_providers.dart`: Computed provider untuk analitik library game.

---

## Fase 2: Fitur Utama MVP & UI/UX Layar
> **Fokus**: Membangun seluruh layar aplikasi, interaksi pengguna, dan verifikasi kualitas kode.

- [x] **2.1 Main Navigation Shell**
  - [x] `MainScaffold` di `lib/features/navigation/main_scaffold.dart` dengan 3 Bottom Navigation bar item (Backlog, Up Next, Stats).
  - [x] Floating Action Button (+) di tab Backlog untuk membuka form tambah game.
- [x] **2.2 Backlog Screen (Katalog Game)**
  - [x] `SearchBarWidget` di `lib/features/backlog/widgets/search_bar_widget.dart` untuk pencarian real-time.
  - [x] Filter status horizontal chips (*Semua*, *Backlog*, *Sedang Dimainkan*, *Selesai*, *Di-drop*).
  - [x] `FilterSheet` modal bottom sheet untuk filter platform dan pilihan urutan (sort).
  - [x] `GameCard` widget dengan cover thumbnail, badge platform, status pill, jam bermain, dan rating bintang.
  - [x] Empty state yang informatif saat tidak ada game.
- [x] **2.3 Up Next Queue Screen (Antrean Prioritas Bermain)**
  - [x] Filter khusus game berstatus `Backlog` terurut `priority ASC`.
  - [x] `ReorderableListView` dengan drag handle untuk mengatur ulang prioritas antrean.
  - [x] Batch transaction ke database Isar saat terjadi reordering.
  - [x] Tombol cepat "Mainkan Sekarang" (ikon play) yang langsung mengubah status ke *Sedang Dimainkan*, mengisi `dateStarted = DateTime.now()`, dan menampilkan snackbar.
  - [x] Empty state motivasi saat antrean kosong.
- [x] **2.4 Game Detail Screen**
  - [x] Hero cover header besar dengan overlay gradien halus ke warna background.
  - [x] Judul game, badge platform, tags genre, dan riwayat tanggal.
  - [x] Quick Status Changer segmented pills dengan aturan bisnis otomatis (mulai main & selesai main).
  - [x] Progress tracking jam main dengan tombol dialog `HoursDialog` (+1h, +2h, +5h).
  - [x] Rating bintang interaktif `RatingDialog` saat game selesai ditamatkan.
  - [x] Bagian Catatan Pribadi (notes).
  - [x] Tombol Edit (buka form) dan Hapus permanen dengan dialog konfirmasi.
- [x] **2.5 Add / Edit Game Form Screen**
  - [x] `ImagePickerField` pemilih foto galeri dengan pratinjau, tombol ganti, dan tombol hapus cover.
  - [x] Validasi input judul game (wajib diisi).
  - [x] Choice chips pemilihan Platform dan Status awal.
  - [x] Genre multi-tag input dengan chip saran cepat (*Action*, *RPG*, *Adventure*, *Shooter*, *Indie*, dll.).
  - [x] Input jam bermain dan catatan pribadi.
  - [x] Otomatis assign `priority = maxPriority + 1` untuk game backlog baru.
- [x] **2.6 Stats & Summary Screen**
  - [x] Summary card: Total Games, Total Waktu Bermain, dan Completion Rate (%).
  - [x] Progress bar visual tingkat penyelesaian game.
  - [x] Breakdown kartu status (Backlog, Sedang Dimainkan, Selesai, Di-drop) dengan hitungan dan persentase.
  - [x] Distribusi kepemilikan platform game.
  - [x] Showcase mini kartu game dengan rating tertinggi.
- [x] **2.7 Pengujian & Verifikasi**
  - [x] Unit test model, enum, formatter, dan palet warna di folder `test/` (100% lulus).
  - [x] `flutter analyze` bersih tanpa warning atau lint error (0 issue).
  - [x] Berhasil kompilasi `flutter build apk --debug` menghasilkan file APK Android.

---

## Fase 3: Fitur Lanjutan & Produktivitas Gamer (Phase 2 / Next Sprint)
> **Fokus**: Memberikan nilai tambah bagi gamer yang ingin mengelola keuangan bermain, otomatisasi metadata, dan backup data.

- [ ] **3.1 Cost-per-Hour Tracker**
  - [ ] Tambahkan field `purchasePrice` (nullable double) pada entitas `BacklogGame`.
  - [ ] Hitung metrik efisiensi biaya: `Cost per Hour = purchasePrice / hoursPlayed`.
  - [ ] Indikator visual "Worth It Index" pada kartu game dan detail screen (misal: `< Rp 10.000 / jam` = Sangat Worth It).
- [ ] **3.2 Backup & Restore (Import / Export Data)**
  - [ ] Fitur ekspor seluruh data library ke file `.json` atau `.csv`.
  - [ ] Fitur impor file backup untuk pemulihan data atau migrasi perangkat.
  - [ ] Opsi menyertakan arsip gambar cover ke dalam file zip backup.
- [ ] **3.3 Auto-fill Metadata Game via API**
  - [ ] Integrasi REST API (misal RAWG Video Games Database API atau IGDB API).
  - [ ] Auto-complete judul game saat mengetik di form tambah game.
  - [ ] Otomatis menarik gambar cover resmi, tanggal rilis, pengembang, dan genre langsung dari web.
- [ ] **3.4 Local Reminder & Backlog Nudge**
  - [ ] Integrasi `flutter_local_notifications`.
  - [ ] Notifikasi pengingat berkala jika ada game dalam status *Sedang Dimainkan* yang sudah lama tidak dibuka (> 14 hari).
  - [ ] Rekomendasi game teratas dari antrean *Up Next* untuk dimainkan di akhir pekan.

---

## Fase 4: Polish, Platform & Production Readiness
> **Fokus**: Menyiapkan aplikasi untuk distribusi publik di Google Play Store dan pengalaman pengguna maksimal.

- [ ] **4.1 Custom App Icon & Splash Screen**
  - [ ] Desain ikon aplikasi resmi StackUp (vektor logo bertema tumpukan kaset/stik game).
  - [ ] Konfigurasi `flutter_launcher_icons` untuk icon Android (adaptif & legacy).
  - [ ] Konfigurasi native splash screen menggunakan `flutter_native_splash`.
- [ ] **4.2 Multi-Language Support (i18n)**
  - [ ] Dukungan bilingual (Bahasa Indonesia & Bahasa Inggris).
  - [ ] Konfigurasi Flutter `flutter_localizations` & berkas `.arb`.
- [ ] **4.3 Filter Lanjutan & Tagging Kustom**
  - [ ] Filter berdasarkan genre spesifik di Backlog Screen.
  - [ ] Filter berdasarkan rentang tahun penambahan atau rating.
- [ ] **4.4 Play Store Release Preparation**
  - [ ] Konfigurasi Proguard / R8 rules untuk Isar database obfuscation.
  - [ ] Pembuatan Android App Bundle (`flutter build appbundle --release`).
  - [ ] Penyiapan aset screenshot dan deskripsi aplikasi di Google Play Console.
