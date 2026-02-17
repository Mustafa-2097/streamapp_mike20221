import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/customer_api_service.dart';

class PersonalDataController extends GetxController {
  // ── Observables ──────────────────────────────────────────────────────────────
  var selectedDate = "dd/mm/yyyy".obs;
  var selectedCountry = "Select Your Country".obs;
  var profileImageFile = Rxn<File>();  // newly picked local file
  var networkImageUrl = RxnString();   // existing image URL from server
  var isLoading = false.obs;
  var isInitializing = true.obs;

  // ✅ email is now observable so the UI reacts when it's populated after fetch
  var email = ''.obs;

  // Raw country name without emoji — this is what gets sent to the API
  String _rawCountryName = '';

  final TextEditingController nameController = TextEditingController();

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

  // ── Load existing profile ─────────────────────────────────────────────────────
  Future<void> _loadExistingProfile() async {
    try {
      isInitializing.value = true;
      final response = await CustomerApiService.getProfile();

      if (response['success'] == true) {
        final data = response['data'] as Map<String, dynamic>;

        nameController.text = data['name'] ?? '';

        // ✅ Reactive email
        email.value = data['email'] ?? '';

        // Date of Birth
        final rawDob = data['dateOfBirth'];
        if (rawDob != null && rawDob.toString().isNotEmpty) {
          selectedDate.value = _isoToDisplay(rawDob.toString());
        }

        // ✅ Country: strip any emoji that may have been stored from a previous
        //    save, so _rawCountryName is always a clean plain string for the API
        final rawCountry = data['country'];
        if (rawCountry != null && rawCountry.toString().isNotEmpty) {
          _rawCountryName = _stripEmoji(rawCountry.toString());
          selectedCountry.value = _rawCountryName;
        }

        // Profile image URL
        final imageUrl = data['profileImage'];
        if (imageUrl != null && imageUrl.toString().isNotEmpty) {
          networkImageUrl.value = imageUrl.toString();
        }
      }
    } catch (_) {
      // Silently fail — user can still edit manually
    } finally {
      isInitializing.value = false;
    }
  }

  // ── Date helpers ──────────────────────────────────────────────────────────────

  /// "YYYY-MM-DDT..." → "d/m/yyyy"
  String _isoToDisplay(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return "${dt.day}/${dt.month}/${dt.year}";
    } catch (_) {
      return iso;
    }
  }

  /// "d/m/yyyy" → "YYYY-MM-DD" for the API
  String? _displayToIso(String display) {
    if (display == "dd/mm/yyyy") return null;
    final parts = display.split('/');
    if (parts.length != 3) return null;
    final day = parts[0].padLeft(2, '0');
    final month = parts[1].padLeft(2, '0');
    final year = parts[2];
    return "$year-$month-$day";
  }

  /// ✅ Strips emoji characters and trims whitespace from a country string.
  /// Regex matches all Unicode emoji ranges.
  String _stripEmoji(String input) {
    return input
        .replaceAll(
      RegExp(
        r'[\u{1F1E0}-\u{1F1FF}'     // flags
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

  // ── Date Picker ───────────────────────────────────────────────────────────────
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

    final DateTime? pickedDate = await showDatePicker(
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

  // ── Country Picker ────────────────────────────────────────────────────────────
  void showCountryPickerSheet(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        // ✅ Store clean name for API, display with emoji for UI
        _rawCountryName = country.name;
        selectedCountry.value = "${country.flagEmoji}  ${country.name}";
      },
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.circular(20.r),
        backgroundColor: const Color(0xFF1A1A1A),
        textStyle: const TextStyle(color: Colors.white),
        searchTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }

  // ── Image Picker ──────────────────────────────────────────────────────────────
  Future<void> pickImage() async {
    final ImageSource? source = await _showImageSourceDialog();
    if (source == null) return;

    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (picked != null) {
      profileImageFile.value = File(picked.path);
      networkImageUrl.value = null; // local file takes priority over network URL
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
            child: const Text("Camera", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Get.back(result: ImageSource.gallery),
            child: const Text("Gallery", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Save / Update Profile ─────────────────────────────────────────────────────
  Future<void> saveProfile() async {
    try {
      isLoading.value = true;

      final response = await CustomerApiService.updateProfile(
        name: nameController.text.trim().isNotEmpty
            ? nameController.text.trim()
            : null,
        dateOfBirth: _displayToIso(selectedDate.value),
        country: _rawCountryName.isNotEmpty ? _rawCountryName : null,
        imageFile: profileImageFile.value,
      );

      if (response['success'] == true) {
        Get.snackbar(
          "Success",
          response['message'] ?? "Profile updated successfully",
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
        Get.back();
      } else {
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to update profile",
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (_) {
      // ApiService already shows the snackbar
    } finally {
      isLoading.value = false;
    }
  }
}