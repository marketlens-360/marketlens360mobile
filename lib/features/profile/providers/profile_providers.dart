import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:package_info_plus/package_info_plus.dart';

final profileProvider = ChangeNotifierProvider<ProfileNotifier>((ref) {
  final notifier = ProfileNotifier();
  Future.microtask(notifier.load);
  return notifier;
});

class ProfileNotifier extends ChangeNotifier {
  bool _isLoading = false;
  bool _disposed = false;

  PackageInfo? _packageInfo;
  bool _pushNotificationsEnabled = true;
  bool _biometricLoginEnabled = false;
  bool _delayedDataDisclaimer = true;

  bool get isLoading => _isLoading;
  PackageInfo? get packageInfo => _packageInfo;
  bool get pushNotificationsEnabled => _pushNotificationsEnabled;
  bool get biometricLoginEnabled => _biometricLoginEnabled;
  bool get delayedDataDisclaimer => _delayedDataDisclaimer;

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    _notifyListeners();
    try {
      _packageInfo = await PackageInfo.fromPlatform();
    } catch (_) {
      // Non-critical; package info is display-only
    } finally {
      if (!_disposed) {
        _isLoading = false;
        _notifyListeners();
      }
    }
  }

  void setPushNotifications(bool value) {
    if (_disposed) return;
    _pushNotificationsEnabled = value;
    _notifyListeners();
  }

  void setBiometricLogin(bool value) {
    if (_disposed) return;
    _biometricLoginEnabled = value;
    _notifyListeners();
  }

  void setDelayedDataDisclaimer(bool value) {
    if (_disposed) return;
    _delayedDataDisclaimer = value;
    _notifyListeners();
  }

  void _notifyListeners() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
