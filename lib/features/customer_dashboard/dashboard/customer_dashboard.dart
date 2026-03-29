import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/features/customer_dashboard/dashboard/widgets/bottom_nav.dart';
import '../clips/screen/clips_screen.dart';
import '../home/view/home_screen.dart';
import '../live/live_dashboard/screen/live_screen.dart';
import '../profile/controller/profile_controller.dart';
import '../profile/view/profile_screen.dart';
import '../replay/view/replay_screen.dart';
import '../rooms/controller/rooms_controller.dart';
import '../rooms/view/rooms_screen.dart';
import '../home/controller/notification_controller.dart';

class CustomerDashboard extends StatefulWidget {
  final int initialIndex;
  const CustomerDashboard({super.key, this.initialIndex = 0});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  late int _selectedIndex;

  final List<Widget> _screens = [
    HomeScreen(),
    ClipsScreen(),
    LiveMatchesScreen(),
    ReplayScreen(),
    RoomsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Refresh notifications when user navigates to Home tab
    if (index == 0 && Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().fetchNotifications();
    }

    // Refresh Rooms data when user navigates to Rooms tab
    if (index == 4 && Get.isRegistered<RoomsController>()) {
      Get.find<RoomsController>().fetchRooms();
    }
    
    // Also refresh profile when on profile tab
    if (index == 5 && Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().fetchProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
