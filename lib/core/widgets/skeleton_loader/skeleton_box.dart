import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonBox extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;
  final bool shimmer;
  final Duration duration;

  const SkeletonBox({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.borderRadius,
    this.shimmer = false,
    this.duration = const Duration(milliseconds: 700),
  });

  @override
  Widget build(BuildContext context) {
    final box = Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );

    if (!shimmer) return box;

    return Shimmer.fromColors(
      period: duration,
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: box,
    );
  }
}