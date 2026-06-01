import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../models/app_user.dart';

class AuthService {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_data';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final data = await ApiService.login(email: email, password: password);
    await _saveUserData(data);
    return data;
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final data = await ApiService.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: password,
    );
    return data;
  }

  Future<void> logout() async {
    try {
      await ApiService.logout();
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  Future<void> _saveUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    if (data['token'] != null) {
      await prefs.setString(_tokenKey, data['token']);
    }
    if (data['user'] != null) {
      await prefs.setString(_userKey, jsonEncode(data['user']));
    }
  }

  Future<AppUser?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData == null) return null;
    try {
      return AppUser.fromJson(jsonDecode(userData));
    } catch (_) {
      return null;
    }
  }

  Future<AppUser> getUser() async {
    final user = await ApiService.getUser();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    return user;
  }

  Future<AppUser> updateProfile({String? name, String? phoneNumber}) async {
    final user = await ApiService.updateProfile(name: name, phoneNumber: phoneNumber);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    return user;
  }
}
