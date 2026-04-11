import 'package:intl/intl.dart';

abstract final class Fmt {
  static final _priceFormat = NumberFormat('#,##0.00', 'en_US');
  static final _kesFormat   = NumberFormat('KES #,##0.00', 'en_US');
  static final _pctFormat   = NumberFormat('0.00', 'en_US');
  static final _dateLong    = DateFormat('dd MMM yyyy');
  static final _dateShort   = DateFormat('dd MMM');

  static String price(double? value) {
    if (value == null) return '—';
    return _priceFormat.format(value);
  }

  static String kes(double? value) {
    if (value == null) return '—';
    return _kesFormat.format(value);
  }

  static String kesCompact(double? value) {
    if (value == null) return '—';
    if (value.abs() >= 1e9) {
      return 'KES ${(value / 1e9).toStringAsFixed(1)}B';
    } else if (value.abs() >= 1e6) {
      return 'KES ${(value / 1e6).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1e3) {
      return 'KES ${(value / 1e3).toStringAsFixed(1)}K';
    }
    return kes(value);
  }

  static String pct(double? value) {
    if (value == null) return '—';
    final sign = value >= 0 ? '+' : '';
    return '$sign${_pctFormat.format(value)}%';
  }

  static String pctAbs(double? value) {
    if (value == null) return '—';
    return '${_pctFormat.format(value.abs())}%';
  }

  static String date(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '—';
    try {
      final dt = DateTime.parse(isoString);
      return _dateLong.format(dt);
    } catch (_) {
      return '—';
    }
  }

  static String dateShort(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '—';
    try {
      final dt = DateTime.parse(isoString);
      return _dateShort.format(dt);
    } catch (_) {
      return '—';
    }
  }

  static String monthYear(int year, int month) {
    final dt = DateTime(year, month);
    return DateFormat('MMM yyyy').format(dt);
  }

  static String compact(double? value) {
    if (value == null) return '—';
    if (value.abs() >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(1)}B';
    } else if (value.abs() >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}
