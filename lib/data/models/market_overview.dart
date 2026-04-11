class MarketOverview {
  const MarketOverview({
    this.nasiValue,
    this.nasiChange,
    this.nse20Value,
    this.nse20Change,
    this.totalTurnover,
    this.totalVolume,
    this.advancers,
    this.decliners,
    this.unchanged,
    this.date,
  });

  final double? nasiValue;
  final double? nasiChange;
  final double? nse20Value;
  final double? nse20Change;
  final double? totalTurnover;
  final double? totalVolume;
  final int? advancers;
  final int? decliners;
  final int? unchanged;
  final String? date;

  factory MarketOverview.fromJson(Map<String, dynamic> j) => MarketOverview(
        nasiValue: (j['nasi_value'] as num?)?.toDouble(),
        nasiChange: (j['nasi_change'] as num?)?.toDouble(),
        nse20Value: (j['nse20_value'] as num?)?.toDouble(),
        nse20Change: (j['nse20_change'] as num?)?.toDouble(),
        totalTurnover: (j['total_turnover'] as num?)?.toDouble(),
        totalVolume: (j['total_volume'] as num?)?.toDouble(),
        advancers: j['advancers'] as int?,
        decliners: j['decliners'] as int?,
        unchanged: j['unchanged'] as int?,
        date: j['date'] as String?,
      );
}
