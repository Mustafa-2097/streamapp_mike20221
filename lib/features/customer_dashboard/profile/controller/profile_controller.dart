import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../data/customer_api_service.dart';
import '../model/customer_profile_model.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find<ProfileController>();

  final isLoading = false.obs;
  final profile = Rxn<CustomerProfile>();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final response = await CustomerApiService.getProfile();
      
      if (response['success'] == true && response['data'] != null) {
        profile.value = CustomerProfile.fromJson(response['data']);
      }
    } catch (e) {
      debugPrint("ProfileController fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Helper dedicated to updating the profile from any other controller
  void updateProfileData(Map<String, dynamic> userData) {
    try {
      debugPrint("DEBUG: ProfileController updating with raw data...");
      
      // Fix image URL mapping if key is inconsistent
      String? photo = userData['profilePhoto']?.toString();
      
      if (photo != null) {
        photo = photo.replaceAll('localhost', '10.0.30.59').replaceAll('127.0.0.1', '10.0.30.59');
        userData['profilePhoto'] = photo;
        debugPrint("DEBUG: Fixed photo URL for global sync: $photo");
      }

      profile.value = CustomerProfile.fromJson(userData);
      profile.refresh(); 
      debugPrint("DEBUG: ProfileController refresh() called.");
    } catch (e) {
      debugPrint("Error updating profile globally: $e");
    }
  }
}
