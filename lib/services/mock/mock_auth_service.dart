import 'dart:async';
import '../../models/user.dart';
import '../../models/api.dart';
import 'mock_data.dart';

import '../../services/api/auth_service.dart';

class MockAuthService implements IAuthService {
  Future<void> _delay([int ms = 1000]) async {
    await Future.delayed(Duration(milliseconds: ms));
  }

  // All test accounts use password 'test123'
  static const String testPassword = 'test123';

  @override
  Future<AuthResponse> login(LoginData data) async {
    await _delay(1000);

    // Find user by email
    final user = MockData.mockUsers.values.firstWhere(
      (u) => u.email == data.email,
      orElse: () => throw Exception('Invalid email or password'),
    );

    // Check password (all test accounts use same password)
    if (data.password != testPassword) {
      throw Exception('Invalid email or password');
    }

    return AuthResponse(
      user: user,
      token: 'mock-token-${user.id}-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<AuthResponse> register(RegisterData data) async {
    await _delay(1000);

    // Check if email already exists
    try {
      MockData.mockUsers.values.firstWhere(
        (u) => u.email == data.email,
      );
      throw Exception('Email already registered');
    } catch (e) {
      if (e.toString().contains('No element')) {
        // Email doesn't exist, continue with registration
      } else {
        rethrow;
      }
    }

    final newUser = User(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      email: data.email,
      name: data.name,
      phone: data.phone,
      role: data.role,
      createdAt: DateTime.now(),
    );

    MockData.mockUsers[newUser.id] = newUser;

    return AuthResponse(
      user: newUser,
      token: 'mock-token-${newUser.id}-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<void> logout() async {
    await _delay(500);
  }

  @override
  Future<Map<String, dynamic>> refreshToken() async {
    await _delay(500);
    return {'token': 'mock-refreshed-token-${DateTime.now().millisecondsSinceEpoch}'};
  }
}

