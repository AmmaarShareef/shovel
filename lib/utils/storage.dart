import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import 'constants.dart';

class Storage {
  static Future<void> setItem(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else {
      await prefs.setString(key, jsonEncode(value));
    }
  }

  static Future<T?> getItem<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    if (value == null) return null;
    
    if (T == String) {
      return value as T;
    }
    
    return jsonDecode(value) as T;
  }

  static Future<void> removeItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Auth specific methods
  static Future<String?> getToken() async {
    return getItem<String>(AppConstants.authTokenKey);
  }

  static Future<void> setToken(String token) async {
    await setItem(AppConstants.authTokenKey, token);
  }

  static Future<void> removeToken() async {
    await removeItem(AppConstants.authTokenKey);
  }

  static Future<User?> getUserData() async {
    final data = await getItem<Map<String, dynamic>>(AppConstants.userDataKey);
    if (data == null) return null;
    return User.fromJson(data);
  }

  static Future<void> setUserData(User user) async {
    await setItem(AppConstants.userDataKey, user.toJson());
  }

  static Future<void> removeUserData() async {
    await removeItem(AppConstants.userDataKey);
  }
}

