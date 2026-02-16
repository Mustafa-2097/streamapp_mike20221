import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_service.dart';
import '../../../core/offline_storage/shared_pref.dart';

class CustomerApiService {
  /// ================= PROFILE =================
  static Future<Map<String, dynamic>> getProfile() async {
    final String? token = await SharedPreferencesHelper.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("User token not found");
    }

    return await ApiService.get(
      ApiEndpoints.userProfile,
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );
  }

  static Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("User token not found");
    }

    return await ApiService.post(
      ApiEndpoints.changePassword,
      headers: {'Content-Type': 'application/json', 'Authorization': token},
      body: {'oldPassword': oldPassword, 'newPassword': newPassword},
    );
  }

  /// ================= LIVE SCORES (PAGINATION READY) =================
  static Future<Map<String, dynamic>> getLiveScores({required int page}) async {
    return await ApiService.get("${ApiEndpoints.liveScores}?page=$page");
  }

  /// Upcoming Matches
  static Future<Map<String, dynamic>> getUpcomingMatches({
    required String leagueId,
  }) async {
    return await ApiService.get(ApiEndpoints.upcomingMatches(leagueId));
  }

  /// ================= LEAGUE TABLE =================
  static Future<Map<String, dynamic>> getLeagueTable({
    required String leagueId,
    required String season,
  }) async {
    return await ApiService.get(
      "${ApiEndpoints.leagueTable}?leagueId=$leagueId&season=$season",
    );
  }
}
