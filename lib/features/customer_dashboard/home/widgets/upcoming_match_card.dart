import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpcomingMatchCard extends StatelessWidget {
  final String? homeLogo;
  final String? awayLogo;
  final String? imagePath; // Kept for compatibility but optional now
  final String league;
  final String match;
  final String time;
  final bool isBookmarked;

  const UpcomingMatchCard({
    super.key,
    this.homeLogo,
    this.awayLogo,
    this.imagePath,
    required this.league,
    required this.match,
    required this.time,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        //color: const Color(0xFF1C1F26),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          /// Match logos (Row of two smaller logos)
          Row(
            children: [
              _buildSmallLogo(homeLogo ?? imagePath ?? ''),
              SizedBox(width: 4.w),
              _buildSmallLogo(awayLogo ?? ''),
            ],
          ),

          SizedBox(width: 12.w),

          /// Match details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      league,
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (isBookmarked)
                      Icon(Icons.bookmark, color: Colors.amber, size: 16.sp),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  match,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          /// Time section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    time,
                    style: TextStyle(color: Colors.white, fontSize: 10.sp),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallLogo(String url) {
    if (url.isEmpty) return const SizedBox.shrink();

    return Container(
      width: 28.w,
      height: 28.w,
      padding: EdgeInsets.all(2.r),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: url.startsWith('http')
            ? Image.network(
                url
                    .replaceAll('localhost', '10.0.30.59')
                    .replaceAll('127.0.0.1', '10.0.30.59'),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.sports_soccer,
                  size: 16,
                  color: Colors.grey,
                ),
              )
            : Image.asset(
                url,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.sports_soccer,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
      ),
    );
  }
}
