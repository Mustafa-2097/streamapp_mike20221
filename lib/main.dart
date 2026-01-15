import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testapp/features/dashboard/customer_dashboard.dart';
import 'package:testapp/features/splash/views/splash_screen.dart';

import 'features/profile/controller/bookmarks_controller.dart';

void main() {
  Get.put(BookmarkController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(440, 956), // your UI design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: child,
        );
      },
      child: CustomerDashboard(initialIndex: 4),
    );
  }
}
