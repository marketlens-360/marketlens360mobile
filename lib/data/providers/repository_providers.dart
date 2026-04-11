import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketlens360mobile/core/network/network_providers.dart';
import 'package:marketlens360mobile/data/repositories/fund_repository.dart';
import 'package:marketlens360mobile/data/repositories/security_repository.dart';

export 'package:marketlens360mobile/data/local/app_database.dart'
    show appDatabaseProvider;

final securityRepositoryProvider = Provider<SecurityRepository>(
  (ref) => SecurityRepository(ref.watch(dioProvider)),
);

final fundRepositoryProvider = Provider<FundRepository>(
  (ref) => FundRepository(ref.watch(dioProvider)),
);
