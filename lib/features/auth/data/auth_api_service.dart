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
      body: {"email": email, "password": password},
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
      body: {"name": name, "email": email, "password": password},
    );
  }

  /// VERIFY OTP API
  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
    required bool isSignUp,
  }) async {
    return await ApiService.post(
      isSignUp ? ApiEndpoints.verifySignUpOtp : ApiEndpoints.verifyResetOtp,
      body: {"email": email, "otp": otp},
    );
  }

  /// FORGOT PASSWORD API
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    return await ApiService.post(
      ApiEndpoints.forgotPassword,
      body: {"email": email},
    );
  }

  /// RESET PASSWORD API
  static Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    return await ApiService.post(
      ApiEndpoints.resetPassword,
      body: {
        "token": token,
        "newPassword": newPassword,
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
      body: {"email": email, "isSignUp": isSignUp},
    );
  }
}
