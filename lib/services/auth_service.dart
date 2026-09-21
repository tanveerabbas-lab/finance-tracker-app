import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// AuthService handles user signup and login.
/// Users are stored locally as a simple email->credentials map.
/// This file is the evidence source for both the "Signup Implementation"
/// and "Login Implementation" tasks (each linked separately in the
/// GitHub submission, since both live in one auth flow).
class AuthService {
  static const String _usersKey = 'users';
  static const String _sessionKey = 'currentUserEmail';

  static Future<Map<String, dynamic>> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null) return {};
    return Map<String, dynamic>.from(jsonDecode(raw));
  }

  static Future<void> _saveUsers(Map<String, dynamic> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  /// SIGN UP: creates a new account.
  /// Throws an Exception with a user-facing message on failure
  /// (used to produce the signup_error screenshot).
  static Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    if (username.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('All fields are required.');
    }
    if (!email.contains('@')) {
      throw Exception('Please enter a valid email address.');
    }
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters.');
    }

    final users = await _loadUsers();
    if (users.containsKey(email)) {
      // Triggering signup with an email that already exists produces
      // this exact error -> capture as signup_error.png/.jpg
      throw Exception('An account with this email already exists.');
    }

    users[email] = {'username': username, 'password': password};
    await _saveUsers(users);
  }

  /// LOGIN: validates credentials against stored users.
  /// Throws an Exception with a user-facing message on failure
  /// (used to produce the login_error screenshot).
  static Future<void> login({
    required String email,
    required String password,
  }) async {
    final users = await _loadUsers();

    if (!users.containsKey(email)) {
      // Triggering login with an unregistered email produces this error
      // -> capture as login_error.png/.jpg
      throw Exception('No account found for this email.');
    }

    if (users[email]['password'] != password) {
      throw Exception('Incorrect password. Please try again.');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, email);
  }

  static Future<String?> currentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
