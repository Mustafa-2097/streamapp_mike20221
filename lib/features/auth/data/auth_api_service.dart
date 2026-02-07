import '../../../core/network/api_service.dart';
import '../../../core/network/api_endpoints.dart';

class AuthApiService {
  /// LOGIN API
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await ApiService.post(
      ApiEndpoints.login,
      body: {
        "email": email,
        "password": password,
      },
    );
  }

  /// SIGNUP API
  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return await ApiService.post(
      ApiEndpoints.register,
      body: {
        "name": name,
        "email": email,
        "password": password,
      },
    );
  }
}
