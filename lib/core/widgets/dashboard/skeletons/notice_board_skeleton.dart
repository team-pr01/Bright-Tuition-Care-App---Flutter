import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/skeleton/shimmer_wrapper.dart';
import 'package:btcclient/core/widgets/skeleton/skeleton_box.dart';
import 'package:btcclient/core/widgets/skeleton/skeleton_circle.dart';
import 'package:flutter/material.dart';

class NoticeBoardSkeleton extends StatelessWidget {
  const NoticeBoardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primary01.withOpacity(.25),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: const [
                SkeletonCircle(size: 24),
                SizedBox(width: 8),
                SkeletonBox(
                  width: 120,
                  height: 18,
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// NOTICE TITLE
            const SkeletonBox(
              width: 180,
              height: 16,
            ),

            const SizedBox(height: 10),

            /// MESSAGE
            const SkeletonBox(
              width: double.infinity,
              height: 12,
            ),

            const SizedBox(height: 8),

            const SkeletonBox(
              width: double.infinity,
              height: 12,
            ),

            const SizedBox(height: 8),

            /// READ MORE
            const SkeletonBox(
              width: 70,
              height: 12,
            ),

            const SizedBox(height: 18),

            /// DOT INDICATOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(width: 6),

                const SkeletonCircle(size: 6),

                const SizedBox(width: 6),

                const SkeletonCircle(size: 6),
              ],
            ),
          ],
        ),
      ),
    );
  }
}