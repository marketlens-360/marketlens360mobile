import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService {
  ConnectivityService()
      : _connectivity = Connectivity(),
        _checker = InternetConnection();

  final Connectivity _connectivity;
  final InternetConnection _checker;

  Future<bool> isConnected() async {
    return _checker.hasInternetAccess;
  }

  Stream<bool> get connectivityStream async* {
    await for (final _ in _connectivity.onConnectivityChanged) {
      yield await _checker.hasInternetAccess;
    }
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityService(),
);

final isConnectedProvider = StreamProvider<bool>(
  (ref) => ref.watch(connectivityServiceProvider).connectivityStream,
);
