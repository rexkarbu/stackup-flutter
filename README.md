# 🎮 StackUp — Game Backlog & Priority Tracker

<p align="center">
  <b>Aplikasi pelacak tumpukan game (backlog) offline-first untuk Android dengan fokus pada progress bermain dan antrean prioritas (Up Next queue).</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android" />
  <img src="https://img.shields.io/badge/Database-Isar%20v3-FF6F00?style=for-the-badge" alt="Isar Database" />
  <img src="https://img.shields.io/badge/State-Riverpod%202.5-blueviolet?style=for-the-badge" alt="Riverpod" />
  <a href="https://github.com/rexkarbu/stackup-flutter/releases/latest"><img src="https://img.shields.io/github/v/release/rexkarbu/stackup-flutter?style=for-the-badge&color=2ea44f&label=Release" alt="Latest Release" /></a>
</p>

<p align="center">
  <a href="https://github.com/rexkarbu/stackup-flutter/releases/download/v1.0.0/app-release.apk"><b>📥 Download Release APK (v1.0.0)</b></a>
</p>

---

## ✨ Fitur Utama (MVP)

- 📋 **Katalog Backlog Lengkap**:
  - Tampilan grid/list responsif dengan thumbnail cover lokal, badge platform berwarna, status pill, dan durasi bermain.
  - Pencarian judul real-time & multi-filter (*Status*, *Platform*, dan *Sorting*).
- 🚀 **Up Next Queue (Antrean Prioritas Bermain)**:
  - Antrean khusus game berstatus *Backlog* yang diurutkan berdasarkan prioritas.
  - **Drag & Drop Reordering** interaktif dengan `ReorderableListView` untuk menyusun ulang giliran game yang ingin dimainkan duluan.
  - Tombol aksi cepat **"Mainkan Sekarang"** untuk langsung memindahkan game ke status *Sedang Dimainkan*.
- ⏱️ **Progress & Rating Tracking**:
  - Pencatatan durasi bermain (jam main) dengan tombol tambah cepat (+1 jam, +2 jam, +5 jam).
  - Rating bintang (1.0 - 5.0) saat game ditamatkan (*Completed*).
  - Timeline tanggal (ditambahkan, mulai dimainkan, selesai).
- 🏷️ **Multi-Tag Genre & Catatan Pribadi**:
  - Input genre fleksibel dengan rekomendasi instan (*Action, RPG, Adventure, Indie, Strategy*, dll.).
  - Catatan bebas per game untuk review pribadi, cheat, atau build target.
- 📊 **Statistik & Analitik Bermain**:
  - Total koleksi game & total akumulasi jam bermain.
  - Tingkat penyelesaian (*Completion Rate %*) dengan visual progress bar.
  - Distribusi status, proporsi platform, dan *Top Rated Games*.
- 📴 **100% Offline-First & Privacy-Focused**:
  - Menggunakan Isar Database lokal yang super cepat.
  - Penyimpanan cover game permanen di internal storage perangkat (bebas dari pembersihan cache otomatis).

---

## 🛠️ Tech Stack & Arsitektur

- **Framework**: [Flutter](https://flutter.dev) (Material 3 Dark Gamer Theme)
- **State Management**: [Riverpod 2.5+](https://riverpod.dev) (`StreamProvider`, `StateProvider`)
- **Local Database**: [Isar Database v3.1+](https://isar.dev) (Non-blocking async query & stream)
- **Image Handling**: `image_picker` + Custom `FileHelper` (salin permanen ke App Directory)
- **Arsitektur**: Clean Architecture dengan struktur *Feature-First* (`features/backlog`, `features/up_next`, `features/detail`, `features/form`, `features/stats`).

---

## 📁 Struktur Folder

```
lib/
├── core/
│   ├── database/       # Inisialisasi Isar singleton service
│   ├── theme/          # Palet warna gamer dark & tema Material 3
│   └── utils/          # FileHelper (manajemen cover) & Formatters
├── models/             # Entitas @collection Isar & Enum status/platform
├── repositories/       # Abstraksi & implementasi Isar repository
├── providers/          # Riverpod state & stream providers
└── features/           # Modul fitur (UI screens, widgets & dialogs)
    ├── navigation/     # Shell 3-tab BottomNavigationBar + FAB
    ├── backlog/        # Katalog utama, pencarian & filter sheet
    ├── up_next/        # Antrean prioritas bermain drag-and-drop
    ├── detail/         # Detail hero, quick status changer, jam & rating
    ├── form/           # Form tambah & edit game + image picker
    └── stats/          # Ringkasan analitik & metrik gamer
```

---

## 🚀 Memulai Proyek (Getting Started)

### Prasyarat
- Flutter SDK (>= 3.3.0)
- Android SDK / Perangkat Android untuk pengujian

### Instalasi & Menjalankan Aplikasi
1. **Clone repository**:
   ```bash
   git clone https://github.com/rexkarbu/stackup-flutter.git
   cd stackup-flutter
   ```

2. **Pasang dependensi**:
   ```bash
   flutter pub get
   ```

3. **Jalankan code generator (Isar)**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Jalankan aplikasi**:
   ```bash
   flutter run
   ```

5. **Kompilasi APK Android (Opsional)**:
   ```bash
   flutter build apk --debug
   ```

---

## 🗺️ Roadmap & Pengembangan Lanjutan
Lihat dokumen lengkap [tasks.md](tasks.md) untuk detail perencanaan fitur Fase 3 (*Cost-per-hour tracker*, *Backup/Restore JSON*, *Auto-fill Metadata via API*) dan Fase 4 (*Play Store release*).

---

## 📄 Lisensi
Didistribusikan di bawah lisensi MIT. Silakan gunakan dan kembangkan secara bebas!
