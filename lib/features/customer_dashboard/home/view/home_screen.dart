import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/scaffold_bg.dart';
import '../../clips/controller/clips_controller.dart';
import '../../live/live_dashboard/controller/live_controller.dart';
import '../../news/controller/news_controller.dart';
import '../../replay/controller/replay_controller.dart';
import '../controller/live_game_controller.dart';
import '../controller/live_tv_controller.dart';
import '../widgets/all_tab.dart';
import '../widgets/carousel_slider.dart';
import '../widgets/custom_appdrawer.dart';
import '../widgets/custom_home_appbar.dart';
import '../controller/banner_controller.dart';

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
                child: RefreshIndicator(
                  onRefresh: () async {
                    // Update all tab content
                    if (Get.isRegistered<ReplayController>()) {
                      await Get.find<ReplayController>().fetchReplays();
                    }
                    if (Get.isRegistered<LiveTvController>()) {
                      await Get.find<LiveTvController>().fetchLiveTvs();
                    }
                    if (Get.isRegistered<LiveGameController>()) {
                      await Get.find<LiveGameController>().fetchLiveGames();
                    }
                    if (Get.isRegistered<LiveMatchesController>()) {
                      await Get.find<LiveMatchesController>().fetchLiveMatches();
                      await Get.find<LiveMatchesController>().fetchUpcomingMatches();
                    }
                    if (Get.isRegistered<NewsController>()) {
                      await Get.find<NewsController>().fetchNews();
                    }
                    if (Get.isRegistered<ClipsController>()) {
                      await Get.find<ClipsController>().fetchClips();
                    }
                    if (Get.isRegistered<BannerController>()) {
                      await Get.find<BannerController>().fetchBanners();
                    }
                  },
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: const HomeCarouselSlider()),
                      SliverToBoxAdapter(child: const SizedBox(height: 20)),
                      SliverToBoxAdapter(child: ContentSection()),
                    ],
                  ),
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
