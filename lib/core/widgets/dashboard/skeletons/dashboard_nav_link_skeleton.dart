import 'package:btcclient/core/widgets/skeleton/shimmer_wrapper.dart';
import 'package:btcclient/core/widgets/skeleton/skeleton_box.dart';
import 'package:btcclient/core/widgets/skeleton/skeleton_circle.dart';
import 'package:flutter/material.dart';

class DashboardNavLinkSkeleton extends StatelessWidget {
  const DashboardNavLinkSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Column(
        children: const [

          SkeletonCircle(size: 52),

          SizedBox(height: 8),

          SkeletonBox(
            width: 48,
            height: 10,
          ),

          SizedBox(height: 6),

          SkeletonBox(
            width: 26,
            height: 10,
          ),
        ],
      ),
    );
  }
}