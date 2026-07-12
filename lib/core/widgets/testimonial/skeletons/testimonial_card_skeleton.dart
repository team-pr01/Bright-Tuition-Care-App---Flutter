import 'package:btcclient/core/widgets/skeleton/shimmer_wrapper.dart';
import 'package:btcclient/core/widgets/skeleton/skeleton_box.dart';
import 'package:btcclient/core/widgets/skeleton/skeleton_circle.dart';
import 'package:flutter/material.dart';
import 'package:btcclient/core/config/theme.dart';

class TestimonialCardSkeleton extends StatelessWidget {
  const TestimonialCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        height: 148,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonCircle(size: 96),

            const SizedBox(width: AppSpacing.sm),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonBox(width: 140, height: 18),

                  SizedBox(height: 8),

                  SkeletonBox(width: 90, height: 14),

                  SizedBox(height: 14),

                  SkeletonBox(width: double.infinity, height: 12),

                  SizedBox(height: 8),

                  SkeletonBox(width: double.infinity, height: 12),

                  SizedBox(height: 8),

                  SkeletonBox(width: 120, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
