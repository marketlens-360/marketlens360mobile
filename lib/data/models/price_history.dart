class PriceHistory {
  const PriceHistory({
    required this.date,
    this.open,
    this.high,
    this.low,
    this.close,
    this.volume,
  });

  final String date;
  final double? open;
  final double? high;
  final double? low;
  final double? close;
  final double? volume;

  factory PriceHistory.fromJson(Map<String, dynamic> j) => PriceHistory(
        date: j['date'] as String,
        open: (j['open'] as num?)?.toDouble(),
        high: (j['high'] as num?)?.toDouble(),
        low: (j['low'] as num?)?.toDouble(),
        close: (j['close'] as num?)?.toDouble(),
        volume: (j['volume'] as num?)?.toDouble(),
      );
}
