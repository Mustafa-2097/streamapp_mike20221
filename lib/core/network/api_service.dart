import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ApiService {
  static const Duration timeout = Duration(seconds: 30);

  /// POST REQUEST
  static Future<Map<String, dynamic>> post(
      String url, {
        Map<String, String>? headers,
        Map<String, dynamic>? body,
      }) async {
    try {
      final response = await http
          .post(
        Uri.parse(url),
        headers: headers ??
            {
              'Content-Type': 'application/json',
            },
        body: jsonEncode(body),
      )
          .timeout(timeout);

      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        throw decoded['message'] ?? 'Something went wrong';
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      rethrow;
    }
  }

  /// GET REQUEST
  static Future<Map<String, dynamic>> get(
      String url, {
        Map<String, String>? headers,
      }) async {
    try {
      final response = await http
          .get(
        Uri.parse(url),
        headers: headers,
      )
          .timeout(timeout);

      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        throw decoded['message'] ?? 'Something went wrong';
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      rethrow;
    }
  }
}
