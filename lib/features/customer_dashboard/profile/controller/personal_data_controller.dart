import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalDataController extends GetxController {
  var selectedDate = "dd/mm/yyyy".obs;
  var selectedCountry = "Select Your Country".obs;
  Future<void> chooseDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950), 
      lastDate: DateTime.now(),  
    );
    if (pickedDate != null) {
      selectedDate.value = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  void showCountryPickerSheet(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: false, // Set to true if you want to see +880, etc.
      onSelect: (Country country) {
        // This updates the UI with the flag and name
        selectedCountry.value = "${country.flagEmoji}  ${country.name}";
      },
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.circular(20.r),
        backgroundColor: const Color(0xFF1A1A1A), // Match your app theme
        textStyle: const TextStyle(color: Colors.white),
        searchTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }

}