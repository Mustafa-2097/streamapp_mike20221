import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testapp/features/customer_dashboard/home/widgets/upcoming_match_card.dart';

import '../../clips/screen/clips_screen.dart';
import '../../live/live_dashboard/screen/live_screen.dart';
import '../../live/live_video/screen/video_screen.dart';
import '../../news/view/news_screen.dart';
import '../../replay/view/replay_screen.dart';
import '../view/news_details_screen.dart';
import '../view/open_reels_video.dart';
import '../view/open_tvs.dart';
import 'live_card.dart';
import '../../news/controller/news_controller.dart';

class ContentSection extends StatelessWidget {
  ContentSection({super.key});

  final List<String> _videoUrls = [
    'https://media.streambrothers.com:2000/VideoPlayer/hpgnrhawxv2?autoplay=1',
    'https://media.streambrothers.com:2000/VideoPlayer/hpgnrhawxv?autoplay=1',
    'https://media.streambrothers.com:2000/VideoPlayer/hpgnrhawxv2?autoplay=1',
  ];

  final List<String> _videoTitles = [
    'Live TV Channel 1',
    'Live TV Channel 2',
    'Live TV Channel 3',
  ];

  final List<String> _liveImages = [
    'assets/images/live01.png',
    'assets/images/live02.png',
    'assets/images/live01.png',
  ];

  // Viewer counts for each live stream
  final List<String> _viewerCounts = ['205K', '189K', '156K'];

  // Titles for accessibility/alt text
  final List<String> _titles = [
    'Bangladesh vs Australia - Cricket Championship',
    'BIG GAME - Brazil vs Spain - World Cup',
    'Bangladesh vs Australia - Cricket Championship',
  ];

  // Descriptions for each live stream
  final List<String> _descriptions = [
    'Commentary: Watch the Asekay Mustafa take on the Australia Wallabies...',
    'Commentary: New Zealand All Blacks vs South Africa Springboks – Rugby Ch...',
    'Commentary: Watch the Asekay Mustafa take on the Australia Wallabies...',
  ];

  @override
  Widget build(BuildContext context) {
    final NewsController newsController = Get.put(NewsController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Live Now section
        _sectionName("Live Now", () {
          Get.to(LiveMatchesScreen());
        }),
        SizedBox(height: 16.h),

        // Horizontal Scrollable Live Now List
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _liveImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: LiveCard(
                  imagePath: _liveImages[index],
                  viewerCount: _viewerCounts[index],
                  title: _titles[index],
                  description: _descriptions[index],
                  isLocked: index == 0,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 24.h),

        // Live TV Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Live TV',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Live TV Channels
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTVChannel('assets/images/tv01.png', 0),
              _buildTVChannel('assets/images/tv02.png', 1),
              _buildTVChannel('assets/images/tv03.png', 2),
            ],
          ),
        ),

        SizedBox(height: 26.h),

        // Upcoming section
        // Upcoming section
        _sectionName("Upcoming", () {
          Get.to(
            () => LiveMatchesScreen(initialTab: 1), // 👈 Upcoming tab index
          );
        }),

        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GestureDetector(
            onTap: () {},
            child: Column(
              children: const [
                UpcomingMatchCard(
                  imagePath: 'assets/images/live01.png',
                  league: 'EFL Championship',
                  match: 'Brazil vs Spain',
                  time: 'Today at 06:04 PM',
                ),
                SizedBox(height: 12),
                UpcomingMatchCard(
                  imagePath: 'assets/images/live02.png',
                  league: 'Rugby Championship',
                  match: 'Springboks vs Argentina',
                  time: 'Today at 01:04 PM',
                  isHighlighted: true,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Replay Section
        _sectionName("Replay", () {
          Get.to(ReplayScreen());
        }),
        SizedBox(height: 16.h),

        SizedBox(
          height: 222.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 2, // Adjust based on your data
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: Container(
                  height: 222.h,
                  width: 211.w,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 1, color: Colors.white54),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(VideoLiveScreen());
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnail
                        Container(
                          height: 122.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/replay${index + 1}.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // Replay Info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              index == 0
                                  ? 'Carlos Alcaraz VS Jannik Sinner || Battle For #01'
                                  : 'Cricket World Cup Moments 2025',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Text(
                                  '2.1M views',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12.sp,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '5 days ago',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 24.h),

        // Clips Section
        _sectionName('Clips', () => Get.to(() => ClipsScreen())),
        SizedBox(height: 16.h),

        // Horizontal Clips List
        SizedBox(
          height: 280.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: GestureDetector(
                  onTap: () {
                    Get.to(OpenReelsVideo());
                  },
                  child: Container(
                    width: 180.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage('assets/images/clip${index + 1}.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Text at bottom
                          Positioned(
                            bottom: 12.h,
                            left: 12.w,
                            right: 12.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lionel Messi embarrassed the goalkeeper with a brilliant chip',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '3.4M views',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 24.h),

        // Latest News Section
        _sectionName('Latest News', () => Get.to(() => NewsScreen())),
        SizedBox(height: 16.h),

        // Latest News Section
        Obx(() {
          if (newsController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          if (newsController.newsList.isEmpty) {
            return const SizedBox(); // Or a "No news" widget
          }
          return SizedBox(
            height: 120.h,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!newsController.isLoadingMore.value &&
                    newsController.hasMore.value &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  newsController.fetchNews(isLoadMore: true);
                }
                return true;
              },
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount:
                    newsController.newsList.length +
                    (newsController.isLoadingMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == newsController.newsList.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }
                  final article = newsController.newsList[index];
                  return Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(NewsDetailsScreen());
                      },
                      child: Container(
                        width: 280.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: article.urlToImage != null
                                ? NetworkImage(article.urlToImage!)
                                : const AssetImage('assets/images/news.png')
                                      as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.5),
                                Colors.black.withOpacity(0.9),
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Text at bottom
                              Positioned(
                                bottom: 12.h,
                                left: 12.w,
                                right: 12.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.title ?? 'No Title',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        Text(
                                          article.publishedAt != null &&
                                                  article.publishedAt!.length >=
                                                      10
                                              ? article.publishedAt!.substring(
                                                  0,
                                                  10,
                                                )
                                              : 'Unknown Date',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '12k read', // Placeholder as API doesn't provide read count
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
        SizedBox(height: 32.h),
      ],
    );
  }

  Padding _sectionName(String label, VoidCallback? onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Text(
              'View All',
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTVChannel(String imagePath, int index) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => openTvs(
            videoUrl: _videoUrls[index],
            videoTitle: _videoTitles[index],
            viewerCount: _viewerCounts[index],
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(imagePath, width: 90, fit: BoxFit.cover),
      ),
    );
  }
}
