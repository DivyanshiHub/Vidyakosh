import 'package:flutter/material.dart';

class homeGradient extends StatelessWidget {
  final Widget child;
  const homeGradient({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE0E0E0), // Light grey (softer top for readability)
            Color(0xFF757575), // Medium grey
            Color(0xFF212121), // Almost black (smooth middle contrast)
            Color(0xFFB71C1C), // Softer deep red (less harsh than D32F2F)
          ],
          stops: [0.05, 0.35, 0.7, 1.0], // smoother blending
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
