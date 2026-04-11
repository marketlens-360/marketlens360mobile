import 'package:dio/dio.dart';
import 'package:marketlens360mobile/core/network/api_endpoints.dart';
import 'package:marketlens360mobile/core/network/app_exception.dart';
import 'package:marketlens360mobile/data/models/fund.dart';
import 'package:marketlens360mobile/data/models/fund_manager.dart';
import 'package:marketlens360mobile/data/models/fund_performance.dart';
import 'package:marketlens360mobile/data/models/fund_ranking.dart';

class FundRepository {
  const FundRepository(this._dio);

  final Dio _dio;

  // ── Fund Queries ──────────────────────────────────────────────────────────

  Future<List<Fund>> getFunds({
    FundCategory? category,
    bool? active,
    String? sort,
    String? order,
  }) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.funds,
        queryParameters: {
          if (category != null) 'category': category.code,
          if (active != null) 'active': active,
          if (sort != null) 'sort': sort,
          if (order != null) 'order': order,
        },
      );
      return (res.data ?? [])
          .map((e) => Fund.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<Fund> getFundById(int id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiEndpoints.fundById(id));
      return Fund.fromJson(res.data!);
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<Fund> getFundByCode(String code) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiEndpoints.fundByCode(code));
      return Fund.fromJson(res.data!);
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<Fund>> getTopPerformers({
    FundCategory? category,
    int? limit,
    String? period,
  }) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.topPerformers,
        queryParameters: {
          if (category != null) 'category': category.code,
          if (limit != null) 'limit': limit,
          if (period != null) 'period': period,
        },
      );
      return (res.data ?? [])
          .map((e) => Fund.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<Fund>> getLargestFunds({FundCategory? category, int? limit}) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.largestFunds,
        queryParameters: {
          if (category != null) 'category': category.code,
          if (limit != null) 'limit': limit,
        },
      );
      return (res.data ?? [])
          .map((e) => Fund.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<Fund>> getLowestFeeFunds({FundCategory? category, int? limit}) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.lowestFeeFunds,
        queryParameters: {
          if (category != null) 'category': category.code,
          if (limit != null) 'limit': limit,
        },
      );
      return (res.data ?? [])
          .map((e) => Fund.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<Fund>> getMostAccessibleFunds({int? limit}) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.mostAccessible,
        queryParameters: {if (limit != null) 'limit': limit},
      );
      return (res.data ?? [])
          .map((e) => Fund.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<Fund>> searchFunds(String query) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.searchFunds,
        queryParameters: {'q': query},
      );
      return (res.data ?? [])
          .map((e) => Fund.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<FundComparison>> compareFunds(List<int> ids) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.compareFunds,
        queryParameters: {'ids': ids.join(',')},
      );
      return (res.data ?? [])
          .map((e) => FundComparison.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // ── Fund Performance ──────────────────────────────────────────────────────

  Future<List<MonthlyPerformance>> getMonthlyPerformance(
    int fundId, {
    int? months,
  }) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.monthlyPerformance(fundId),
        queryParameters: {if (months != null) 'months': months},
      );
      return (res.data ?? [])
          .map((e) => MonthlyPerformance.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<YearlyPerformance>> getYearlyPerformance(int fundId) async {
    try {
      final res = await _dio.get<List<dynamic>>(ApiEndpoints.yearlyPerformance(fundId));
      return (res.data ?? [])
          .map((e) => YearlyPerformance.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<PerformanceSummary> getPerformanceSummary(int fundId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiEndpoints.performanceSummary(fundId));
      return PerformanceSummary.fromJson(res.data!);
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<PerformanceSummary>> getAllPerformanceSummaries() async {
    try {
      final res = await _dio.get<List<dynamic>>(ApiEndpoints.allPerformanceSummaries);
      return (res.data ?? [])
          .map((e) => PerformanceSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<PortfolioHolding>> getPortfolioHoldings(
    int fundId, {
    String? date,
  }) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.portfolioHoldings(fundId),
        queryParameters: {if (date != null) 'date': date},
      );
      return (res.data ?? [])
          .map((e) => PortfolioHolding.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<AverageAllocation>> getAveragePortfolioAllocation({String? date}) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.averagePortfolioAllocation,
        queryParameters: {if (date != null) 'date': date},
      );
      return (res.data ?? [])
          .map((e) => AverageAllocation.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<FundComparison>> comparePerformance({
    List<int>? fundIds,
    int? year,
    int? month,
  }) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.comparePerformance,
        queryParameters: {
          if (fundIds != null) 'fund_ids': fundIds.join(','),
          if (year != null) 'year': year,
          if (month != null) 'month': month,
        },
      );
      return (res.data ?? [])
          .map((e) => FundComparison.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<FeeEfficiency>> getFeeEfficiency({
    int? year,
    int? month,
    int? limit,
  }) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.feeEfficiency,
        queryParameters: {
          if (year != null) 'year': year,
          if (month != null) 'month': month,
          if (limit != null) 'limit': limit,
        },
      );
      return (res.data ?? [])
          .map((e) => FeeEfficiency.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // ── Fund Managers ─────────────────────────────────────────────────────────

  Future<List<FundManager>> getManagers({bool? active}) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.managers,
        queryParameters: {if (active != null) 'active': active},
      );
      return (res.data ?? [])
          .map((e) => FundManager.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<FundManager> getManager(int id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiEndpoints.manager(id));
      return FundManager.fromJson(res.data!);
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<FundManager>> getTopManagers({int? limit, String? sortBy}) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.topManagers,
        queryParameters: {
          if (limit != null) 'limit': limit,
          if (sortBy != null) 'sort_by': sortBy,
        },
      );
      return (res.data ?? [])
          .map((e) => FundManager.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<FundManager>> searchManagers(String query) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.searchManagers,
        queryParameters: {'q': query},
      );
      return (res.data ?? [])
          .map((e) => FundManager.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<FundManager>> getManagersNear({
    required double lat,
    required double lon,
    double radiusKm = 50,
  }) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.managersNear,
        queryParameters: {'lat': lat, 'lon': lon, 'radius_km': radiusKm},
      );
      return (res.data ?? [])
          .map((e) => FundManager.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // ── Fund Rankings ─────────────────────────────────────────────────────────

  Future<List<FundRanking>> getRankingsByReturn({String? date, int? limit}) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.rankingsByReturn,
        queryParameters: {
          if (date != null) 'date': date,
          if (limit != null) 'limit': limit,
        },
      );
      return (res.data ?? [])
          .map((e) => FundRanking.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<FundRanking>> getRankingsBySize({String? date, int? limit}) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.rankingsBySize,
        queryParameters: {
          if (date != null) 'date': date,
          if (limit != null) 'limit': limit,
        },
      );
      return (res.data ?? [])
          .map((e) => FundRanking.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<FundRanking>> getLeaderboard({int? limit}) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.leaderboard,
        queryParameters: {if (limit != null) 'limit': limit},
      );
      return (res.data ?? [])
          .map((e) => FundRanking.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<FundRankingDetail> getFundRank(
    int fundId, {
    String? date,
    String? type,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.fundRank(fundId),
        queryParameters: {
          if (date != null) 'date': date,
          if (type != null) 'type': type,
        },
      );
      return FundRankingDetail.fromJson(res.data!);
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<FundRankingTrend>> getRankingTrends(
    int fundId, {
    String? type,
    int? months,
  }) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.rankingTrends(fundId),
        queryParameters: {
          if (type != null) 'type': type,
          if (months != null) 'months': months,
        },
      );
      return (res.data ?? [])
          .map((e) => FundRankingTrend.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<FundRanking>> getRankingsByCategory(
    String category, {
    String? date,
    String? type,
    int? limit,
  }) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.rankingsByCategory(category),
        queryParameters: {
          if (date != null) 'date': date,
          if (type != null) 'type': type,
          if (limit != null) 'limit': limit,
        },
      );
      return (res.data ?? [])
          .map((e) => FundRanking.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<FundMarketStats> getFundMarketStats({int? year, int? month}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.fundMarketStats,
        queryParameters: {
          if (year != null) 'year': year,
          if (month != null) 'month': month,
        },
      );
      return FundMarketStats.fromJson(res.data!);
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}
