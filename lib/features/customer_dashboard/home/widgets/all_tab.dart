import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testapp/core/const/app_colors.dart';
import 'package:testapp/features/customer_dashboard/home/widgets/upcoming_match_card.dart';
import 'package:testapp/features/customer_dashboard/clips/widgets/video_thumbnail_widget.dart';
import 'package:testapp/core/utils/url_helper.dart';
import 'package:testapp/core/utils/video_resource_manager.dart';

import '../../clips/screen/clips_screen.dart';
import '../../live/live_dashboard/screen/live_screen.dart';
import '../../live/live_dashboard/screen/match_details_screen.dart';
import '../../live/live_video/screen/video_screen.dart';
import '../../news/view/news_screen.dart';
import '../../replay/view/replay_screen.dart';
import '../view/news_details_screen.dart';
import '../view/open_reels_video.dart';
import '../view/open_tvs.dart';
import '../view/open_live_games.dart';
import '../../subscription/view/subscription_screen.dart';
import 'live_card.dart';
import '../../profile/controller/bookmarks_controller.dart';
import '../../news/controller/news_controller.dart';
import '../../clips/controller/clips_controller.dart';
import '../../replay/controller/replay_controller.dart';
import '../../live/live_dashboard/controller/live_controller.dart';
import '../controller/live_tv_controller.dart';
import '../controller/live_game_controller.dart';
import '../model/live_tv_model.dart';
import '../../profile/controller/profile_controller.dart';

class ContentSection extends StatelessWidget {
  ContentSection({super.key});

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
    final ProfileController profileController = Get.put(ProfileController());

    // Fetch upcoming if empty
    if (liveController.upcomingMatches.isEmpty &&
        !liveController.isUpcomingLoading) {
      liveController.fetchUpcomingMatches();
    }

