import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveCard extends StatefulWidget {
  const LiveCard({
    super.key,
    required this.imagePath,
    required this.viewerCount,
    required this.title,
    required this.description,
    required this.isLocked,
    required this.opponent01,
    required this.opponent02,
    required this.dateTime,
    this.onTap,
  });

  final String imagePath;
  final String viewerCount;
  final String title;
  final String description;
  final bool isLocked;
  final String opponent01;
  final String opponent02;
  final DateTime dateTime;
  final VoidCallback? onTap;

  @override
  State<LiveCard> createState() => _LiveCardState();
}

class _LiveCardState extends State<LiveCard> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeLeft();
    });
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    final difference = widget.dateTime.difference(now);
    if (mounted) {
      setState(() {
        _timeLeft = difference.isNegative ? Duration.zero : difference;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLive = _timeLeft == Duration.zero;
    int hours = _timeLeft.inHours;
    int minutes = _timeLeft.inMinutes.remainder(60);
    int seconds = _timeLeft.inSeconds.remainder(60);

    return GestureDetector(
      onTap: isLive ? widget.onTap : null,
      child: Container(
        width: MediaQuery.of(context).size.width - 32.w,
        height: 199.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              widget.imagePath.startsWith('http') ||
                      widget.imagePath.startsWith('https')
                  ? Image.network(
                      widget.imagePath,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[850],
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white24,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.image, color: Colors.white24),
                      ),
                    )
                  : Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                    ),

              // Content overlay
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(flex: 3),
                  // Team VS Team
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "${widget.opponent01} VS ${widget.opponent02}".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 4,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(flex: 1),

                  // Countdown Timer or Live Now badge
                  if (isLive)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.6),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: Colors.white, size: 8.sp),
                          SizedBox(width: 6.w),
                          Text(
                            'LIVE NOW',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTimeBlock("${hours.toString().padLeft(2, '0')}H"),
                        SizedBox(width: 4.w),
                        _buildTimeBlock("${minutes.toString().padLeft(2, '0')}M"),
                        SizedBox(width: 4.w),
                        _buildTimeBlock("${seconds.toString().padLeft(2, '0')}S"),
                      ],
                    ),
                  Spacer(flex: 3),

                  // Title at Bottom
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 4,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Lock Icon if premium
              if (widget.isLocked)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.45),
                    child: Center(
                      child: Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 32.sp,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeBlock(String time) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Text(
        time,
        style: TextStyle(
          fontFamily: 'Oswald',
          fontSize: 32.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}