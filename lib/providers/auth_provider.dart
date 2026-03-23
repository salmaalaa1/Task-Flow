import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  static const _boxName = 'users';
  static const _sessionKey = 'session_user_id';

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // --- Hash password ---
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // --- Email validation ---
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w\.\-\+]+@[\w\-]+\.\w{2,}$');
    if (!regex.hasMatch(email.trim())) return 'Enter a valid email';
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) return 'Full name is required';
    if (name.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  static String? validateConfirmPassword(String? password, String? confirm) {
    if (confirm == null || confirm.isEmpty) return 'Please confirm your password';
    if (password != confirm) return 'Passwords do not match';
    return null;
  }

  // --- Check for existing session on app startup ---
  Future<bool> tryAutoLogin() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_sessionKey);
      if (userId == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final box = Hive.box<UserModel>(_boxName);
      final user = box.values.where((u) => u.id == userId).firstOrNull;
      if (user == null) {
        await prefs.remove(_sessionKey);
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // --- Sign Up ---
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final box = Hive.box<UserModel>(_boxName);

      // Check for duplicate email
      final existing = box.values.where(
          (u) => u.email.toLowerCase() == email.trim().toLowerCase());
      if (existing.isNotEmpty) {
        _error = 'An account with this email already exists';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name.trim(),
        email: email.trim().toLowerCase(),
        hashedPassword: _hashPassword(password),
      );

      await box.add(user);

      // Save session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionKey, user.id);

      _currentUser = user;
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // --- Sign In ---
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final box = Hive.box<UserModel>(_boxName);
      final user = box.values.where(
          (u) => u.email.toLowerCase() == email.trim().toLowerCase()).firstOrNull;

      if (user == null) {
        _error = 'No account found with this email';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (user.hashedPassword != _hashPassword(password)) {
        _error = 'Incorrect password';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Save session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionKey, user.id);

      _currentUser = user;
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // --- Sign Out ---
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    _currentUser = null;
    _error = null;
    notifyListeners();
  }

  // --- Update Profile ---
  Future<bool> updateProfile({required String name, required String email}) async {
    if (_currentUser == null) return false;
    try {
      final box = Hive.box<UserModel>(_boxName);
      // Check for email conflict
      final existing = box.values.where(
          (u) => u.email.toLowerCase() == email.trim().toLowerCase() && u.id != _currentUser!.id);
      if (existing.isNotEmpty) {
        _error = 'This email is already taken';
        notifyListeners();
        return false;
      }

      _currentUser!.name = name.trim();
      _currentUser!.email = email.trim().toLowerCase();
      await _currentUser!.save();
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update profile';
      notifyListeners();
      return false;
    }
  }

  // --- Reset Password (local) ---
  Future<bool> resetPassword({required String email, required String newPassword}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final box = Hive.box<UserModel>(_boxName);
      final user = box.values.where(
          (u) => u.email.toLowerCase() == email.trim().toLowerCase()).firstOrNull;

      if (user == null) {
        _error = 'No account found with this email';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      user.hashedPassword = _hashPassword(newPassword);
      await user.save();

      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Something went wrong';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
