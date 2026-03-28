import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'profile_controller.dart';

class ContactUsController extends GetxController {
  static ContactUsController get instance => Get.find();

  /// Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final profileCtrl = Get.find<ProfileController>();
    if (profileCtrl.profile.value != null) {
      nameController.text = profileCtrl.profile.value?.name ?? "No Name Set";
      emailController.text = profileCtrl.profile.value?.email ?? "";
    }
  }

  /// Message validation
  String? validateMessage(String value) {
    if (value.isEmpty) return "Message is required";
    if (value.length < 10) return "Message must be at least 10 characters";
    return null;
  }

  /// Submit logic
  Future<void> contactChange(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    try {
      EasyLoading.show(status: 'Sending...');
      // Simulated API call point
      await Future.delayed(const Duration(seconds: 1));

      EasyLoading.dismiss();
      Get.snackbar("Success", "Your message has been sent!", 
        backgroundColor: Colors.amber, 
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM
      );
      messageController.clear();
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", e.toString(), 
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
