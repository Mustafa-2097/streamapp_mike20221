import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../core/const/app_colors.dart';

class ContactUsController extends GetxController {
  static ContactUsController get instance => Get.find();

  /// Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

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
      // await _repository.contactUs(
      //   messageController.text.trim(),
      // );

      EasyLoading.dismiss();
      Get.snackbar("Success", "Your message has been sent!", backgroundColor: AppColors.primaryColor, snackPosition: SnackPosition.BOTTOM);
      messageController.clear();

    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
    }
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   nameController.text = profile.userName.value;
  //   emailController.text = profile.userEmail.value;
  // }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
