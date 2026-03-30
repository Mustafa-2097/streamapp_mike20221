import 'package:flutter/material.dart';
import '../../../../core/common/widgets/scaffold_bg.dart';
import '../widgets/all_tab.dart';
import '../widgets/carousel_slider.dart';
import '../widgets/custom_appdrawer.dart';
import '../widgets/custom_home_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomAppDrawer(),
      body: ScaffoldBg(
        child: SafeArea(
          child: Stack(
            children: [
              // Main Scrollable Content
              Padding(
                padding: const EdgeInsets.only(
                  top: 64,
                ), // Height of CustomHomeAppBar
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: const HomeCarouselSlider()),
                    SliverToBoxAdapter(child: const SizedBox(height: 20)),
                    SliverToBoxAdapter(child: ContentSection()),
                  ],
                ),
              ),

              // Fixed Transparent AppBar on top
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CustomHomeAppBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
