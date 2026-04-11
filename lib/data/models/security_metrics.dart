class SecurityMetrics {
  const SecurityMetrics({
    this.symbol,
    this.peRatio,
    this.pbRatio,
    this.roe,
    this.roa,
    this.profitMargin,
    this.debtToEquity,
    this.currentRatio,
    this.revenueGrowth,
    this.earningsGrowth,
    this.dividendYield,
    this.marketCap,
    this.date,
  });

  final String? symbol;
  final double? peRatio;
  final double? pbRatio;
  final double? roe;
  final double? roa;
  final double? profitMargin;
  final double? debtToEquity;
  final double? currentRatio;
  final double? revenueGrowth;
  final double? earningsGrowth;
  final double? dividendYield;
  final double? marketCap;
  final String? date;

  factory SecurityMetrics.fromJson(Map<String, dynamic> j) => SecurityMetrics(
        symbol: j['symbol'] as String?,
        peRatio: (j['pe_ratio'] as num?)?.toDouble(),
        pbRatio: (j['pb_ratio'] as num?)?.toDouble(),
        roe: (j['roe'] as num?)?.toDouble(),
        roa: (j['roa'] as num?)?.toDouble(),
        profitMargin: (j['profit_margin'] as num?)?.toDouble(),
        debtToEquity: (j['debt_to_equity'] as num?)?.toDouble(),
        currentRatio: (j['current_ratio'] as num?)?.toDouble(),
        revenueGrowth: (j['revenue_growth'] as num?)?.toDouble(),
        earningsGrowth: (j['earnings_growth'] as num?)?.toDouble(),
        dividendYield: (j['dividend_yield'] as num?)?.toDouble(),
        marketCap: (j['market_cap'] as num?)?.toDouble(),
        date: j['date'] as String?,
      );
}
