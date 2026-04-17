import 'package:get/get.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../model/banner_model.dart';
import 'package:testapp/core/utils/url_helper.dart';
import '../../../../core/offline_storage/shared_pref.dart';

class BannerController extends GetxController {
  var isLoading = false.obs;
  var bannersList = <BannerModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    isLoading.value = true;
    try {
      final String? token = await SharedPreferencesHelper.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };
      
      final response = await ApiService.get(ApiEndpoints.banners, headers: headers);
      print("Banners response: $response");
      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        bannersList.value = data.map((e) => BannerModel.fromJson(e)).toList();
      } else {
        print("Banners parsing failed: ${response['data']}");
      }
    } catch (e) {
      print("Banners Error: $e");
      // Errors handled by ApiService
    } finally {
      isLoading.value = false;
    }
  }
}
