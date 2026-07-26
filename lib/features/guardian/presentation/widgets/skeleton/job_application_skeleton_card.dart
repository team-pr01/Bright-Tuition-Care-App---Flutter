import 'package:btcclient/core/widgets/skeleton/shimmer_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/skeleton/skeleton_box.dart';
import 'package:btcclient/core/widgets/skeleton/skeleton_line.dart';

class JobApplicationSkeletonCard extends StatelessWidget {
  const JobApplicationSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary01,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary02.withOpacity(0.3),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            /// Name + Status
            Row(
              children: [
                Expanded(
                  child: SkeletonLine(width: double.infinity),
                ),
                SizedBox(width: 12),
                SkeletonBox(
                  width: 70,
                  height: 24,
                ),
              ],
            ),

            SizedBox(height: 18),

            SkeletonLine(width: 160),

            SizedBox(height: 18),

            /// Shortlisted + Appointed
            Row(
              children: [
                Expanded(
                  child: _IconRowSkeleton(),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _IconRowSkeleton(),
                ),
              ],
            ),

            SizedBox(height: 18),

            /// Confirmed + Cancelled
            Row(
              children: [
                Expanded(
                  child: _IconRowSkeleton(),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _IconRowSkeleton(),
                ),
              ],
            ),

            SizedBox(height: 20),

            Align(
              alignment: Alignment.centerRight,
              child: SkeletonLine(width: 70),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconRowSkeleton extends StatelessWidget {
  const _IconRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        SkeletonBox(
          width: 18,
          height: 18,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(width: 70),
              SizedBox(height: 6),
              SkeletonLine(width: 50),
            ],
          ),
        ),
      ],
    );
  }
}