class FundRanking {
  const FundRanking({
    this.fundId,
    this.fundName,
    this.rank,
    this.score,
    this.category,
    this.date,
    this.rankType,
  });

  final int? fundId;
  final String? fundName;
  final int? rank;
  final double? score;
  final String? category;
  final String? date;
  final String? rankType;

  factory FundRanking.fromJson(Map<String, dynamic> j) => FundRanking(
        fundId: j['fund_id'] as int?,
        fundName: j['fund_name'] as String?,
        rank: j['rank'] as int?,
        score: (j['score'] as num?)?.toDouble(),
        category: j['category'] as String?,
        date: j['date'] as String?,
        rankType: j['rank_type'] as String?,
      );
}

class FundRankingDetail {
  const FundRankingDetail({
    this.fundId,
    this.fundName,
    this.rank,
    this.totalFunds,
    this.percentile,
    this.score,
    this.date,
    this.rankType,
  });

  final int? fundId;
  final String? fundName;
  final int? rank;
  final int? totalFunds;
  final double? percentile;
  final double? score;
  final String? date;
  final String? rankType;

  factory FundRankingDetail.fromJson(Map<String, dynamic> j) =>
      FundRankingDetail(
        fundId: j['fund_id'] as int?,
        fundName: j['fund_name'] as String?,
        rank: j['rank'] as int?,
        totalFunds: j['total_funds'] as int?,
        percentile: (j['percentile'] as num?)?.toDouble(),
        score: (j['score'] as num?)?.toDouble(),
        date: j['date'] as String?,
        rankType: j['rank_type'] as String?,
      );
}

class FundRankingTrend {
  const FundRankingTrend({
    this.fundId,
    this.date,
    this.rank,
    this.score,
    this.rankType,
  });

  final int? fundId;
  final String? date;
  final int? rank;
  final double? score;
  final String? rankType;

  factory FundRankingTrend.fromJson(Map<String, dynamic> j) => FundRankingTrend(
        fundId: j['fund_id'] as int?,
        date: j['date'] as String?,
        rank: j['rank'] as int?,
        score: (j['score'] as num?)?.toDouble(),
        rankType: j['rank_type'] as String?,
      );
}

class FundMarketStats {
  const FundMarketStats({
    this.totalFunds,
    this.totalAum,
    this.averageReturn1y,
    this.totalInvestors,
    this.year,
    this.month,
  });

  final int? totalFunds;
  final double? totalAum;
  final double? averageReturn1y;
  final int? totalInvestors;
  final int? year;
  final int? month;

  factory FundMarketStats.fromJson(Map<String, dynamic> j) => FundMarketStats(
        totalFunds: j['total_funds'] as int?,
        totalAum: (j['total_aum'] as num?)?.toDouble(),
        averageReturn1y: (j['average_return_1y'] as num?)?.toDouble(),
        totalInvestors: j['total_investors'] as int?,
        year: j['year'] as int?,
        month: j['month'] as int?,
      );
}
