import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/skeleton/shimmer_wrapper.dart';
import 'package:btcclient/core/widgets/skeleton/skeleton_box.dart';
import 'package:btcclient/core/widgets/skeleton/skeleton_circle.dart';
import 'package:flutter/material.dart';

class DashboardSmallCardSkeleton extends StatelessWidget {
  const DashboardSmallCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary03,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row (Title + Icon)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SkeletonBox(
                  width: 70,
                  height: 28,
                ),

                SkeletonCircle(size: 42),
              ],
            ),

            const SizedBox(height: 14),

            /// Subtitle
            const SkeletonBox(
              width: 90,
              height: 14,
            ),

            const SizedBox(height: 10),

            /// Description line 1
            const SkeletonBox(
              width: double.infinity,
              height: 12,
            ),

            const SizedBox(height: 8),

            /// Description line 2
            const SkeletonBox(
              width: 120,
              height: 12,
            ),

            const Spacer(),

            /// Action
            Align(
              alignment: Alignment.centerRight,
              child: SkeletonBox(
                width: 55,
                height: 12,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}