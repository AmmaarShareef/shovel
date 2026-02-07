import '../../models/user.dart';
import '../../models/api.dart';
import '../../utils/config.dart';
import 'api_client.dart';
import '../mock/mock_auth_service.dart';

abstract class IAuthService {
  Future<AuthResponse> login(LoginData data);
  Future<AuthResponse> register(RegisterData data);
  Future<void> logout();
  Future<Map<String, dynamic>> refreshToken();
}

class RealAuthService implements IAuthService {
  @override
  Future<AuthResponse> login(LoginData data) async {
    final response = await ApiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: data.toJson(),
    );
    return AuthResponse.fromJson(response);
  }

  @override
  Future<AuthResponse> register(RegisterData data) async {
    final response = await ApiClient.post<Map<String, dynamic>>(
      '/auth/register',
      data: data.toJson(),
    );
    return AuthResponse.fromJson(response);
  }

  @override
  Future<void> logout() async {
    await ApiClient.post('/auth/logout');
  }

  @override
  Future<Map<String, dynamic>> refreshToken() async {
    final response = await ApiClient.post<Map<String, dynamic>>('/auth/refresh');
    return response;
  }
}

// Export the appropriate service based on config
final IAuthService authService = useMockServices
    ? MockAuthService()
    : RealAuthService();

