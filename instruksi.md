# Rencana Aplikasi: Game Backlog Tracker (Flutter)

## 1. Konsep & Tujuan

Aplikasi buat nge-track tumpukan game yang belum/lagi dimainkan — beda dari watchlist film/anime, fokusnya di sini lebih ke **progress & prioritas**: game apa yang lagi jadi antrean utama buat dimainin duluan, plus progress-nya sejauh mana.

Target: Android, offline-first, semua data lokal di HP.

## 2. Fitur Utama (MVP)

- **List backlog** — semua game yang dipunya/pengen dimainkan, dengan cover, platform, status
- **Status**: `Backlog` (belum mulai), `Sedang Dimainkan`, `Selesai`, `Di-drop`
- **Platform tag** — PC, PS5, PS4, Switch, Xbox, Mobile, Lainnya (satu game bisa aja dipunya di platform beda, jadi platform ini bagian dari entry, bukan dari "judul game" global)
- **Priority/Up Next queue** — list terpisah yang bisa di-reorder manual (drag & drop) buat nentuin urutan main berikutnya; ini pembeda utama dari sekadar list biasa
- **Progress tracking** — jam bermain (input manual) dan/atau persentase progress
- **Rating** — setelah status "Selesai"
- **Genre tag** — bebas, multi-tag
- **Catatan pribadi** per game
- **Filter & sort** — by status, platform, rating, prioritas
- **Search** judul cepat

## 3. Fitur Lanjutan (Phase 2 — opsional)

- Stats: total backlog, jam main total bulan ini, completion rate, platform paling sering dimainkan
- Cost-per-hour (harga beli dibagi jam main) — fun stat buat liat "worth it" atau nggak
- Auto-fill metadata & cover via API (misal IGDB atau RAWG API)
- Import/export data (JSON/CSV)
- Reminder/nudge "udah lama gak sentuh game ini nih"

## 4. Struktur Data

```
BacklogGame
- id: String (uuid)
- title: String
- platform: enum (pc, ps5, ps4, switch, xbox, mobile, other)
- genres: List<String>
- status: enum (backlog, playing, completed, dropped)
- priority: int (urutan manual di Up Next queue)
- rating: double? (nullable, hanya aktif kalau status = completed)
- coverPath: String? (path file lokal)
- hoursPlayed: double? (input manual)
- notes: String?
- dateAdded: DateTime
- dateStarted: DateTime?
- dateCompleted: DateTime?
```

## 5. Navigasi & Layar

- **Bottom navigation 3 tab**: Backlog | Up Next | Stats
- **Backlog screen** — grid/list semua game, filter by status/platform, search, FAB tambah
- **Up Next screen** — list game dengan status "Backlog", bisa drag-reorder buat nentuin prioritas main
- **Detail screen** — cover besar, info lengkap, ubah status, progress jam main, rating (kalau selesai)
- **Add/Edit screen** — form: judul, platform, genre tag, cover (pilih dari galeri), catatan
- **Stats screen** — ringkasan angka (Phase 2 bisa lebih detail)

## 6. Tech Stack

- Flutter (Android)
- State management: Riverpod
- Local database: Isar
- Image picker: `image_picker`
- Reorderable list: `ReorderableListView` bawaan Flutter (cukup buat drag-reorder Up Next)
- Material 3, dark mode default

## 7. Tahapan Development

1. Setup project, model data, Isar schema
2. CRUD dasar per game (tambah/edit/hapus)
3. UI Backlog tab + detail screen
4. Up Next tab dengan drag-reorder
5. Progress & rating flow
6. Filter, sort, search
7. Stats screen
8. Polish UI

---

## 8. Prompt Siap Kirim ke Antigravity CLI (tahap planning)

Kali ini alurnya beda dari sebelumnya: prompt di bawah **bukan** buat langsung eksekusi coding, tapi buat diproses dulu di **Antigravity CLI** — biar CLI yang matengin rencana ini jadi spek teknis final dan nulis prompt build-nya ke file. Setelah itu, isi file hasilnya baru kamu buka/paste ke **Antigravity IDE** buat proses eksekusi/vibecoding-nya.

Jalankan `agy` di folder project, lalu paste ini:

```
Saya mau bikin aplikasi Flutter (Android) bernama "GameLog" — game backlog tracker,
buat nge-track tumpukan game yang belum/lagi dimainkan beserta progress dan prioritas
antrean main berikutnya.

DRAFT RENCANA:

Fitur utama:
- List backlog semua game (cover, platform, status)
- Status: Backlog, Sedang Dimainkan, Selesai, Di-drop
- Platform tag per entry: PC, PS5, PS4, Switch, Xbox, Mobile, Lainnya
- Up Next queue terpisah — list game status "Backlog" yang bisa di-reorder manual
  (drag & drop) buat nentuin prioritas main berikutnya
- Progress: input manual jam bermain
- Rating setelah status "Selesai"
- Genre tag bebas (multi-tag)
- Catatan pribadi per game
- Filter & sort (status, platform, rating, prioritas), search judul

Model data dasar (BacklogGame): id, title, platform (enum), genres (list), status (enum),
priority (int, urutan di Up Next), rating (nullable), coverPath (nullable), hoursPlayed
(nullable), notes (nullable), dateAdded, dateStarted (nullable), dateCompleted (nullable).

Navigasi: 3 tab bottom nav — Backlog, Up Next, Stats. Layar: Backlog list, Up Next
(reorderable), Detail, Add/Edit form, Stats.

Tech stack yang saya mau: Flutter, Riverpod (state management), Isar (local database,
offline-first tanpa backend), image_picker buat cover, ReorderableListView buat Up Next.

TOLONG:
1. Review dan elaborasi draft di atas jadi spesifikasi teknis yang lebih matang dan detail
   — lengkapi kalau ada bagian yang masih kurang jelas atau bisa didekati dengan lebih baik,
   tapi tetap jaga scope-nya realistis buat MVP (jangan over-engineer).
2. Tulis hasil akhirnya sebagai satu prompt build yang komprehensif dan siap pakai, simpan
   ke file bernama PROMPT.md di folder project ini.
3. Prompt di PROMPT.md itu nantinya bakal saya buka dan paste ke Antigravity IDE buat
   proses eksekusi/coding-nya oleh AI coding agent lain — jadi tulis dengan detail teknis
   yang cukup (tech stack, struktur data lengkap, semua screen beserta isinya, dan instruksi
   implementasi) supaya bisa langsung dieksekusi tanpa perlu nanya balik hal-hal dasar.
```

Setelah CLI selesai nulis `PROMPT.md`, buka file itu, cek isinya, baru copy-paste ke Antigravity IDE buat mulai proses coding-nya.
