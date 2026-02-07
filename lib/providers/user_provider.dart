import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api/users_service.dart';

class UserProvider with ChangeNotifier {
  UserProfile? _profile;
  bool _isLoading = false;
  String? _error;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProfile() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _profile = await usersService.getProfile();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(UpdateProfileData data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _profile = await usersService.updateProfile(data);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBoundary(Map<String, dynamic> boundary) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await usersService.updateBoundary(boundary);
      await fetchProfile(); // Refresh profile
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

