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
      headers: {'Authorization': token},
    );
  }

  /// Update Profile Info
  /// ✅ Smart approach: uses JSON PATCH when no image, multipart only when image exists
  /// This solves backend parsing issues where some APIs expect JSON body for text-only updates
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
    final Map<String, dynamic> bodyFields = {};
    if (name != null && name.isNotEmpty) bodyFields['name'] = name;
    if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
      bodyFields['dateOfBirth'] = dateOfBirth;
    }
    if (country != null && country.isNotEmpty) bodyFields['country'] = country;

    // If there's an image, use multipart; otherwise use regular JSON PATCH
    if (imageFile != null) {
      // Convert map values to strings for multipart
      final stringFields = bodyFields.map((k, v) => MapEntry(k, v.toString()));

      return await ApiService.patchMultipart(
        ApiEndpoints.updateProfile,
        headers: {'Authorization': token},
        fields: stringFields,
        imageFile: imageFile,
        imageFieldName: 'image',
      );
    } else {
      // No image — use simple JSON PATCH (more reliable for most backends)
      return await ApiService.patch(
        ApiEndpoints.updateProfile,
        headers: {
          'Authorization': token,
        },
        body: bodyFields,
      );
    }
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