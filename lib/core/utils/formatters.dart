import 'package:flutter/services.dart';
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

  /// Format mata uang Rupiah
  static String formatCurrency(double? amount) {
    if (amount == null || amount <= 0) return 'Gratis / N/A';
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(amount);
  }

  /// Format biaya per jam bermain
  static String formatCostPerHour(double? cph) {
    if (cph == null) return '-';
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return '${formatter.format(cph)} / jam';
  }

  /// Format angka dengan pemisah ribuan titik (contoh: 120000 -> 120.000)
  static String formatNumber(num? number) {
    if (number == null || number == 0) return '';
    final formatter = NumberFormat.decimalPattern('id');
    return formatter.format(number);
  }
}

/// Formatter input real-time dengan pemisah ribuan titik (Indonesian style: 120.000)
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static final NumberFormat _formatter = NumberFormat.decimalPattern('id');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Hitung posisi kursor dan jumlah digit sebelum kursor pada input baru
    final cursorPosition = newValue.selection.baseOffset;
    final textBeforeCursor = cursorPosition > 0 && cursorPosition <= newValue.text.length
        ? newValue.text.substring(0, cursorPosition)
        : newValue.text;
    final digitsBeforeCursor =
        textBeforeCursor.replaceAll(RegExp(r'[^0-9]'), '').length;

    final cleanDigits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanDigits.isEmpty) {
      return const TextEditingValue();
    }

    // Tangani backspace pada tanda titik '.'
    final oldDigits = oldValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    String adjustedDigits = cleanDigits;
    int targetDigitCount = digitsBeforeCursor;

    if (oldValue.text.length > newValue.text.length && oldDigits == cleanDigits) {
      if (digitsBeforeCursor > 0) {
        adjustedDigits = cleanDigits.substring(0, digitsBeforeCursor - 1) +
            cleanDigits.substring(digitsBeforeCursor);
        targetDigitCount = digitsBeforeCursor - 1;
      }
    }

    if (adjustedDigits.isEmpty) {
      return const TextEditingValue();
    }

    // Maksimal 12 digit (hingga ratusan miliar)
    final truncated = adjustedDigits.length > 12
        ? adjustedDigits.substring(0, 12)
        : adjustedDigits;
    final number = int.tryParse(truncated);
    if (number == null) return oldValue;

    final formatted = _formatter.format(number);

    // Hitung posisi kursor baru yang proporsional
    int newCursorOffset = 0;
    int countedDigits = 0;
    for (int i = 0; i < formatted.length; i++) {
      if (RegExp(r'[0-9]').hasMatch(formatted[i])) {
        countedDigits++;
      }
      if (countedDigits == targetDigitCount) {
        newCursorOffset = i + 1;
        break;
      }
    }
    if (targetDigitCount == 0) {
      newCursorOffset = 0;
    } else if (newCursorOffset == 0) {
      newCursorOffset = formatted.length;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorOffset),
    );
  }
}
