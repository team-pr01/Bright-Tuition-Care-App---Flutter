import 'package:flutter/material.dart';
import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/skeleton/shimmer_wrapper.dart';
import 'package:btcclient/core/widgets/skeleton/skeleton_box.dart';

class JobCardSkeleton extends StatelessWidget {
  const JobCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary01.withOpacity(.15),
        ),
      ),
      child: ShimmerWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonBox(width: 220, height: 18),
                      SizedBox(height: 10),
                      SkeletonBox(width: 120, height: 14),
                    ],
                  ),
                ),

                const SkeletonBox(
                  width: 60,
                  height: 60,
                ),
              ],
            ),

            const SizedBox(height: 16),

            const SkeletonBox(width: 180, height: 12),

            const SizedBox(height: 20),

            const SkeletonBox(height: 14),

            const SizedBox(height: 14),

            Row(
              children: const [
                Expanded(
                  child: SkeletonBox(height: 14),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: SkeletonBox(height: 14),
                ),
              ],
            ),

            const SizedBox(height: 14),

            const SkeletonBox(height: 14),

            const SizedBox(height: 14),

            const SkeletonBox(height: 14),

            const SizedBox(height: 22),

            Row(
              children: const [
                SkeletonBox(width: 70, height: 16),
                SizedBox(width: 16),
                SkeletonBox(width: 60, height: 16),
                Spacer(),
                SkeletonBox(width: 120, height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}