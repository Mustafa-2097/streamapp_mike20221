import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({super.key});

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  String selectedLanguage = 'English';
  final List<String> languages = ['English', 'Spanish', 'French'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Icon(
            Icons.language_outlined,
            size: 24.r,
            color: Colors.white,
          ),
          SizedBox(width: 6.w),
          Text(
            "Language",
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),

          // pushes dropdown to the right side
          Spacer(),

          DropdownButton<String>(
            value: selectedLanguage,
            isDense: true,
            dropdownColor: Colors.grey.shade900,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            underline: SizedBox(),

            // remove arrow + spacing
            icon: SizedBox.shrink(),
            iconSize: 0,

            items: languages.map((String language) {
              return DropdownMenuItem<String>(
                value: language,
                child: Text(
                  language,
                  textAlign: TextAlign.right,
                ),
              );
            }).toList(),

            selectedItemBuilder: (context) {
              return languages.map((language) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    language,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList();
            },

            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedLanguage = newValue;
                });
              }
            },
          ),
        ],
      ),
    );


  }
}
