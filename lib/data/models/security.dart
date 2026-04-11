class Security {
  const Security({
    required this.symbol,
    this.name,
    this.sector,
    this.exchange,
    this.closePrice,
    this.changePercent,
    this.changeAmount,
    this.volume,
    this.marketCap,
    this.isActive,
  });

  final String symbol;
  final String? name;
  final String? sector;
  final String? exchange;
  final double? closePrice;
  final double? changePercent;
  final double? changeAmount;
  final double? volume;
  final double? marketCap;
  final bool? isActive;

  factory Security.fromJson(Map<String, dynamic> j) => Security(
        symbol: j['symbol'] as String,
        name: j['name'] as String?,
        sector: j['sector'] as String?,
        exchange: j['exchange'] as String?,
        closePrice: ((j['current_price'] ?? j['close_price']) as num?)?.toDouble(),
        changePercent: ((j['price_change'] ?? j['change_percent']) as num?)?.toDouble(),
        changeAmount: ((j['change'] ?? j['change_amount']) as num?)?.toDouble(),
        volume: (j['volume'] as num?)?.toDouble(),
        marketCap: (j['market_cap'] as num?)?.toDouble(),
        isActive: j['is_active'] as bool?,
      );
}

class SecuritySummary {
  const SecuritySummary({
    required this.symbol,
    this.name,
    this.sector,
    this.exchange,
    this.closePrice,
    this.openPrice,
    this.highPrice,
    this.lowPrice,
    this.changePercent,
    this.changeAmount,
    this.volume,
    this.marketCap,
    this.peRatio,
    this.dividendYield,
    this.week52High,
    this.week52Low,
  });

  final String symbol;
  final String? name;
  final String? sector;
  final String? exchange;
  final double? closePrice;
  final double? openPrice;
  final double? highPrice;
  final double? lowPrice;
  final double? changePercent;
  final double? changeAmount;
  final double? volume;
  final double? marketCap;
  final double? peRatio;
  final double? dividendYield;
  final double? week52High;
  final double? week52Low;

  factory SecuritySummary.fromJson(Map<String, dynamic> j) => SecuritySummary(
        symbol: j['symbol'] as String,
        name: j['name'] as String?,
        sector: j['sector'] as String?,
        exchange: j['exchange'] as String?,
        closePrice: (j['close_price'] as num?)?.toDouble(),
        openPrice: (j['open_price'] as num?)?.toDouble(),
        highPrice: (j['high_price'] as num?)?.toDouble(),
        lowPrice: (j['low_price'] as num?)?.toDouble(),
        changePercent: (j['change_percent'] as num?)?.toDouble(),
        changeAmount: (j['change_amount'] as num?)?.toDouble(),
        volume: (j['volume'] as num?)?.toDouble(),
        marketCap: (j['market_cap'] as num?)?.toDouble(),
        peRatio: (j['pe_ratio'] as num?)?.toDouble(),
        dividendYield: (j['dividend_yield'] as num?)?.toDouble(),
        week52High: (j['week_52_high'] as num?)?.toDouble(),
        week52Low: (j['week_52_low'] as num?)?.toDouble(),
      );
}
