import 'package:flutter/material.dart';
import '../../../core/common/widgets/scaffold_bg.dart';
import '../widgets/all_tab.dart';
import '../widgets/carousel_slider.dart';
import '../widgets/custom_appdrawer.dart';
import '../widgets/custom_home_appbar.dart';
import '../widgets/sports_category_filter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomAppDrawer(),
      body: ScaffoldBg(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: false,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                flexibleSpace: const CustomHomeAppBar(),
              ),

              SliverToBoxAdapter(
                child: const HomeCarouselSlider(),
              ),

              SliverToBoxAdapter(
                child: const SportsCategoryFilter(),
              ),

              SliverToBoxAdapter(
                child: SizedBox(height: 10),
              ),

              SliverToBoxAdapter(
                child: ContentSection(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}