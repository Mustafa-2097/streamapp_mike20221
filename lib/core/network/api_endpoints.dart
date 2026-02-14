class ApiEndpoints {
  /// Base URL
  static const String baseUrl = 'https://mike20221.smtsigma.com/api/v1';

  /// Auth
  static const String register = '$baseUrl/auth/register';
  static const String verifySigUupOtp = '$baseUrl/auth/verify-otp';
  static const String resendOtp = '$baseUrl/auth/resend-otp';
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';

  /// Forgot Password
  static const String sendResetOtp = '$baseUrl/auth/send-otp/password-reset';
  static const String verifyResetOtp = '$baseUrl/auth/verify-otp/password-reset';
  /// Reset password (NEW)
  static const String resetPassword = '$baseUrl/auth/reset-password';


  /// Users Profile
  static const String userProfile = '$baseUrl/users/profile';
  static const String updateProfile = '$baseUrl/user/update-profile';

  /// Live
  static const String liveScores = '$baseUrl/sports/livescore/Soccer';
}

