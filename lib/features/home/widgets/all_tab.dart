import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testapp/features/home/widgets/upcoming_match_card.dart';

import 'live_card.dart';

class LiveNowSection extends StatelessWidget {
  LiveNowSection({super.key});

  final List<String> _liveImages = [
    'assets/images/live01.png',
    'assets/images/live02.png',
    'assets/images/live01.png',
  ];

  // Viewer counts for each live stream
  final List<String> _viewerCounts = [
    '205K',
    '189K',
    '156K',
  ];

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Text(
                'Live Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'View All',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Horizontal Scrollable List
        SizedBox(
          height: 200.h, // Increased height to accommodate text below
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _liveImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: LiveCard(imagePath: _liveImages[index], viewerCount: _viewerCounts[index], title: _titles[index], description: _descriptions[index], isLocked: index == 0),
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
              _buildTVChannel('assets/images/tv01.png'),
              _buildTVChannel('assets/images/tv02.png'),
              _buildTVChannel('assets/images/tv03.png'),
            ],
          ),
        ),
        SizedBox(height: 26.h),

        // Upcoming section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Text(
                'Upcoming',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'View All',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
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
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildTVChannel(String imagePath) {
    return ClipRRect(
      child: Image.asset(
        imagePath,
        width: 90,
        fit: BoxFit.cover,
      ),
    );
  }
}



