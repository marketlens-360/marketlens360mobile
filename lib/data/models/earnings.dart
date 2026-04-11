class Earnings {
  const Earnings({
    this.symbol,
    this.fiscalYear,
    this.fiscalPeriod,
    this.revenue,
    this.netIncome,
    this.eps,
    this.reportDate,
  });

  final String? symbol;
  final int? fiscalYear;
  final String? fiscalPeriod;
  final double? revenue;
  final double? netIncome;
  final double? eps;
  final String? reportDate;

  factory Earnings.fromJson(Map<String, dynamic> j) => Earnings(
        symbol: j['symbol'] as String?,
        fiscalYear: j['fiscal_year'] as int?,
        fiscalPeriod: j['fiscal_period'] as String?,
        revenue: (j['revenue'] as num?)?.toDouble(),
        netIncome: (j['net_income'] as num?)?.toDouble(),
        eps: (j['eps'] as num?)?.toDouble(),
        reportDate: j['report_date'] as String?,
      );
}
