import 'package:flutter/material.dart';
import '../widgets/all_tab.dart';
import '../widgets/carousel_slider.dart';
import '../widgets/custom_appdrawer.dart';
import '../widgets/custom_home_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const CustomAppDrawer(),
      body: Container(
        height: sh,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3A0F0F), Color(0xFF0B0B0B), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: const CustomHomeAppBar(),
              ),

              SliverToBoxAdapter(
                child: const RugbyCarouselSlider(),
              ),

              SliverToBoxAdapter(
                child: SizedBox(height: 10),
              ),

              SliverToBoxAdapter(
                child: ContentSection(), // Add the LiveNow section here
              ),

            ],
          ),
        ),
      ),
    );
  }
}