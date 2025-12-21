import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Widget? leading;
  final Color? color;
  final double vertical;
  final Color? textColor;
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.leading,
    this.vertical = 12.0,
    this.color = const Color(0xFF1B6EF7),

    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 360,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: color ?? AppColors.primaryButtonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 2,
              offset: Offset(0, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) ...[leading!, SizedBox(width: 8)],
            Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600, // Closest to w590
                height: 1.71,
                letterSpacing: 0.20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
