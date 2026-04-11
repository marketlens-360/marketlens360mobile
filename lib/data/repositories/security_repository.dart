import 'package:dio/dio.dart';
import 'package:marketlens360mobile/core/network/api_endpoints.dart';
import 'package:marketlens360mobile/core/network/app_exception.dart';
import 'package:marketlens360mobile/data/models/dividend.dart';
import 'package:marketlens360mobile/data/models/earnings.dart';
import 'package:marketlens360mobile/data/models/market_index.dart';
import 'package:marketlens360mobile/data/models/market_overview.dart';
import 'package:marketlens360mobile/data/models/price_history.dart';
import 'package:marketlens360mobile/data/models/security.dart';
import 'package:marketlens360mobile/data/models/security_metrics.dart';

class SecurityRepository {
  const SecurityRepository(this._dio);

  final Dio _dio;

  Future<List<Security>> getSecurities() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiEndpoints.securities);
      final data = (res.data?['data'] as List<dynamic>?) ?? [];
      return data
          .map((e) => Security.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<Security> getSecurity(String symbol) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiEndpoints.security(symbol));
      return Security.fromJson(res.data!);
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<SecuritySummary> getSecuritySummary(String symbol) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiEndpoints.securitySummary(symbol));
      return SecuritySummary.fromJson(res.data!);
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<PriceHistory>> getPriceHistory(
    String symbol, {
    String? period,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.priceHistory(symbol),
        queryParameters: {
          if (period != null) 'period': period,
          if (startDate != null) 'start_date': startDate,
          if (endDate != null) 'end_date': endDate,
        },
      );
      return (res.data ?? [])
          .map((e) => PriceHistory.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<PriceHistory> getLatestPrice(String symbol) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiEndpoints.latestPrice(symbol));
      return PriceHistory.fromJson(res.data!);
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<Earnings>> getEarnings(String symbol) async {
    try {
      final res = await _dio.get<List<dynamic>>(ApiEndpoints.earnings(symbol));
      return (res.data ?? [])
          .map((e) => Earnings.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<Dividend>> getDividends(String symbol) async {
    try {
      final res = await _dio.get<List<dynamic>>(ApiEndpoints.dividends(symbol));
      return (res.data ?? [])
          .map((e) => Dividend.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<SecurityMetrics> getMetrics(String symbol) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiEndpoints.metrics(symbol));
      return SecurityMetrics.fromJson(res.data!);
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<SecurityMetrics>> getMetricsHistory(String symbol) async {
    try {
      final res = await _dio.get<List<dynamic>>(ApiEndpoints.metricsHistory(symbol));
      return (res.data ?? [])
          .map((e) => SecurityMetrics.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<MarketIndex>> getIndices() async {
    try {
      final res = await _dio.get<List<dynamic>>(ApiEndpoints.indices);
      return (res.data ?? [])
          .map((e) => MarketIndex.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<MarketIndex>> getIndexHistory(
    String code, {
    String? period,
  }) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        ApiEndpoints.indexHistory(code),
        queryParameters: {
          if (period != null) 'period': period,
        },
      );
      return (res.data ?? [])
          .map((e) => MarketIndex.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<MarketOverview> getMarketOverview() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiEndpoints.marketOverview);
      return MarketOverview.fromJson(res.data!);
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<Security>> getTopGainers({int limit = 5}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.topGainers,
        queryParameters: {'limit': limit},
      );
      final data = (res.data?['data'] as List<dynamic>?) ?? [];
      return data
          .map((e) => Security.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<Security>> getTopLosers({int limit = 5}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.topLosers,
        queryParameters: {'limit': limit},
      );
      final data = (res.data?['data'] as List<dynamic>?) ?? [];
      return data
          .map((e) => Security.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : UnknownException(e.message ?? 'Unknown error');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}
