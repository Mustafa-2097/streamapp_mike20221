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
import '../view/open_live_games.dart';
import 'live_card.dart';
import '../../profile/controller/bookmarks_controller.dart';
import '../../news/controller/news_controller.dart';
import '../../clips/controller/clips_controller.dart';
import '../../replay/controller/replay_controller.dart';
import '../../live/live_dashboard/controller/live_controller.dart';
import '../controller/live_tv_controller.dart';
import '../controller/live_game_controller.dart';
import '../model/live_tv_model.dart';

class ContentSection extends StatelessWidget {
  ContentSection({super.key});

  // final List<String> _videoUrls = [
  //   'https://media.streambrothers.com:2000/VideoPlayer/hpgnrhawxv2?autoplay=1',
  //   'https://media.streambrothers.com:2000/VideoPlayer/hpgnrhawxv?autoplay=1',
  //   'https://media.streambrothers.com:2000/VideoPlayer/hpgnrhawxv2?autoplay=1',
  // ];

  // final List<String> _videoTitles = [
  //   'Live TV Channel 1',
  //   'Live TV Channel 2',
  //   'Live TV Channel 3',
  // ];



  @override
  Widget build(BuildContext context) {
    final NewsController newsController = Get.put(NewsController());
    final ClipsController clipsController = Get.put(ClipsController());
    final ReplayController replayController = Get.put(ReplayController());
    final LiveMatchesController liveController = Get.put(
      LiveMatchesController(),
    );
    final LiveTvController liveTvController = Get.put(LiveTvController());
    final LiveGameController liveGameController = Get.put(LiveGameController());

    // Fetch upcoming if empty
    if (liveController.upcomingMatches.isEmpty &&
        !liveController.isUpcomingLoading) {
      liveController.fetchUpcomingMatches();
    }
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
          child: Obx(() {
            if (liveGameController.isLoading.value &&
                liveGameController.liveGames.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (liveGameController.liveGames.isEmpty) {
              return const Center(
                child: Text("No live games currently",
                    style: TextStyle(color: Colors.white54)),
              );
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: liveGameController.liveGames.length,
              itemBuilder: (context, index) {
                final game = liveGameController.liveGames[index];
                
                // Sanitize thumbnail URL
                final imageUrl = game.thumbnail
                    .replaceAll('localhost', '10.0.30.59')
                    .replaceAll('127.0.0.1', '10.0.30.59')
                    .replaceFirst('undefined/', 'http://10.0.30.59:8000/');

                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: LiveCard(
                    imagePath: imageUrl,
                    viewerCount: "${game.viewers}",
                    title: game.title,
                    description: game.commentary,
                    isLocked: game.isPremium,
                    onTap: () {
                      liveGameController.fetchLiveGameById(game.id);
                      Get.to(() => const OpenLiveGame());
                    },
                  ),
                );
              },
            );
          }),
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
          child: Obx(() {
            if (liveTvController.isLoading.value &&
                liveTvController.liveTvs.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (liveTvController.liveTvs.isEmpty) {
              return const SizedBox();
            }

            return SizedBox(
              height: 70.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: liveTvController.liveTvs.length,
                itemBuilder: (context, index) {
                  final tv = liveTvController.liveTvs[index];
                  return Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: _buildTVChannel(tv),
                  );
                },
              ),
            );
          }),
        ),

        SizedBox(height: 26.h),

        // Upcoming section
        _sectionName("Upcoming", () {
          Get.to(
            () => LiveMatchesScreen(initialTab: 1), // Upcoming tab index
          );
        }),

        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GetBuilder<LiveMatchesController>(
            builder: (controller) {
              if (controller.isUpcomingLoading &&
                  controller.upcomingMatches.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }

              if (controller.upcomingMatches.isEmpty) {
                return const SizedBox();
              }

              final displayMatches = controller.upcomingMatches.length > 3
                  ? controller.upcomingMatches.sublist(0, 3)
                  : controller.upcomingMatches;

              return Column(
                children: displayMatches.map((match) {
                  final bookmarkController =
                      Get.isRegistered<BookmarkController>()
                      ? Get.find<BookmarkController>()
                      : Get.put(BookmarkController());

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Obx(() {
                      final isBookmarked = bookmarkController.isMatchBookmarked(
                        match.id,
                      );
                      return Dismissible(
                        key: Key("home_upcoming_${match.id}"),
                        direction: DismissDirection.startToEnd,
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            bookmarkController.toggleMatchBookmark(match.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isBookmarked
                                      ? "Match unbookmarked!"
                                      : "Match bookmarked!",
                                ),
                                duration: const Duration(seconds: 1),
                                backgroundColor: isBookmarked
                                    ? Colors.redAccent
                                    : Colors.green,
                              ),
                            );
                          }
                          return false;
                        },
                        background: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          margin: const EdgeInsets.only(bottom: 12),
                          // decoration: BoxDecoration(
                          //   color: isBookmarked
                          //       ? Colors.redAccent.withOpacity(0.8)
                          //       : Colors.amber.withOpacity(0.8),
                          //   borderRadius: BorderRadius.circular(12),
                          // ),
                          child: Icon(
                            isBookmarked
                                ? Icons.delete_outlined
                                : Icons.bookmark_add_outlined,
                            color: isBookmarked
                                ? Colors.redAccent.withOpacity(0.8)
                                : Colors.amber.withOpacity(0.8),
                            size: 28,
                          ),
                        ),
                        child: UpcomingMatchCard(
                          homeLogo: match.homeLogo,
                          awayLogo: match.awayLogo,
                          league: match.dayHeader, // "Wednesday" or similar
                          match: "${match.homeTeam} vs ${match.awayTeam}",
                          time: match.date, // e.g. "20:00"
                          isHighlighted: controller.remindedMatchIds.contains(
                            match.id,
                          ),
                          isBookmarked: isBookmarked,
                          onRemindTap: () =>
                              controller.toggleReminder(match.id),
                        ),
                      );
                    }),
                  );
                }).toList(),
              );
            },
          ),
        ),
        SizedBox(height: 16.h),

        // Replay Section
        _sectionName("Replay", () {
          Get.to(ReplayScreen());
        }),
        SizedBox(height: 16.h),

        Obx(() {
          if (replayController.isLoading.value &&
              replayController.replaysList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (replayController.replaysList.isEmpty) {
            return const SizedBox();
          }

          return SizedBox(
            height: 222.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: replayController.replaysList.length > 5
                  ? 5
                  : replayController.replaysList.length,
              itemBuilder: (context, index) {
                final replay = replayController.replaysList[index];
                final imageUrl = replay.thumbnailUrl
                    .replaceAll('localhost', '10.0.30.59')
                    .replaceAll('127.0.0.1', '10.0.30.59');

                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Container(
                    height: 222.h,
                    width: 211.w,
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(width: 1, color: Colors.white10),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(VideoLiveScreen(replayId: replay.replayId));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thumbnail
                          Container(
                            height: 122.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.play_circle_outline,
                                color: Colors.white54,
                                size: 40,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // Replay Info
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                replay.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                children: [
                                  Text(
                                    replay.formattedViews,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    replay.timeAgo,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 11.sp,
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
          );
        }),
        SizedBox(height: 24.h),

        // Clips Section
        _sectionName('Clips', () => Get.to(() => ClipsScreen())),
        SizedBox(height: 16.h),

        // Horizontal Clips List
        Obx(() {
          if (clipsController.isLoading.value &&
              clipsController.clipsList.isEmpty) {
            return SizedBox(
              height: 280.h,
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          if (clipsController.clipsList.isEmpty) {
            return const SizedBox();
          }

          return SizedBox(
            height: 280.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: clipsController.clipsList.length > 5
                  ? 5
                  : clipsController.clipsList.length,
              itemBuilder: (context, index) {
                final clip = clipsController.clipsList[index];
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        OpenReelsVideo(
                          clips: clipsController.clipsList,
                          initialIndex: index,
                        ),
                      );
                    },
                    child: Container(
                      width: 180.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[900],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              clip.videoUrl
                                  .replaceAll('localhost', '10.0.30.59')
                                  .replaceAll('127.0.0.1', '10.0.30.59'),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                            ),
                            Container(
                              decoration: BoxDecoration(
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
                            ),
                            Positioned(
                              bottom: 12.h,
                              left: 12.w,
                              right: 12.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    clip.title,
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
                                    clip.formattedViews,
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
          );
        }),
        SizedBox(height: 24.h),

        // Latest News Section
        _sectionName('Latest News', () => Get.to(() => NewsScreen())),
        SizedBox(height: 16.h),

        // Latest News Section
        Obx(() {
          if (newsController.isLoading.value) {
            return SizedBox(
              height: 120.h,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
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
                        Get.to(NewsDetailsScreen(article: article));
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
                                          '${article.viewCount ?? 0} read',
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

  Widget _buildTVChannel(LiveTvModel tv) {
    final imageUrl = tv.thumbnail
        .replaceAll('localhost', '10.0.30.59')
        .replaceAll('127.0.0.1', '10.0.30.59')
        .replaceAll('undefined/', 'http://10.0.30.59:8000/');

    return GestureDetector(
      onTap: () {
        final liveTvController = Get.find<LiveTvController>();
        liveTvController.selectedLiveTv.value = tv;
        Get.to(() => OpenTvs());
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 90,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 90,
            height: 60,
            color: Colors.grey[800],
            child: const Icon(Icons.tv, color: Colors.white54),
          ),
        ),
      ),
    );
  }
}
