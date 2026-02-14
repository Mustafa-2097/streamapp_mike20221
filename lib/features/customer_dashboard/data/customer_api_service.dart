import '../../../core/network/api_service.dart';
import '../../../core/offline_storage/shared_pref.dart';

class CustomerApiService {
  static const String _baseUrl = 'https://mike20221.smtsigma.com/api/v1';

  static Future<Map<String, dynamic>> getProfile() async {
    final token = await SharedPreferencesHelper.getToken();

    return await ApiService.get(
      '$_baseUrl/users/profile',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': ?token, // backend expects raw token (as in Postman)
      },
    );
  }
}
