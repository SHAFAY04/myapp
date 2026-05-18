import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../core/enums/auth_state_enum.dart';
import '../models/user_model.dart';

/// Controller layer: owns all auth business logic, exposes state via
/// [ChangeNotifier] so the UI can react without knowing implementation details.
class AuthController extends ChangeNotifier {
  AuthState _authState = AuthState.initial;
  UserModel? _currentUser;
  String? _errorMessage;

  // ─── Getters ──────────────────────────────────────────────────────────────
  AuthState get authState => _authState;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _authState.isLoading;

  // ─── Init: restore session ────────────────────────────────────────────────
  Future<bool> tryRestoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(AppConstants.kRememberMeKey) ?? false;
    final isLoggedIn = prefs.getBool(AppConstants.kIsLoggedInKey) ?? false;

    if (rememberMe && isLoggedIn) {
      final email = prefs.getString(AppConstants.kUserEmailKey);
      if (email != null) {
        final user = await _findUserByEmail(email);
        if (user != null) {
          _currentUser = user;
          _authState = AuthState.authenticated;
          notifyListeners();
          return true;
        }
      }
    }
    return false;
  }

  // ─── Registration ─────────────────────────────────────────────────────────
  Future<bool> register(UserModel user) async {
    _setLoading();
    await Future.delayed(const Duration(milliseconds: 800)); // simulate network

    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if email already exists
      final existingUser = await _findUserByEmail(user.email);
      if (existingUser != null) {
        _setError('An account with this email already exists.');
        return false;
      }

      // Persist the new user
      final usersJson = prefs.getStringList(AppConstants.kRegisteredUsersKey) ?? [];
      usersJson.add(user.toJson());
      await prefs.setStringList(AppConstants.kRegisteredUsersKey, usersJson);

      _authState = AuthState.registrationSuccess;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Registration failed. Please try again.');
      return false;
    }
  }

  // ─── Login ────────────────────────────────────────────────────────────────
  Future<bool> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    _setLoading();
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final user = await _findUserByEmail(email.trim());
      if (user == null || user.password != password) {
        _setError('Invalid email or password. Please try again.');
        return false;
      }

      _currentUser = user;
      _authState = AuthState.authenticated;
      _errorMessage = null;

      // Persist session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.kIsLoggedInKey, true);
      await prefs.setBool(AppConstants.kRememberMeKey, rememberMe);
      await prefs.setString(AppConstants.kUserEmailKey, user.email);

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Login failed. Please try again.');
      return false;
    }
  }

  // ─── Logout ───────────────────────────────────────────────────────────────
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.kIsLoggedInKey, false);
    // Keep rememberMe value but clear the session flag
    _currentUser = null;
    _authState = AuthState.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  Future<UserModel?> _findUserByEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(AppConstants.kRegisteredUsersKey) ?? [];
    for (final json in usersJson) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      if ((map['email'] as String).toLowerCase() == email.toLowerCase()) {
        return UserModel.fromMap(map);
      }
    }
    return null;
  }

  void _setLoading() {
    _authState = AuthState.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _authState = AuthState.error;
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    if (_authState == AuthState.error) {
      _authState = AuthState.unauthenticated;
      _errorMessage = null;
      notifyListeners();
    }
  }
}