    // NEW: Fetch live TVs if empty
    if (liveTvController.liveTvs.isEmpty && !liveTvController.isLoading.value) {
      liveTvController.fetchLiveTvs();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Live Now section - View All removed as requested
        _sectionName("Live Now", () {
          Get.to(LiveMatchesScreen());
        }, showViewAll: false),
        SizedBox(height: 16.h),

        // Horizontal Scrollable Live Now List
        SizedBox(
          height: 200.h,
          child: Obx(() {
            if (liveGameController.isLoading.value &&
                liveGameController.liveGames.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (liveGameController.liveGames.isEmpty) {
              return const Center(
                child: Text(
                  "No live games available at the moment",
                  style: TextStyle(color: Colors.white54),
                ),
              );
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: liveGameController.liveGames.length,
              itemBuilder: (context, index) {
                final game = liveGameController.liveGames[index];
                final isUserPremium =
                    profileController.profile.value?.isPremiumUser ?? false;
                final bool isLocked = game.isPremium && !isUserPremium;

                // Sanitize thumbnail URL
                final imageUrl = UrlHelper.sanitizeUrl(game.thumbnail);

                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: LiveCard(
                    imagePath: imageUrl,
                    viewerCount: "${game.viewers}",
                    title: game.title,
                    description: game.commentary,
                    isLocked: isLocked,
                    opponent01: game.opponent01,
                    opponent02: game.opponent02,
                    dateTime: game.dateTime,
                    onTap: () async {
                      if (isLocked) {
                        _showPremiumRequiredDialog();
                        return;
                      }
                      if (game.liveTVId.isNotEmpty) {
                        try {
                          final tv = liveTvController.liveTvs.firstWhere(
                            (t) => t.id == game.liveTVId,
                          );
                          liveTvController.selectedLiveTv.value = tv;
                        } catch (e) {
                          liveTvController.selectedLiveTv.value = null;
                          await liveTvController.fetchLiveTvById(game.liveTVId);
                        }
                        Get.to(() => OpenTvs());
                      } else {
                        liveGameController.fetchLiveGameById(game.id);
                        Get.to(() => const OpenLiveGame());
                      }
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
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (liveTvController.liveTvs.isEmpty) {
              return const Center(
                child: Text(
                  "No channels available",
                  style: TextStyle(color: Colors.white54),
                ),
              );
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
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.h),
                  child: const Center(
                    child: Text(
                      "No upcoming matches available",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                );
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
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              () => MatchDetailsScreen(
                                matchId: match.id,
                                homeTeam: match.homeTeam,
                                awayTeam: match.awayTeam,
                                homeScore: int.tryParse(match.homeScore) ?? 0,
                                awayScore: int.tryParse(match.awayScore) ?? 0,
                                matchTitle:
                                    "${match.homeTeam} vs ${match.awayTeam}",
                              ),
                            );
                          },
                          child: UpcomingMatchCard(
                            homeLogo: match.homeLogo,
                            awayLogo: match.awayLogo,
                            league: match.dayHeader, // "Wednesday" or similar
                            match: "${match.homeTeam} vs ${match.awayTeam}",
                            time: match.date, // e.g. "20:00"
                            isBookmarked: isBookmarked,
                          ),
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
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final bool isPremium =
              profileController.profile.value?.isPremiumUser ?? false;
          final bool isPremiumError =
              replayController.errorMessage.value.toLowerCase().contains(
                "premium",
              ) ||
              replayController.errorMessage.value.toLowerCase().contains(
                "subscription",
              ) ||
              replayController.errorMessage.value.toLowerCase().contains(
                "active",
              );

          // Show premium placeholder if not premium OR if we got a premium-related error
          if (!isPremium || isPremiumError) {
            // Only show placeholder if the list is actually empty (which it should be for non-premium)
            if (replayController.replaysList.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: _buildPremiumReplayCard(),
              );
            }
          }

          if (replayController.replaysList.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: const Center(
                child: Text(
                  "No replays available",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            );
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
                final imageUrl = UrlHelper.sanitizeUrl(replay.thumbnailUrl);

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
                        Get.to(
                          () => VideoLiveScreen(replayId: replay.replayId),
                        )?.then((_) {
                          // Re-initialize released thumbnails
                          VideoResourceManager().reInitializeThumbnails();
                          // Refresh this specific replay item to update view counts/likes upon return
                          replayController
                              .fetchSingleReplay(replay.replayId)
                              .then((updated) {
                                if (updated != null) {
                                  final index = replayController.replaysList
                                      .indexWhere(
                                        (r) => r.replayId == replay.replayId,
                                      );
                                  if (index != -1) {
                                    replayController.replaysList[index] =
                                        updated;
                                    replayController.replaysList.refresh();
                                  }
                                }
                              });
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thumbnail
                          Container(
                            height: 122.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[850],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  Image.network(
                                    imageUrl,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            color: Colors.grey[850],
                                          );
                                        },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Colors.grey[800],
                                              child: const Icon(
                                                Icons.image,
                                                color: Colors.white24,
                                              ),
                                            ),
                                  ),
                                  const Center(
                                    child: Icon(
                                      Icons.play_circle_outline,
                                      color: Colors.white54,
                                      size: 40,
                                    ),
                                  ),
                                ],
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
        _sectionName('Clips', () {
          VideoResourceManager().releaseAllThumbnails();
          Get.to(() => ClipsScreen());
        }),
        SizedBox(height: 16.h),

        // Horizontal Clips List
        Obx(() {
          if (clipsController.isLoading.value &&
              clipsController.clipsList.isEmpty) {
            return SizedBox(
              height: 280.h,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
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
                        () => OpenReelsVideo(
                          clips: clipsController.clipsList,
                          initialIndex: index,
                        ),
                      )?.then((_) {
                        // Re-initialize released thumbnails
                        VideoResourceManager().reInitializeThumbnails();
                        // Refresh this specific clip to update views/likes on home screen return
                        clipsController.fetchSingleClip(clip.clipId).then((
                          updated,
                        ) {
                          if (updated != null) {
                            final idx = clipsController.clipsList.indexWhere(
                              (c) => c.clipId == clip.clipId,
                            );
                            if (idx != -1) {
                              clipsController.clipsList[idx] = updated;
                              clipsController.clipsList.refresh();
                            }
                          }
                        });
                      });
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
                            VideoThumbnailWidget(
                              videoUrl: UrlHelper.sanitizeUrl(clip.videoUrl),
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

  Padding _sectionName(
    String label,
    VoidCallback? onTap, {
    bool showViewAll = true,
  }) {
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
          if (showViewAll)
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

  Widget _buildPremiumReplayCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          colors: [const Color(0xFF1E1E1E), const Color(0xFF2D2D2D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_person_rounded,
              color: AppColors.primaryColor,
              size: 32.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Premium Required",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Subscribe to watch exclusive match replays",
                  style: TextStyle(color: Colors.grey[400], fontSize: 12.sp),
                ),
                SizedBox(height: 12.h),
                InkWell(
                  onTap: () => Get.to(() => const SubscriptionPage()),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Text(
                      "Upgrade Now",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTVChannel(LiveTvModel tv) {
    final profileController = Get.find<ProfileController>();
    final isUserPremium =
        profileController.profile.value?.isPremiumUser ?? false;
    final bool isLocked = tv.isPremium && !isUserPremium;

    final imageUrl = tv.thumbnail
        .replaceAll('localhost', '10.0.30.59')
        .replaceAll('127.0.0.1', '10.0.30.59')
        .replaceAll('undefined/', 'http://10.0.30.59:8000/');

    return GestureDetector(
      onTap: () {
        if (isLocked) {
          _showPremiumRequiredDialog();
          return;
        }
        final liveTvController = Get.find<LiveTvController>();
        liveTvController.selectedLiveTv.value = tv;
        Get.to(() => OpenTvs());
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 90,
              height: 60,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 90,
                  height: 60,
                  color: Colors.grey[800],
                  child: const Icon(Icons.tv, color: Colors.white54),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                width: 90,
                height: 60,
                color: Colors.grey[800],
                child: const Icon(Icons.tv, color: Colors.white54),
              ),
            ),
          ),
          if (isLocked)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.lock, color: Colors.white, size: 20),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPromoCard() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: AssetImage('assets/images/spain.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Gradient Overlay to make text pop
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'BRAZIL VS SPAIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCountdownBox("12H"),
                    _buildCountdownBox("12M"),
                    _buildCountdownBox("12S"),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'BIG GAME || World Cup',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownBox(String val) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        val,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showPremiumRequiredDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_person_rounded,
                  color: AppColors.primaryColor,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Premium Required",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "This content is only available for premium subscribers. Upgrade your plan to enjoy exclusive live matches and channels.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.to(() => const SubscriptionPage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Upgrade Now",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
