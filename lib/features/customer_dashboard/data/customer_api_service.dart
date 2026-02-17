import 'dart:io';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_service.dart';
import '../../../core/offline_storage/shared_pref.dart';

class CustomerApiService {
  /// ================= PROFILE =================

  static Future<Map<String, dynamic>> getProfile() async {
    final String? token = await SharedPreferencesHelper.getToken();
    if (token == null || token.isEmpty) throw Exception("User token not found");

    return await ApiService.get(
      ApiEndpoints.userProfile,
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );
  }

  /// Update Profile Info
  /// Sends a PATCH multipart request to /users/profile.
  /// [name], [dateOfBirth], [country] are optional text fields.
  /// [imageFile] is optional — only sent when the user picks a new photo.
  static Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? dateOfBirth, // expected format: "YYYY-MM-DD"
    String? country,
    File? imageFile,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    if (token == null || token.isEmpty) throw Exception("User token not found");

    // Build only the fields that were provided
    final Map<String, String> fields = {};
    if (name != null && name.isNotEmpty) fields['name'] = name;
    if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
      fields['dateOfBirth'] = dateOfBirth;
    }
    if (country != null && country.isNotEmpty) fields['country'] = country;

    return await ApiService.patchMultipart(
      ApiEndpoints.updateProfile,
      headers: {'Authorization': token},
      fields: fields,
      imageFile: imageFile,
      imageFieldName: 'profileImage',
    );
  }

  /// Change Password
  static Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    if (token == null || token.isEmpty) throw Exception("User token not found");

    return await ApiService.post(
      ApiEndpoints.changePassword,
      headers: {'Content-Type': 'application/json', 'Authorization': token},
      body: {'oldPassword': oldPassword, 'newPassword': newPassword},
    );
  }

  /// ================= LIVE SCORES =================
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

  /// ================= LIVE TV =================
  static Future<Map<String, dynamic>> getLiveTvChannels() async {
    return await ApiService.get(ApiEndpoints.liveTv);
  }
}