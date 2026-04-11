import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:marketlens360mobile/services/auth_service.dart';

// Keep authStateProvider and authServiceProvider for router redirect logic
export 'package:marketlens360mobile/services/auth_service.dart'
    show authStateProvider, authServiceProvider;

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

class AuthNotifier extends ChangeNotifier {
  AuthNotifier(this._authService);

  final AuthService _authService;

  bool _isLoading = false;
  String? _error;
  bool _disposed = false;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> signInWithEmail(String email, String password) async {
    if (_isLoading) return false;
    _isLoading = true;
    _error = null;
    _notifyListeners();
    try {
      await _authService.signInWithEmail(email, password);
      if (_disposed) return true;
      _error = null;
      return true;
    } catch (e) {
      if (_disposed) return false;
      _error = _friendlyError(e.toString());
      return false;
    } finally {
      if (!_disposed) {
        _isLoading = false;
        _notifyListeners();
      }
    }
  }

  Future<bool> signInWithGoogle() async {
    if (_isLoading) return false;
    _isLoading = true;
    _error = null;
    _notifyListeners();
    try {
      await _authService.signInWithGoogle();
      if (_disposed) return true;
      _error = null;
      return true;
    } catch (e) {
      if (_disposed) return false;
      _error = _friendlyError(e.toString());
      return false;
    } finally {
      if (!_disposed) {
        _isLoading = false;
        _notifyListeners();
      }
    }
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    if (_isLoading) return false;
    _isLoading = true;
    _error = null;
    _notifyListeners();
    try {
      await _authService.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      if (_disposed) return true;
      _error = null;
      return true;
    } catch (e) {
      if (_disposed) return false;
      _error = _friendlyError(e.toString());
      return false;
    } finally {
      if (!_disposed) {
        _isLoading = false;
        _notifyListeners();
      }
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    if (_isLoading) return false;
    _isLoading = true;
    _error = null;
    _notifyListeners();
    try {
      await _authService.sendPasswordResetEmail(email);
      if (_disposed) return true;
      _error = null;
      return true;
    } catch (e) {
      if (_disposed) return false;
      _error = _friendlyError(e.toString());
      return false;
    } finally {
      if (!_disposed) {
        _isLoading = false;
        _notifyListeners();
      }
    }
  }

  void clearError() {
    if (_disposed) return;
    _error = null;
    _notifyListeners();
  }

  String _friendlyError(String raw) {
    if (raw.contains('wrong-password') || raw.contains('invalid-credential')) {
      return 'Incorrect email or password.';
    }
    if (raw.contains('user-not-found')) return 'No account found with that email.';
    if (raw.contains('email-already-in-use')) {
      return 'An account already exists for that email.';
    }
    if (raw.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later.';
    }
    if (raw.contains('network-request-failed')) {
      return 'Network error. Check your connection.';
    }
    return raw;
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
