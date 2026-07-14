import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class ScamAuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  String _errorMessage = '';

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  ScamAuthProvider() {
    _authService.authStateChanges.listen((User? firebaseUser) {
      if (firebaseUser == null) {
        _user = null;
        notifyListeners();
      } else {
        _user = UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
          photoUrl: firebaseUser.photoURL ?? '',
          createdAt: DateTime.now(),
        );
        notifyListeners();
      }
    });
  }

  Future<bool> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      _user = await _authService.registerWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      _user = await _authService.loginWithEmail(
        email: email,
        password: password,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
  }
}