import '../../models/user.dart';
import '../../models/api.dart';
import '../../utils/config.dart';
import 'api_client.dart';
import '../mock/mock_users_service.dart';

abstract class IUsersService {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(UpdateProfileData data);
  Future<void> updateBoundary(Map<String, dynamic> boundary);
  Future<List<ShovelerInfoResponse>> getNearbyShovelers(
    double lat,
    double lng, {
    double? radius,
  });
}

class RealUsersService implements IUsersService {
  @override
  Future<UserProfile> getProfile() async {
    final response = await ApiClient.get<Map<String, dynamic>>('/users/profile');
    return UserProfile.fromJson(response);
  }

  @override
  Future<UserProfile> updateProfile(UpdateProfileData data) async {
    final response = await ApiClient.put<Map<String, dynamic>>(
      '/users/profile',
      data: data.toJson(),
    );
    return UserProfile.fromJson(response);
  }

  @override
  Future<void> updateBoundary(Map<String, dynamic> boundary) async {
    await ApiClient.put('/users/boundary', data: {'boundary': boundary});
  }

  @override
  Future<List<ShovelerInfoResponse>> getNearbyShovelers(
    double lat,
    double lng, {
    double? radius,
  }) async {
    final params = {'lat': lat, 'lng': lng};
    if (radius != null) params['radius'] = radius;
    
    final response = await ApiClient.get<List<dynamic>>(
      '/users/nearby-shovelers',
      queryParameters: params,
    );
    return response
        .map((json) => ShovelerInfoResponse.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

final IUsersService usersService = useMockServices
    ? MockUsersService()
    : RealUsersService();

