abstract final class ApiEndpoints {
  // ── Securities ───────────────────────────────────────────────────────────
  static const String securities         = '/securities';
  static String security(String symbol)  => '/securities/$symbol';
  static String securitySummary(String symbol) => '/securities/$symbol/summary';
  static String priceHistory(String symbol)    => '/securities/$symbol/prices';
  static String latestPrice(String symbol)     => '/securities/$symbol/prices/latest';
  static String earnings(String symbol)        => '/securities/$symbol/earnings';
  static String dividends(String symbol)       => '/securities/$symbol/dividends';
  static String metrics(String symbol)         => '/securities/$symbol/metrics';
  static String metricsHistory(String symbol)  => '/securities/$symbol/metrics/history';

  // ── Market ───────────────────────────────────────────────────────────────
  static const String indices       = '/market/indices';
  static String indexHistory(String code) => '/market/indices/$code/history';
  static const String marketOverview = '/market/overview';
  static const String topGainers    = '/market/top-gainers';
  static const String topLosers     = '/market/top-losers';

  // ── Funds ─────────────────────────────────────────────────────────────────
  static const String funds           = '/funds';
  static String fundById(int id)      => '/funds/$id';
  static String fundByCode(String code) => '/funds/code/$code';
  static const String topPerformers   = '/funds/top-performers';
  static const String largestFunds    = '/funds/largest';
  static const String lowestFeeFunds  = '/funds/lowest-fees';
  static const String mostAccessible  = '/funds/most-accessible';
  static const String searchFunds     = '/funds/search';
  static const String compareFunds    = '/funds/compare';

  // ── Fund Performance ─────────────────────────────────────────────────────
  static String monthlyPerformance(int fundId)  => '/funds/$fundId/performance/monthly';
  static String yearlyPerformance(int fundId)   => '/funds/$fundId/performance/yearly';
  static String performanceSummary(int fundId)  => '/funds/$fundId/performance/summary';
  static const String allPerformanceSummaries   = '/funds/performance/summaries';
  static String portfolioHoldings(int fundId)   => '/funds/$fundId/portfolio';
  static const String averagePortfolioAllocation = '/funds/portfolio/average-allocation';
  static const String comparePerformance        = '/funds/performance/compare';
  static const String feeEfficiency             = '/funds/performance/fee-efficiency';

  // ── Fund Managers ─────────────────────────────────────────────────────────
  static const String managers         = '/fund-managers';
  static String manager(int id)        => '/fund-managers/$id';
  static const String topManagers      = '/fund-managers/top';
  static const String searchManagers   = '/fund-managers/search';
  static const String managersNear     = '/fund-managers/near';

  // ── Fund Rankings ─────────────────────────────────────────────────────────
  static const String rankingsByReturn   = '/fund-rankings/by-return';
  static const String rankingsBySize     = '/fund-rankings/by-size';
  static const String leaderboard        = '/fund-rankings/leaderboard';
  static String fundRank(int fundId)     => '/fund-rankings/$fundId';
  static String rankingTrends(int fundId) => '/fund-rankings/$fundId/trends';
  static String rankingsByCategory(String category) => '/fund-rankings/category/$category';
  static const String fundMarketStats   = '/fund-rankings/market-stats';
}
