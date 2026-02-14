import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_service.dart';
import '../../../core/offline_storage/shared_pref.dart';

class CustomerApiService {

  /// Profile
  static Future<Map<String, dynamic>> getProfile() async {
    final String? token = await SharedPreferencesHelper.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("User token not found");
    }

    return await ApiService.get(
      ApiEndpoints.userProfile,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );
  }

  /// Live
  static Future<Map<String, dynamic>> getLiveScores() async {
    return await ApiService.get(
      ApiEndpoints.liveScores,
    );
  }
}
