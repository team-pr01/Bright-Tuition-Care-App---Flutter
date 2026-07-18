import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/skeleton/shimmer_wrapper.dart';
import 'package:btcclient/core/widgets/skeleton/skeleton_box.dart';
import 'package:flutter/material.dart';

class DashboardLargeCardSkeleton extends StatelessWidget {
  const DashboardLargeCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary03,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            /// LEFT CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonBox(
                    width: 120,
                    height: 16,
                  ),

                  SizedBox(height: 10),

                  SkeletonBox(
                    width: 70,
                    height: 28,
                  ),

                  SizedBox(height: 12),

                  SkeletonBox(
                    width: double.infinity,
                    height: 12,
                  ),

                  SizedBox(height: 8),

                  SkeletonBox(
                    width: 180,
                    height: 12,
                  ),

                  SizedBox(height: 14),

                  SkeletonBox(
                    width: 80,
                    height: 14,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            /// RIGHT ILLUSTRATION
            const SkeletonBox(
              width: 80,
              height: 80,
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}