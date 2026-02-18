import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/customer_api_service.dart';

class PersonalDataController extends GetxController {
  // ── Observables ─────────────────────────────────────────────
  var selectedDate = "dd/mm/yyyy".obs;
  var selectedCountry = "Select Your Country".obs;
  var profileImageFile = Rxn<File>();
  var networkImageUrl = RxnString();
  var isLoading = false.obs;
  var isInitializing = true.obs;
  var email = ''.obs;
  var buttonText = 'Save'.obs;

  // Raw country name (without emoji)
  String _rawCountryName = '';

  // Track original values
  String _originalName = '';
  String _originalDate = "dd/mm/yyyy";
  String _originalCountry = '';

  final TextEditingController nameController = TextEditingController();

  // ────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _loadExistingProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  // ── Load Existing Profile ───────────────────────────────────
  Future<void> _loadExistingProfile() async {
    try {
      isInitializing.value = true;
      final response = await CustomerApiService.getProfile();

      if (response['success'] == true) {
        final data = response['data'] as Map<String, dynamic>;

        // Name
        nameController.text = data['name'] ?? '';
        _originalName = nameController.text;

        // Email
        email.value = data['email'] ?? '';

        // Date of Birth
        final rawDob = data['dateOfBirth'];
        if (rawDob != null && rawDob.toString().isNotEmpty) {
          selectedDate.value = _isoToDisplay(rawDob.toString());
          _originalDate = selectedDate.value;
        }

        // Country
        final rawCountry = data['country'];
        if (rawCountry != null && rawCountry.toString().isNotEmpty) {
          _rawCountryName = _stripEmoji(rawCountry.toString());
          _originalCountry = _rawCountryName;
          selectedCountry.value = _rawCountryName;
        }

        // Profile image
        final imageUrl = data['profileImage'];
        if (imageUrl != null && imageUrl.toString().isNotEmpty) {
          networkImageUrl.value = imageUrl.toString();
        }
      }
    } catch (_) {
      // Fail silently – allow manual editing
    } finally {
      isInitializing.value = false;
    }
  }

  // ── Date Helpers ────────────────────────────────────────────

  String _isoToDisplay(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return "${dt.day}/${dt.month}/${dt.year}";
    } catch (_) {
      return "dd/mm/yyyy";
    }
  }

  String? _displayToIso(String display) {
    if (display == "dd/mm/yyyy") return null;
    final parts = display.split('/');
    if (parts.length != 3) return null;

    final day = parts[0].padLeft(2, '0');
    final month = parts[1].padLeft(2, '0');
    final year = parts[2];

    return "$year-$month-$day";
  }

  String _stripEmoji(String input) {
    return input
        .replaceAll(
      RegExp(
        r'[\u{1F1E0}-\u{1F1FF}'
        r'\u{1F300}-\u{1F5FF}'
        r'\u{1F600}-\u{1F64F}'
        r'\u{1F680}-\u{1F6FF}'
        r'\u{1F700}-\u{1F77F}'
        r'\u{1F780}-\u{1F7FF}'
        r'\u{1F800}-\u{1F8FF}'
        r'\u{1F900}-\u{1F9FF}'
        r'\u{1FA00}-\u{1FA6F}'
        r'\u{1FA70}-\u{1FAFF}'
        r'\u{2600}-\u{26FF}'
        r'\u{2700}-\u{27BF}]',
        unicode: true,
      ),
      '',
    )
        .trim();
  }

  // ── Date Picker ─────────────────────────────────────────────
  Future<void> chooseDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();

    if (selectedDate.value != "dd/mm/yyyy") {
      try {
        final parts = selectedDate.value.split('/');
        initialDate = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } catch (_) {}
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      selectedDate.value =
      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  // ── Country Picker ──────────────────────────────────────────
  void showCountryPickerSheet(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        _rawCountryName = country.name;
        selectedCountry.value = "${country.flagEmoji}  ${country.name}";
      },
    );
  }

  // ── Image Picker ─────────────────────────────────────────────
  Future<void> pickImage() async {
    final ImageSource? source = await _showImageSourceDialog();
    if (source == null) return;

    final ImagePicker picker = ImagePicker();
    final XFile? picked =
    await picker.pickImage(source: source, imageQuality: 80);

    if (picked != null) {
      profileImageFile.value = File(picked.path);
      networkImageUrl.value = null;
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return await Get.dialog<ImageSource>(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          "Select Image Source",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: ImageSource.camera),
            child: const Text("Camera",
                style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Get.back(result: ImageSource.gallery),
            child: const Text("Gallery",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Save Profile ─────────────────────────────────────────────
  Future<void> saveProfile() async {
    final currentName = nameController.text.trim();
    final currentIsoDate = _displayToIso(selectedDate.value);
    final originalIsoDate = _displayToIso(_originalDate);

    final nameChanged = currentName != _originalName;
    final dateChanged = currentIsoDate != originalIsoDate;
    final countryChanged = _rawCountryName != _originalCountry;
    final imageChanged = profileImageFile.value != null;

    final hasChanges =
        nameChanged || dateChanged || countryChanged || imageChanged;

    if (!hasChanges) {
      Get.snackbar(
        "No Changes",
        "Please make some changes before saving",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      buttonText.value = 'Saving...';
      isLoading.value = true;

      final response = await CustomerApiService.updateProfile(
        name: nameChanged ? currentName : null,
        dateOfBirth: dateChanged ? currentIsoDate : null,
        country: countryChanged ? _rawCountryName : null,
        imageFile: profileImageFile.value,
      );

      if (response['success'] == true) {
        // Update original values after success
        _originalName = currentName;
        _originalDate = selectedDate.value;
        _originalCountry = _rawCountryName;

        profileImageFile.value = null;

        buttonText.value = 'Saved!';

        Get.snackbar(
          "Success",
          response['message'] ?? "Profile updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        await Future.delayed(const Duration(seconds: 2));
        buttonText.value = 'Save';
      } else {
        buttonText.value = 'Save';

        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to update profile",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (_) {
      buttonText.value = 'Save';

      Get.snackbar(
        "Error",
        "Failed to update profile. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
