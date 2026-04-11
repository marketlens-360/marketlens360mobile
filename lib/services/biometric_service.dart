import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  BiometricService() : _auth = LocalAuthentication();

  final LocalAuthentication _auth;

  Future<bool> isAvailable() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isDeviceSupported = await _auth.isDeviceSupported();
    return canCheck && isDeviceSupported;
  }

  Future<bool> authenticate() async {
    return _auth.authenticate(
      localizedReason: 'Authenticate to access MarketLens360',
      options: const AuthenticationOptions(
        biometricOnly: false,
        stickyAuth: true,
      ),
    );
  }

  Future<List<BiometricType>> availableBiometrics() async {
    return _auth.getAvailableBiometrics();
  }
}

final biometricServiceProvider = Provider<BiometricService>(
  (ref) => BiometricService(),
);
