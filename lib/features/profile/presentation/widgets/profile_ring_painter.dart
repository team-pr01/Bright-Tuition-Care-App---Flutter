import 'dart:math' as math;
import 'package:flutter/material.dart';

class ProfileRingPainter extends CustomPainter {
  final double progress;

  ProfileRingPainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 4.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth;

    final basePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = const Color(0xffF9C623)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, basePaint);

    const startAngle = -math.pi / 2;
    final sweepAngle = progress * 2 * math.pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    final angle = startAngle + sweepAngle;

    final dotCenter = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    canvas.drawCircle(
      dotCenter,
      4,
      Paint()..color = const Color(0xffF9C623),
    );
  }

  @override
  bool shouldRepaint(covariant ProfileRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}