import 'package:get/get.dart';
import '../../data/customer_api_service.dart';
import '../model/customer_profile_model.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

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
      print(response);

      profile.value = CustomerProfile.fromJson(response['data']);
    } catch (e) {
      // snackbar already handled in ApiService
    } finally {
      isLoading.value = false;
    }
  }
}
