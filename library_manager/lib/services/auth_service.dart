import 'dart:async';

import '../models/user_model.dart';

/// Dummy in-memory auth service – no Firebase required.
///
/// Pre-seeded accounts:
///   admin@library.com  / admin123   → admin
///   staff@library.com  / staff123   → staff
///   patron@library.com / patron123  → patron
class AuthService {
  // In-memory user store: email → {password, UserModel}
  final Map<String, _UserRecord> _store = {
    'admin@library.com': _UserRecord(
      password: 'admin123',
      user: UserModel(
        uid: 'uid-admin-001',
        name: 'Alice Admin',
        email: 'admin@library.com',
        role: UserRole.admin,
        createdAt: DateTime(2024, 1, 1),
      ),
    ),
    'staff@library.com': _UserRecord(
      password: 'staff123',
      user: UserModel(
        uid: 'uid-staff-001',
        name: 'Steve Staff',
        email: 'staff@library.com',
        role: UserRole.staff,
        createdAt: DateTime(2024, 1, 1),
      ),
    ),
    'patron@library.com': _UserRecord(
      password: 'patron123',
      user: UserModel(
        uid: 'uid-patron-001',
        name: 'Pat Patron',
        email: 'patron@library.com',
        role: UserRole.patron,
        createdAt: DateTime(2024, 1, 1),
      ),
    ),
  };

  // Broadcast stream that emits whenever auth state changes.
  final _authStateController = _AuthStateController();

  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400)); // simulate network

    final key = email.trim().toLowerCase();
    if (_store.containsKey(key)) {
      throw AuthException('email-already-in-use');
    }
    if (password.length < 6) {
      throw AuthException('weak-password');
    }

    final uid = 'uid-${DateTime.now().millisecondsSinceEpoch}';
    final user = UserModel(
      uid: uid,
      name: name.trim(),
      email: key,
      role: UserRole.patron,
      createdAt: DateTime.now(),
    );
    _store[key] = _UserRecord(password: password, user: user);
    _authStateController.emit(user);
    return user;
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400)); // simulate network

    final key = email.trim().toLowerCase();
    final record = _store[key];
    if (record == null || record.password != password) {
      throw AuthException('invalid-credential');
    }
    _authStateController.emit(record.user);
    return record.user;
  }

  Future<void> logout() async {
    _authStateController.emit(null);
  }

  Future<UserModel> getUserData(String uid) async {
    final record = _store.values.where((r) => r.user.uid == uid).firstOrNull;
    if (record == null) throw Exception('User data not found.');
    return record.user;
  }
}

class AuthException implements Exception {
  final String code;
  const AuthException(this.code);
}

class _UserRecord {
  final String password;
  final UserModel user;
  const _UserRecord({required this.password, required this.user});
}

/// Minimal broadcast stream controller for auth state.
class _AuthStateController {
  final List<void Function(UserModel?)> _listeners = [];
  UserModel? _last;

  Stream<UserModel?> get stream async* {
    yield _last;
    await for (final value in _broadcastStream()) {
      yield value;
    }
  }

  Stream<UserModel?> _broadcastStream() {
    late StreamController<UserModel?> controller;
    controller = StreamController<UserModel?>.broadcast(onListen: () {
      _listeners.add(controller.add);
    }, onCancel: () {
      _listeners.remove(controller.add);
    });
    return controller.stream;
  }

  void emit(UserModel? user) {
    _last = user;
    for (final l in List.of(_listeners)) {
      l(user);
    }
  }
}

