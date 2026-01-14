import 'package:flutter/material.dart';
import 'package:testapp/features/clips/screen/clips_screen.dart';
import 'package:testapp/features/dashboard/widgets/bottom_nav.dart';
import 'package:testapp/features/profile/view/profile_screen.dart';
import '../home/screen/home_screen.dart';
import '../live/live_dashboard/screen/live_screen.dart';
import '../replay/view/replay_screen.dart';

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
