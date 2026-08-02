import 'dart:math' as math;

import 'package:flutter/material.dart';

class ProgressDotPainter extends CustomPainter {
  final double progress;

  ProgressDotPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;

    final angle = (-90 + (360 * progress)) * math.pi / 180;

    final center = Offset(
      radius + radius * math.cos(angle),
      radius + radius * math.sin(angle),
    );

    canvas.drawCircle(
      center,
      4,
      Paint()..color = const Color(0xffF9C623),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}