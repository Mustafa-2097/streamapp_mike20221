import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_service.dart';
import '../../../core/offline_storage/shared_pref.dart';

class CustomerApiService {
  /// ================= PROFILE =================

  static Future<Map<String, dynamic>> getProfile() async {
    final String? token = await SharedPreferencesHelper.getToken();
    debugPrint("Token being sent: $token");

    if (token == null || token.isEmpty) {
      throw Exception("User token not found");
    }

    return await ApiService.get(
      ApiEndpoints.userProfile,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  /// Update Profile Info
  /// ✅ Smart approach: uses JSON PATCH when no image, multipart only when image exists
  /// This solves backend parsing issues where some APIs expect JSON body for text-only updates
  /// [name], [dateOfBirth], [country] are optional text fields.
  /// [imageFile] is optional — only sent when the user picks a new photo.
  static Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? dateOfBirth, // expected format: "DD/MM/YYYY"
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
        headers: {'Authorization': 'Bearer $token'},
        fields: stringFields,
        imageFile: imageFile,
        imageFieldName: 'profilePhoto',
      );
    } else {
      // No image — use simple JSON PATCH (more reliable for most backends)
      return await ApiService.patch(
        ApiEndpoints.updateProfile,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: bodyFields,
      );
    }
  }

  /// Change Password
  static Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    debugPrint("Token being sent for change password: $token");

    if (token == null || token.isEmpty) {
      throw Exception("User token not found");
    }

    return await ApiService.post(
      ApiEndpoints.changePassword,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
  }

  /// ================= LIVE SCORES =================
  static Future<Map<String, dynamic>> getLiveScores({required int page}) async {
    return await ApiService.get("${ApiEndpoints.liveScores}?page=$page");
  }

  /// New Live Matches API
  static Future<Map<String, dynamic>> getLiveMatches({
    required int page,
  }) async {
    return await ApiService.get("${ApiEndpoints.liveMatches}?page=$page");
  }

  /// Upcoming Matches
  static Future<Map<String, dynamic>> getUpcomingMatches({
    required String leagueId,
  }) async {
    return await ApiService.get(ApiEndpoints.upcomingMatches(leagueId));
  }

  /// New Upcoming Matches API (All)
  static Future<Map<String, dynamic>> getUpcomingMatchesAll({
    required int page,
  }) async {
    return await ApiService.get(
      "${ApiEndpoints.upcomingMatchesAll}?page=$page",
    );
  }

  /// Recent Matches API
  static Future<Map<String, dynamic>> getRecentMatches({
    required int page,
  }) async {
    return await ApiService.get("${ApiEndpoints.recentMatches}?page=$page");
  }

  /// Football Matches API
  static Future<Map<String, dynamic>> getFootballMatches({
    required int page,
  }) async {
    return await ApiService.get("${ApiEndpoints.footballMatches}?page=$page");
  }

  /// Rugby Matches API
  static Future<Map<String, dynamic>> getRugbyMatches({
    required int page,
  }) async {
    return await ApiService.get("${ApiEndpoints.rugbyMatches}?page=$page");
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

  /// ================= CLIPS =================
  static Future<Map<String, dynamic>> getClips({required int page}) async {
    final String? token = await SharedPreferencesHelper.getToken();
    return await ApiService.get(
      "${ApiEndpoints.clips}?page=$page",
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<Map<String, dynamic>> getClipById(String clipId) async {
    final String? token = await SharedPreferencesHelper.getToken();
    return await ApiService.get(
      ApiEndpoints.singleClip(clipId),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<Map<String, dynamic>> performClipAction({
    required String clipId,
    required String type, // "LIKE", "DISLIKE", "SHARE"
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    if (token == null || token.isEmpty) throw Exception("User token not found");

    return await ApiService.post(
      ApiEndpoints.clipsAction,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'clipId': clipId,
        'type': type,
      },
    );
  }

  /// ================= CLIPS COMMENTS =================

  static Future<Map<String, dynamic>> postComment({
    required String clipId,
    required String content,
    String? parentId,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    if (token == null || token.isEmpty) throw Exception("User token not found");

    return await ApiService.post(
      ApiEndpoints.clipsComments,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'clipId': clipId,
        'content': content,
        if (parentId != null) 'parentId': parentId,
      },
    );
  }

  static Future<Map<String, dynamic>> postCommentAction({
    required String commentId,
    required String type, // "LIKE", "DISLIKE"
    String? parentId,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    if (token == null || token.isEmpty) throw Exception("User token not found");

    return await ApiService.post(
      ApiEndpoints.clipsCommentsAction,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'commentId': commentId,
        'type': type,
        if (parentId != null) 'parentId': parentId,
      },
    );
  }

  static Future<Map<String, dynamic>> getClipComments(String clipId) async {
    final String? token = await SharedPreferencesHelper.getToken();
    return await ApiService.get(
      ApiEndpoints.singleClipComments(clipId),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<Map<String, dynamic>> getCommentReplies(String commentId) async {
    final String? token = await SharedPreferencesHelper.getToken();
    return await ApiService.get(
      ApiEndpoints.commentReplies(commentId),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
  }
}
