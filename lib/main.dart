import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testapp/features/splash/views/splash_screen.dart';
import 'core/network/socket_service.dart';
import 'features/customer_dashboard/news/controller/news_controller.dart';
import 'features/customer_dashboard/profile/controller/bookmarks_controller.dart';
import 'features/customer_dashboard/home/controller/notification_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => SocketService().init());
  Get.put(NewsController(), permanent: true);
  Get.put(BookmarkController(), permanent: true);
  Get.put(NotificationController(), permanent: true);
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
        return GetMaterialApp(debugShowCheckedModeBanner: false, home: child);
      },
      child: SplashScreen(),
    );
  }
}
