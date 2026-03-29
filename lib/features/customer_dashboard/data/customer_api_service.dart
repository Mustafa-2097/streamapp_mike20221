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
        headers: {'Authorization': 'Bearer $token'},
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
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get("${ApiEndpoints.liveScores}?page=$page", headers: headers);
  }

  /// New Live Matches API
  static Future<Map<String, dynamic>> getLiveMatches({
    required int page,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get("${ApiEndpoints.liveMatches}?page=$page", headers: headers);
  }

  /// Upcoming Matches
  static Future<Map<String, dynamic>> getUpcomingMatches({
    required String leagueId,
  }) async {
    return await ApiService.get(ApiEndpoints.upcomingMatches(leagueId));
  }

  /// Match Info
  static Future<Map<String, dynamic>> getMatchInfo({
    required String matchId,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(ApiEndpoints.matchInfo(matchId), headers: headers);
  }

  /// Match Summary
  static Future<Map<String, dynamic>> getMatchSummary({
    required String matchId,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(ApiEndpoints.matchSummary(matchId), headers: headers);
  }

  /// Match Header
  static Future<Map<String, dynamic>> getMatchHeader({
    required String matchId,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(ApiEndpoints.matchHeader(matchId), headers: headers);
  }

  /// Match Stats
  static Future<Map<String, dynamic>> getMatchStats({
    required String matchId,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(ApiEndpoints.matchStats(matchId), headers: headers);
  }

  /// Match Lineup
  static Future<Map<String, dynamic>> getMatchLineup({
    required String matchId,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(ApiEndpoints.matchLineup(matchId), headers: headers);
  }

  /// Match Table
  static Future<Map<String, dynamic>> getMatchTable({
    required String matchId,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(ApiEndpoints.matchTable(matchId), headers: headers);
  }

  /// Match H2H
  static Future<Map<String, dynamic>> getMatchH2H({
    required String matchId,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(ApiEndpoints.matchH2H(matchId), headers: headers);
  }

  /// Subscription Plans
  static Future<Map<String, dynamic>> getPlans() async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(ApiEndpoints.plans, headers: headers);
  }

  static Future<Map<String, dynamic>> createCheckoutSession({
    required String planId,
    required String userId,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    final body = {
      'planId': planId,
      'userId': userId,
    };
    return await ApiService.post(
      ApiEndpoints.createCheckoutSession,
      headers: headers,
      body: body,
    );
  }

  static Future<Map<String, dynamic>> getPaymentHistory({
    required String userId,
    String? planId,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    final queryParams = {
      'userId': userId,
      if (planId != null) 'planId': planId,
    };
    return await ApiService.get(
      ApiEndpoints.paymentHistory,
      headers: headers,
      queryParameters: queryParams,
    );
  }

  /// New Upcoming Matches API (All)
  static Future<Map<String, dynamic>> getUpcomingMatchesAll({
    required int page,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(
      "${ApiEndpoints.upcomingMatchesAll}?page=$page",
      headers: headers,
    );
  }

  /// Recent Matches API
  static Future<Map<String, dynamic>> getRecentMatches({
    required int page,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get("${ApiEndpoints.recentMatches}?page=$page", headers: headers);
  }

  /// Football Matches API
  static Future<Map<String, dynamic>> getFootballMatches({
    required int page,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get("${ApiEndpoints.footballMatches}?page=$page", headers: headers);
  }

  /// Rugby Matches API
  static Future<Map<String, dynamic>> getRugbyMatches({
    required int page,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get("${ApiEndpoints.rugbyMatches}?page=$page", headers: headers);
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
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(ApiEndpoints.liveTv, headers: headers);
  }

  static Future<Map<String, dynamic>> getLiveTvById(String id) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(ApiEndpoints.singleLiveTv(id), headers: headers);
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

  /// ================= REPLAYS COMMENTS =================

  static Future<Map<String, dynamic>> postReplayComment({
    required String replayId,
    required String content,
    String? parentId,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    if (token == null || token.isEmpty) throw Exception("User token not found");

    return await ApiService.post(
      ApiEndpoints.replaysComments,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'replayId': replayId,
        'content': content,
        if (parentId != null) 'parentId': parentId,
      },
    );
  }

  static Future<Map<String, dynamic>> postReplayCommentAction({
    required String commentId,
    required String type, // "LIKE", "DISLIKE"
    String? parentId,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    if (token == null || token.isEmpty) throw Exception("User token not found");

    return await ApiService.post(
      ApiEndpoints.replaysCommentsAction,
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

  static Future<Map<String, dynamic>> getReplayComments(String replayId) async {
    final String? token = await SharedPreferencesHelper.getToken();
    return await ApiService.get(
      ApiEndpoints.singleReplayComments(replayId),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<Map<String, dynamic>> getReplayCommentReplies(
      String commentId) async {
    final String? token = await SharedPreferencesHelper.getToken();
    return await ApiService.get(
      ApiEndpoints.replayCommentReplies(commentId),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
  }

  /// ================= CHAT ROOMS =================
  static Future<Map<String, dynamic>> getChatRooms() async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(ApiEndpoints.chatRooms, headers: headers);
  }

  static Future<Map<String, dynamic>> getSingleChatRoom(String roomId) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(ApiEndpoints.singleChatRoom(roomId),
        headers: headers);
  }

  static Future<Map<String, dynamic>> joinChatRoom(String roomId) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.post(ApiEndpoints.joinChatRoom(roomId),
        headers: headers, body: {});
  }

  static Future<Map<String, dynamic>> getRoomMessages(String roomId) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(ApiEndpoints.roomMessages(roomId),
        headers: headers);
  }

  static Future<Map<String, dynamic>> sendMessage({
    required String roomId,
    required String content,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    final body = {
      'roomId': roomId,
      'content': content,
    };
    return await ApiService.post(
      ApiEndpoints.chatMessages,
      headers: headers,
      body: body,
    );
  }

  static Future<Map<String, dynamic>> toggleMessageReaction({
    required String messageId,
    required String emoji,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    final body = {
      'messageId': messageId,
      'emoji': emoji,
    };
    return await ApiService.post(
      ApiEndpoints.messageReaction,
      headers: headers,
      body: body,
    );
  }

  /// ================= NOTIFICATIONS =================
  static Future<Map<String, dynamic>> getNotifications() async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(ApiEndpoints.notifications, headers: headers);
  }

  static Future<Map<String, dynamic>> markNotificationsAsSeen() async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.patch(ApiEndpoints.markNotificationsAsSeen,
        headers: headers, body: {});
  }

  static Future<Map<String, dynamic>> getNotificationSettings() async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(ApiEndpoints.notificationSettings,
        headers: headers);
  }

  static Future<Map<String, dynamic>> updateNotificationSettings(
      Map<String, dynamic> body) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.patch(ApiEndpoints.notificationSettings,
        headers: headers, body: body);
  }

  /// ================= LIVE TV COMMENTS =================
  static Future<Map<String, dynamic>> getLiveTvComments(String tvId) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(ApiEndpoints.singleLiveTv(tvId),
        headers: headers);
  }

  static Future<Map<String, dynamic>> postLiveTvComment({
    required String liveTvId,
    required String content,
    String? parentId,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    if (token == null || token.isEmpty) throw Exception("User token not found");

    return await ApiService.post(
      ApiEndpoints.liveTvComments,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'liveTvId': liveTvId,
        'content': content,
        if (parentId != null) 'parentId': parentId,
      },
    );
  }

  static Future<Map<String, dynamic>> postLiveTvCommentAction({
    required String commentId,
    required String type, // "LIKE", "DISLIKE"
    String? parentId,
  }) async {
    final String? token = await SharedPreferencesHelper.getToken();
    if (token == null || token.isEmpty) throw Exception("User token not found");

    return await ApiService.post(
      ApiEndpoints.liveTvCommentsAction,
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

  static Future<Map<String, dynamic>> getLiveTvCommentReplies(
      String commentId) async {
    final String? token = await SharedPreferencesHelper.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return await ApiService.get(ApiEndpoints.liveTvCommentReplies(commentId),
        headers: headers);
  }
}
