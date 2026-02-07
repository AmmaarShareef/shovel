import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/api.dart';
import '../services/api/auth_service.dart';
import '../utils/storage.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null && _token != null;
  String? get error => _error;

  AuthProvider() {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      final token = await Storage.getToken();
      final userData = await Storage.getUserData();
      if (token != null && userData != null) {
        _token = token;
        _user = userData;
        notifyListeners();
      }
    } catch (e) {
      // Silent fail on startup
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await authService.login(LoginData(email: email, password: password));
      _user = response.user;
      _token = response.token;

      await Storage.setToken(response.token);
      await Storage.setUserData(response.user);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(RegisterData data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await authService.register(data);
      _user = response.user;
      _token = response.token;

      await Storage.setToken(response.token);
      await Storage.setUserData(response.user);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await authService.logout();
    } catch (e) {
      // Continue even if logout fails
    } finally {
      _user = null;
      _token = null;
      await Storage.removeToken();
      await Storage.removeUserData();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

