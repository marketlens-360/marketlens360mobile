class MonthlyPerformance {
  const MonthlyPerformance({
    this.fundId,
    this.year,
    this.month,
    this.netReturn,
    this.grossReturn,
    this.navPerUnit,
    this.aum,
  });

  final int? fundId;
  final int? year;
  final int? month;
  final double? netReturn;
  final double? grossReturn;
  final double? navPerUnit;
  final double? aum;

  factory MonthlyPerformance.fromJson(Map<String, dynamic> j) =>
      MonthlyPerformance(
        fundId: j['fund_id'] as int?,
        year: j['year'] as int?,
        month: j['month'] as int?,
        netReturn: (j['net_return'] as num?)?.toDouble(),
        grossReturn: (j['gross_return'] as num?)?.toDouble(),
        navPerUnit: (j['nav_per_unit'] as num?)?.toDouble(),
        aum: (j['aum'] as num?)?.toDouble(),
      );
}

class YearlyPerformance {
  const YearlyPerformance({
    this.fundId,
    this.year,
    this.netReturn,
    this.grossReturn,
    this.navPerUnit,
    this.aum,
  });

  final int? fundId;
  final int? year;
  final double? netReturn;
  final double? grossReturn;
  final double? navPerUnit;
  final double? aum;

  factory YearlyPerformance.fromJson(Map<String, dynamic> j) =>
      YearlyPerformance(
        fundId: j['fund_id'] as int?,
        year: j['year'] as int?,
        netReturn: (j['net_return'] as num?)?.toDouble(),
        grossReturn: (j['gross_return'] as num?)?.toDouble(),
        navPerUnit: (j['nav_per_unit'] as num?)?.toDouble(),
        aum: (j['aum'] as num?)?.toDouble(),
      );
}

class PerformanceSummary {
  const PerformanceSummary({
    this.fundId,
    this.fundName,
    this.return1m,
    this.return3m,
    this.return6m,
    this.return1y,
    this.annualizedReturn,
    this.volatility,
    this.sharpeRatio,
  });

  final int? fundId;
  final String? fundName;
  final double? return1m;
  final double? return3m;
  final double? return6m;
  final double? return1y;
  final double? annualizedReturn;
  final double? volatility;
  final double? sharpeRatio;

  factory PerformanceSummary.fromJson(Map<String, dynamic> j) =>
      PerformanceSummary(
        fundId: j['fund_id'] as int?,
        fundName: j['fund_name'] as String?,
        return1m: (j['return_1m'] as num?)?.toDouble(),
        return3m: (j['return_3m'] as num?)?.toDouble(),
        return6m: (j['return_6m'] as num?)?.toDouble(),
        return1y: (j['return_1y'] as num?)?.toDouble(),
        annualizedReturn: (j['annualized_return'] as num?)?.toDouble(),
        volatility: (j['volatility'] as num?)?.toDouble(),
        sharpeRatio: (j['sharpe_ratio'] as num?)?.toDouble(),
      );
}

class PortfolioHolding {
  const PortfolioHolding({
    this.fundId,
    this.instrumentType,
    this.instrumentName,
    this.allocationPercent,
    this.marketValue,
    this.date,
  });

  final int? fundId;
  final String? instrumentType;
  final String? instrumentName;
  final double? allocationPercent;
  final double? marketValue;
  final String? date;

  factory PortfolioHolding.fromJson(Map<String, dynamic> j) => PortfolioHolding(
        fundId: j['fund_id'] as int?,
        instrumentType: j['instrument_type'] as String?,
        instrumentName: j['instrument_name'] as String?,
        allocationPercent: (j['allocation_percent'] as num?)?.toDouble(),
        marketValue: (j['market_value'] as num?)?.toDouble(),
        date: j['date'] as String?,
      );
}

class AverageAllocation {
  const AverageAllocation({
    this.instrumentType,
    this.averageAllocation,
    this.date,
  });

  final String? instrumentType;
  final double? averageAllocation;
  final String? date;

  factory AverageAllocation.fromJson(Map<String, dynamic> j) =>
      AverageAllocation(
        instrumentType: j['instrument_type'] as String?,
        averageAllocation: (j['average_allocation'] as num?)?.toDouble(),
        date: j['date'] as String?,
      );
}

class FundComparison {
  const FundComparison({
    this.fundId,
    this.fundName,
    this.return1m,
    this.return3m,
    this.return6m,
    this.return1y,
    this.managementFee,
    this.aum,
  });

  final int? fundId;
  final String? fundName;
  final double? return1m;
  final double? return3m;
  final double? return6m;
  final double? return1y;
  final double? managementFee;
  final double? aum;

  factory FundComparison.fromJson(Map<String, dynamic> j) => FundComparison(
        fundId: j['fund_id'] as int?,
        fundName: j['fund_name'] as String?,
        return1m: (j['return_1m'] as num?)?.toDouble(),
        return3m: (j['return_3m'] as num?)?.toDouble(),
        return6m: (j['return_6m'] as num?)?.toDouble(),
        return1y: (j['return_1y'] as num?)?.toDouble(),
        managementFee: (j['management_fee'] as num?)?.toDouble(),
        aum: (j['aum'] as num?)?.toDouble(),
      );
}

class FeeEfficiency {
  const FeeEfficiency({
    this.fundId,
    this.fundName,
    this.managementFee,
    this.return1y,
    this.feeAdjustedReturn,
    this.rank,
  });

  final int? fundId;
  final String? fundName;
  final double? managementFee;
  final double? return1y;
  final double? feeAdjustedReturn;
  final int? rank;

  factory FeeEfficiency.fromJson(Map<String, dynamic> j) => FeeEfficiency(
        fundId: j['fund_id'] as int?,
        fundName: j['fund_name'] as String?,
        managementFee: (j['management_fee'] as num?)?.toDouble(),
        return1y: (j['return_1y'] as num?)?.toDouble(),
        feeAdjustedReturn: (j['fee_adjusted_return'] as num?)?.toDouble(),
        rank: j['rank'] as int?,
      );
}
