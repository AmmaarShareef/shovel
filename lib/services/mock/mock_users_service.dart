import 'dart:async';
import '../../models/user.dart';
import '../../models/api.dart';
import 'mock_data.dart';

import '../../services/api/users_service.dart';

class MockUsersService implements IUsersService {
  Future<void> _delay([int ms = 1000]) async {
    await Future.delayed(Duration(milliseconds: ms));
  }

  @override
  Future<UserProfile> getProfile() async {
    await _delay(600);
    final user = MockData.mockUsers['customer1']!;
    return UserProfile(
      id: user.id,
      email: user.email,
      name: user.name,
      phone: user.phone,
      role: user.role,
      rating: 4.5,
      totalJobs: 12,
      createdAt: user.createdAt,
    );
  }

  @override
  Future<UserProfile> updateProfile(UpdateProfileData data) async {
    await _delay(800);
    final user = MockData.mockUsers['customer1']!;
    return UserProfile(
      id: user.id,
      email: user.email,
      name: data.name ?? user.name,
      phone: data.phone ?? user.phone,
      role: user.role,
      rating: 4.5,
      totalJobs: 12,
      createdAt: user.createdAt,
    );
  }

  @override
  Future<void> updateBoundary(Map<String, dynamic> boundary) async {
    await _delay(1000);
    print('Boundary updated: $boundary');
  }

  @override
  Future<List<ShovelerInfoResponse>> getNearbyShovelers(
    double lat,
    double lng, {
    double? radius,
  }) async {
    await _delay(800);
    return MockData.getMockShovelers();
  }
}

