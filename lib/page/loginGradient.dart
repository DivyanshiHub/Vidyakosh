import 'package:flutter/material.dart';

class BackgroundGradientPage extends StatelessWidget {
  final Widget child;
  const BackgroundGradientPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFB0B0B0), // light grey (silver)
            Color(0xFF5A5A5A), // medium-dark grey
            Color(0xFF2C2C2C), // charcoal black
            Color(0xFFD32F2F), // red accent
          ],
          stops: [0.1, 0.3,0.8, 1.0],
          begin: Alignment.topRight,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
