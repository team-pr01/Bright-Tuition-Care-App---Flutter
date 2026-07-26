import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/skeleton/shimmer_wrapper.dart';
import 'package:btcclient/core/widgets/skeleton/skeleton_box.dart';
import 'package:flutter/material.dart';

class InvoiceCardSkeleton extends StatelessWidget {
  const InvoiceCardSkeleton({super.key});

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
          border: Border.all(color: AppColors.primary01.withOpacity(.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= HEADER =================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonBox(
                  width: 54,
                  height: 54,
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonBox(width: 170, height: 18),
                      SizedBox(height: 8),
                      SkeletonBox(width: 130, height: 14),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                const SkeletonBox(
                  width: 70,
                  height: 28,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Divider(),

            const SizedBox(height: 18),

            _SkeletonInfoRow(),
            SizedBox(height: 12),
            _SkeletonInfoRow(),
            SizedBox(height: 12),
            _SkeletonInfoRow(),
            SizedBox(height: 12),
            _SkeletonInfoRow(),

            SizedBox(height: 24),

            const SkeletonBox(
              width: double.infinity,
              height: 48,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonInfoRow extends StatelessWidget {
  const _SkeletonInfoRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SkeletonBox(width: 90, height: 14),
        Spacer(),
        SkeletonBox(width: 120, height: 14),
      ],
    );
  }
}
