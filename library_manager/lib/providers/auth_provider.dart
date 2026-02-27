import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _service;

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;

  AuthProvider(this._service) {
    _listenToAuthChanges();
  }

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading =>
      _status == AuthStatus.loading || _status == AuthStatus.initial;

  void _listenToAuthChanges() {
    _service.authStateChanges.listen((UserModel? userModel) {
      if (userModel == null) {
        _user = null;
        _status = AuthStatus.unauthenticated;
      } else {
        _user = userModel;
        _status = AuthStatus.authenticated;
      }
      notifyListeners();
    });
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      _user = await _service.signUp(
        name: name,
        email: email,
        password: password,
      );
      _status = AuthStatus.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _setError(_mapError(e.code));
      return false;
    } catch (_) {
      _setError('An unexpected error occurred. Please try again.');
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      _user = await _service.login(email: email, password: password);
      _status = AuthStatus.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _setError(_mapError(e.code));
      return false;
    } catch (_) {
      _setError('An unexpected error occurred. Please try again.');
      return false;
    }
  }

  Future<void> logout() async {
    await _service.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  String _mapError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'Invalid email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}

