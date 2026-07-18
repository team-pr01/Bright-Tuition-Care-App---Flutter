import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/skeleton/shimmer_wrapper.dart';
import 'package:btcclient/core/widgets/skeleton/skeleton_box.dart';
import 'package:flutter/material.dart';

class VerifyProfileCardSkeleton extends StatelessWidget {
  const VerifyProfileCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary03,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ShimmerWrapper(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.neutrals05, width: 2),
          ),
          child: Column(
            children: [
              /// Shield Illustration
              const SkeletonBox(
                width: 70,
                height: 70,
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),

              const SizedBox(height: 16),

              /// Title
              const SkeletonBox(width: 170, height: 22),

              const SizedBox(height: 14),

              /// Description
              const SkeletonBox(width: double.infinity, height: 12),

              const SizedBox(height: 8),

              const SkeletonBox(width: double.infinity, height: 12),

              const SizedBox(height: 8),

              const SkeletonBox(width: 220, height: 12),

              const SizedBox(height: 20),

              /// Verify Button
              const SkeletonBox(
                width: 120,
                height: 38,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
