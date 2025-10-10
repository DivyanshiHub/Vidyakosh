import 'dart:ui';
import 'package:flutter/material.dart';

class GlassButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const GlassButton({super.key, required this.text, required this.onPressed});

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        Future.delayed(const Duration(milliseconds: 150), () {
          setState(() => _pressed = false);
          widget.onPressed();
        });
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0, // shrink effect on press
        duration: const Duration(milliseconds: 150),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFB0B0B0), // light grey (silver)
                    Color(0xFF5A5A5A),
                    // Color(0xFF5A5A5A),
                    Color(0xFFB0B0B0),
                  ],
                  stops: [0.2,0.5,1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
              ),
              child: Center(
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // button text color
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
