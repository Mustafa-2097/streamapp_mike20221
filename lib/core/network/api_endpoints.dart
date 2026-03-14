class ApiEndpoints {
  /// Base URL
  static const String baseUrl = 'http://10.0.30.59:8000/api/v1';

  /// Auth
  static const String register = '$baseUrl/auth/register';
  static const String verifySigUupOtp = '$baseUrl/auth/verify-otp';
  static const String resendOtp = '$baseUrl/auth/resend-otp';
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';

  /// Forgot Password
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String verifyResetOtp = '$baseUrl/auth/verify-otp';

  /// Reset password (NEW)
  static const String resetPassword = '$baseUrl/auth/reset-password';

  /// Users Profile
  static const String userProfile = '$baseUrl/users/profile';
  static const String updateProfile = '$baseUrl/user/update-profile';
  static const String changePassword = '$baseUrl/users/change-password';

  /// Live
  static const String liveMatches = '$baseUrl/matches/live';
  static const String liveScores = '$baseUrl/sports/livescore/Soccer';
  static String upcomingMatches(String leagueId) =>
      '$baseUrl/sports/upcoming/$leagueId';

  /// Table
  static const String leagueTable = '$baseUrl/sports/league-table';

  /// News
  static const String news = '$baseUrl/news?category=sports';
}
