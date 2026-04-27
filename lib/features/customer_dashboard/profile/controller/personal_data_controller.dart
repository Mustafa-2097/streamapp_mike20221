import 'dart:io';
import 'package:flutter/material.dart';
import 'package:testapp/core/const/app_colors.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/profile_controller.dart';
import 'package:flutter/foundation.dart';
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

  // Reactivity for Name field
  var currentNameText = ''.obs;

  // Raw country name (without emoji)
  var _rawCountryName = ''.obs;

  // Track original values
  String _originalName = '';
  String _originalDate = "dd/mm/yyyy";
  String _originalCountry = '';

  final TextEditingController nameController = TextEditingController();

  // Getter to check if any data has changed
  bool get hasChanges {
    final nameChanged = currentNameText.value.trim() != _originalName;
    final dateChanged = selectedDate.value != _originalDate;
    final countryChanged = _rawCountryName.value != _originalCountry;
    final imageChanged = profileImageFile.value != null;

    return nameChanged || dateChanged || countryChanged || imageChanged;
  }

  // ────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    // Sync nameController with currentNameText observable
    nameController.addListener(() {
      currentNameText.value = nameController.text;
    });
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

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;

        // Name
        nameController.text = data['name']?.toString() ?? '';
        _originalName = nameController.text;
        currentNameText.value = _originalName;

        // Email
        email.value = data['email']?.toString() ?? '';

        // Date of Birth
        final rawDob = data['dateOfBirth'];
        if (rawDob != null && rawDob.toString().isNotEmpty) {
          selectedDate.value = _isoToDisplay(rawDob.toString());
          _originalDate = selectedDate.value;
        }

        // Country
        final rawCountry = data['country'];
        if (rawCountry != null && rawCountry.toString().isNotEmpty) {
          _rawCountryName.value = _stripEmoji(rawCountry.toString());
          _originalCountry = _rawCountryName.value;
          selectedCountry.value = _rawCountryName.value;
        }

        // Profile image - robust localhost fix
        String? imageUrl = data['profilePhoto']?.toString();
        if (imageUrl != null && imageUrl.isNotEmpty) {
          imageUrl = imageUrl
              .replaceAll('localhost', '10.0.30.59')
              .replaceAll('127.0.0.1', '10.0.30.59');
          networkImageUrl.value = imageUrl;
        }
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
    } finally {
      isInitializing.value = false;
    }
  }

  // ── Date Helpers ────────────────────────────────────────────

  String _isoToDisplay(String iso) {
    if (iso.contains('/')) return iso;
    try {
      final dt = DateTime.parse(iso);
      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
    } catch (_) {
      return "dd/mm/yyyy";
    }
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

    if (selectedDate.value != "dd/mm/yyyy" && selectedDate.value.isNotEmpty) {
      try {
        final parts = selectedDate.value.split('/');
        if (parts.length == 3) {
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);
          if (day != null && month != null && year != null) {
            initialDate = DateTime(year, month, day);
          }
        }
      } catch (_) {
        initialDate = DateTime.now();
      }
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(DateTime.now())
          ? DateTime.now()
          : initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      selectedDate.value =
          "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
    }
  }

  // ── Country Picker ──────────────────────────────────────────
  void showCountryPickerSheet(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      countryListTheme: CountryListThemeData(
        // Restrict height to ~55% of screen
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.55,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        textStyle: const TextStyle(color: Colors.white, fontSize: 15),
        searchTextStyle: const TextStyle(color: Colors.white),
        inputDecoration: InputDecoration(
          hintText: 'Search country',
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: const Icon(Icons.search, color: Colors.white54),
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      onSelect: (Country country) {
        _rawCountryName.value = country.name;
        selectedCountry.value = "${country.flagEmoji}  ${country.name}";
      },
    );
  }

  // ── Image Picker ─────────────────────────────────────────────
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

  // ── Save Profile ─────────────────────────────────────────────
  Future<void> saveProfile() async {
    if (!hasChanges) return;

    try {
      buttonText.value = 'Saving...';
      isLoading.value = true;

      // Ensure we don't send placeholder values to the backend
      final dob = selectedDate.value == "dd/mm/yyyy" ? null : selectedDate.value;
      final ctry = _rawCountryName.value.isNotEmpty ? _rawCountryName.value : (_originalCountry.isNotEmpty ? _originalCountry : null);

      final response = await CustomerApiService.updateProfile(
        name: currentNameText.value.trim(),
        dateOfBirth: dob,
        country: ctry,
        imageFile: profileImageFile.value,
      );

      if (response['success'] == true && response['data'] != null) {
        final updatedUser = response['data'] as Map<String, dynamic>;

        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().updateProfileData(updatedUser);
        }

        String? updatedPhoto = updatedUser['profilePhoto']?.toString();
        if (updatedPhoto != null) {
          updatedPhoto = updatedPhoto
              .replaceAll('localhost', '10.0.30.59')
              .replaceAll('127.0.0.1', '10.0.30.59');
        }
        networkImageUrl.value = updatedPhoto;
        profileImageFile.value = null;

        _originalName = updatedUser['name']?.toString() ?? '';
        _originalCountry = _stripEmoji(updatedUser['country']?.toString() ?? '');
        _originalDate = selectedDate.value;
        currentNameText.value = _originalName;

        buttonText.value = 'Saved!';

        Get.snackbar(
          "Success",
          response['message'] ?? "Profile updated successfully",
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.black,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );

        await Future.delayed(const Duration(seconds: 2));
        buttonText.value = 'Save';
      } else {
        buttonText.value = 'Save';
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to update profile",
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.black,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      buttonText.value = 'Save';
      debugPrint("Profile save crash: $e");
      // Error already handled in ApiService globally
    } finally {
      isLoading.value = false;
    }
  }
}
