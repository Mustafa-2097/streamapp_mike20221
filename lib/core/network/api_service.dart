import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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
        headers: headers ?? {'Content-Type': 'application/json'},
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
      Get.snackbar("Error", _friendlyError(e));
      rethrow;
    }
  }

  /// GET REQUEST
  static Future<Map<String, dynamic>> get(
      String url, {
        Map<String, String>? headers,
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      final uri = Uri.parse(url).replace(queryParameters: queryParameters);
      final response = await http.get(uri, headers: headers).timeout(timeout);

      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        throw decoded['message'] ?? 'Something went wrong';
      }
    } catch (e) {
      Get.snackbar("Error", _friendlyError(e));
      rethrow;
    }
  }

  /// PUT REQUEST
  static Future<Map<String, dynamic>> put(
      String url, {
        Map<String, String>? headers,
        Map<String, dynamic>? body,
      }) async {
    try {
      final response = await http
          .put(
        Uri.parse(url),
        headers: headers ?? {'Content-Type': 'application/json'},
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
      Get.snackbar("Error", _friendlyError(e));
      rethrow;
    }
  }

  /// PATCH REQUEST (JSON body)
  static Future<Map<String, dynamic>> patch(
      String url, {
        Map<String, String>? headers,
        Map<String, dynamic>? body,
      }) async {
    try {
      final response = await http
          .patch(
        Uri.parse(url),
        headers: headers ?? {'Content-Type': 'application/json'},
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
      Get.snackbar("Error", _friendlyError(e));
      rethrow;
    }
  }

  /// PATCH MULTIPART REQUEST (for file uploads like profile image)
  static Future<Map<String, dynamic>> patchMultipart(
      String url, {
        required Map<String, String> headers,
        Map<String, String>? fields,
        File? imageFile,
        String imageFieldName = 'profileImage',
      }) async {
    try {
      final request = http.MultipartRequest('PATCH', Uri.parse(url));

      // Do NOT set Content-Type manually — http sets it with the correct boundary
      headers.forEach((key, value) {
        if (key.toLowerCase() != 'content-type') {
          request.headers[key] = value;
        }
      });

      if (fields != null) {
        request.fields.addAll(fields);
      }

      if (imageFile != null) {
        final mimeType = _getMimeType(imageFile.path);
        request.files.add(
          await http.MultipartFile.fromPath(
            imageFieldName,
            imageFile.path,
            contentType: mimeType,
          ),
        );
      }

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);
      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        throw decoded['message'] ?? 'Something went wrong';
      }
    } catch (e) {
      Get.snackbar("Error", _friendlyError(e));
      rethrow;
    }
  }

  /// Returns correct http_parser MediaType
  static MediaType _getMimeType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'webp':
        return MediaType('image', 'webp');
      default:
        return MediaType('image', 'jpeg');
    }
  }

  /// Converts raw exceptions into user-friendly strings
  static String _friendlyError(Object e) {
    final msg = e.toString();
    if (msg.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    }
    if (msg.contains('SocketException')) return 'No internet connection.';
    if (msg.contains('FormatException')) return 'Unexpected server response.';
    // If it's already a clean API message string, return it directly
    if (!msg.contains('Exception:') && !msg.contains('Error:')) return msg;
    return 'Something went wrong. Please try again.';
  }
}