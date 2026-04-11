class MarketIndex {
  const MarketIndex({
    required this.code,
    this.name,
    this.value,
    this.changePercent,
    this.changeAmount,
    this.date,
  });

  final String code;
  final String? name;
  final double? value;
  final double? changePercent;
  final double? changeAmount;
  final String? date;

  factory MarketIndex.fromJson(Map<String, dynamic> j) => MarketIndex(
        code: j['code'] as String,
        name: j['name'] as String?,
        value: (j['value'] as num?)?.toDouble(),
        changePercent: (j['change_percent'] as num?)?.toDouble(),
        changeAmount: (j['change_amount'] as num?)?.toDouble(),
        date: j['date'] as String?,
      );
}
