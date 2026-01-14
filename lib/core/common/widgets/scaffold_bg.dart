import 'package:flutter/material.dart';

class ScaffoldBg extends StatelessWidget {
  final Widget child;
  const ScaffoldBg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3A0F0F), Color(0xFF0B0B0B), Color(0xFF000000)],
        ),
      ),
      child: child,
    );
  }
}
