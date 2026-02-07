class ApiEndpoints {
  /// Base URL
  static const String baseUrl = 'https://mike20221.smtsigma.com/api/v1';

  /// Auth
  static const String register = '$baseUrl/auth/register';
  static const String verifySigUupOtp = '$baseUrl/auth/verify-otp';
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';


  /// Forgot Password
  static const String sendResetOtp = '$baseUrl/auth/send-otp/password-reset';
  static const String verifyResetOtp = '$baseUrl/auth/verify-otp/password-reset';
  /// Reset password (NEW)
  static const String resetPassword = '$baseUrl/auth/reset-password';


  /// User / Profile
  static const String profile = '$baseUrl/me/profile';
  static const String updateProfile = '$baseUrl/me/profile';
  static const String updateAvatar = '$baseUrl/me/avatar';
  static const String certificate = '$baseUrl/me/certificate';
  //
  static const String contact = '$baseUrl/me/contact';
  static const String educateEmployee = '$baseUrl/me/educate-employee';


  /// Courses
  static const String courses = '$baseUrl/courses';
  static const String nextVideo = '$baseUrl/courses/:id/next-video';

  // Lesson's Review
  static const String review = '$baseUrl/lessons/:id/review';

  // Exam questions
  static const String questions = '$baseUrl/lessons/:id/questions';

}

