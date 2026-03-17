class ApiEndpoints {
  /// Base URL
  static const String baseUrl = 'http://10.0.30.59:8000/api/v1';

  /// Auth
  static const String register = '$baseUrl/auth/register';
  static const String verifySignUpOtp = '$baseUrl/auth/verify-otp';
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
  static const String updateProfile = '$baseUrl/users/profile';
  static const String changePassword = '$baseUrl/users/change-password';

  /// Live
  static const String liveMatches = '$baseUrl/matches/live';
  static const String liveScores = '$baseUrl/sports/livescore/Soccer';
  static String upcomingMatches(String leagueId) =>
      '$baseUrl/sports/upcoming/$leagueId';

  static const String upcomingMatchesAll = '$baseUrl/matches/upcoming';
  static const String recentMatches = '$baseUrl/matches/recent';
  static const String footballMatches = '$baseUrl/matches/football';
  static const String rugbyMatches = '$baseUrl/matches/rugby';

  /// Table
  static const String leagueTable = '$baseUrl/sports/league-table';

  /// Live TV
  static const String liveTv = '$baseUrl/contents/live-tv';

  /// News
  ///  static const String news = '$baseUrl/news?category=sports';
  static const String news = '$baseUrl/news';
  static String comments(String newsId) => '$news/$newsId/comments';
  static String engagement(String newsId) => '$news/$newsId/engagement';
  static String bookmark(String newsId) => '$news/$newsId/bookmark';
  static const String myBookmarks = '$news/my-bookmarks';
  static String deleteBookmark(String bookmarkId) => '$myBookmarks/$bookmarkId';
  static String commentAction(String commentId) =>
      '$news/comments/$commentId/action';
  static String newsCommentReplies(String commentId) =>
      '$news/comments/$commentId/replies';

  /// Clips
  static const String clips = '$baseUrl/clips';
  static String singleClip(String clipId) => '$clips/$clipId';
  static const String clipsAction = '$clips/action';
  static String shareClip(String clipId) => '$clips/share/$clipId';
  static const String clipBookmark = '$clips/bookmark';
  static const String myClipBookmarks = '$clips/my-bookmarks';
  static String deleteClipBookmark(String bookmarkId) => '$myClipBookmarks/$bookmarkId';

  /// Clips Comments
  static const String clipsComments = '$clips/comments';
  static const String clipsCommentsAction = '$clips/comments/action';
  static String singleClipComments(String clipId) => '$clips/comments/$clipId';
  static String commentReplies(String commentId) =>
      '$clips/comments/$commentId/replies';

  /// Replays
  static const String replays = '$baseUrl/replays';
  static String singleReplay(String id) => '$replays/$id';
  static const String replaysAction = '$replays/action';
  static const String replaysBookmark = '$replays/bookmark';
  static const String myReplayBookmarks = '$replays/my-bookmarks';
}
