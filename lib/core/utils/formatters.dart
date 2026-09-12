import 'package:intl/intl.dart';

class Formatters {
  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('dd MMM yyyy, HH:mm');

  /// Format tanggal (contoh: 12 Okt 2024)
  static String formatDate(DateTime? date) {
    if (date == null) return '-';
    return _dateFormat.format(date);
  }

  /// Format tanggal dengan jam
  static String formatDateTime(DateTime? date) {
    if (date == null) return '-';
    return _dateTimeFormat.format(date);
  }

  /// Format jam bermain (contoh: 14.5 jam atau 12 jam)
  static String formatHours(double? hours) {
    if (hours == null || hours <= 0) return '0 jam';
    if (hours % 1 == 0) {
      return '${hours.toInt()} jam';
    }
    return '${hours.toStringAsFixed(1)} jam';
  }

  /// Format rating
  static String formatRating(double? rating) {
    if (rating == null || rating <= 0) return '-';
    if (rating % 1 == 0) {
      return rating.toInt().toString();
    }
    return rating.toStringAsFixed(1);
  }
}
