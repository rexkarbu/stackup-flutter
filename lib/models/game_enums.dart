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
  titleAsc('Judul (A-Z)'),
  dateAddedDesc('Terbaru Ditambahkan'),
  ratingDesc('Rating Tertinggi'),
  hoursPlayedDesc('Jam Main Terbanyak');

  final String label;
  const GameSort(this.label);
}
