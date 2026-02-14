import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SportsCategoryFilter extends StatefulWidget {
  const SportsCategoryFilter({super.key});

  @override
  State<SportsCategoryFilter> createState() => _SportsCategoryFilterState();
}

class _SportsCategoryFilterState extends State<SportsCategoryFilter> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> sports = [
    {'label': 'All', 'icon': null},
    {'label': 'Football', 'icon': Icons.sports_soccer},
    {'label': 'Cricket', 'icon': Icons.sports_cricket},
    {'label': 'Tennis', 'icon': Icons.sports_tennis},
    {'label': 'Rugby', 'icon': Icons.sports_rugby},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            sports.length,
            (index) => Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? Colors.amber
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24.r),
                    border: selectedIndex == index
                        ? null
                        : Border.all(color: Colors.white24, width: 1),
                  ),
                  child:sports[index]['icon'] != null
                  ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      sports[index]['icon'],
                      size: 18.r,
                      color: selectedIndex == index ? Colors.black : Colors.white,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      sports[index]['label'],
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: selectedIndex == index ? Colors.black : Colors.white,
                      ),
                    ),
                  ],
                )
                    : Center(
              child: Text(
              sports[index]['label'],
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: selectedIndex == index ? Colors.black : Colors.white,
                ),
              ),
            ),

          ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
