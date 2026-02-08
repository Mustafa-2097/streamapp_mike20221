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

  /// VERIFY OTP API
  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
    required bool isSignUp,
  }) async {
    return await ApiService.post(
      ApiEndpoints.verifySigUupOtp,
      body: {
        "email": email,
        "otp": otp,
      },
    );
  }
  /// RESEND OTP API
  static Future<Map<String, dynamic>> resendOtp({
    required String email,
    required bool isSignUp,
  }) async {
    return await ApiService.post(
      ApiEndpoints.resendOtp,
      body: {
        "email": email,
        "isSignUp": isSignUp,
      },
    );
  }
}
