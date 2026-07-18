import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/skeleton/shimmer_wrapper.dart';
import 'package:btcclient/core/widgets/skeleton/skeleton_box.dart';
import 'package:flutter/material.dart';

class LeadCardSkeleton extends StatelessWidget {
  const LeadCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.neutrals01,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(
            color: AppColors.neutrals04,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, .05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: const [
                SkeletonBox(
                  width: 110,
                  height: 18,
                ),
                Spacer(),
                SkeletonBox(
                  width: 70,
                  height: 28,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            /// Phone
            Row(
              children: const [
                SkeletonBox(
                  width: 18,
                  height: 18,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                SizedBox(width: 8),
                SkeletonBox(
                  width: 170,
                  height: 20,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            /// Class + Date
            Row(
              children: const [
                Expanded(
                  child: _InfoTileSkeleton(),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _InfoTileSkeleton(),
                ),
              ],
            ),

            const _InfoTileSkeleton(),
            const _InfoTileSkeleton(),
            const _InfoTileSkeleton(),

            const SizedBox(height: AppSpacing.lg),

            const SkeletonBox(
              width: double.infinity,
              height: 46,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTileSkeleton extends StatelessWidget {
  const _InfoTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SkeletonBox(
            width: 18,
            height: 18,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(
                  width: 70,
                  height: 12,
                ),
                SizedBox(height: 6),
                SkeletonBox(
                  width: double.infinity,
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}