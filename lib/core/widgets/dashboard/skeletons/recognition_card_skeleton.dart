import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/skeleton/shimmer_wrapper.dart';
import 'package:btcclient/core/widgets/skeleton/skeleton_box.dart';
import 'package:flutter/material.dart';

class RecognitionCardSkeleton extends StatelessWidget {
  const RecognitionCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    ShimmerWrapper(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 9,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary03,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: const [
                SkeletonBox(
                  width: 24,
                  height: 24,
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),

                SizedBox(width: 6),

                SkeletonBox(
                  width: 110,
                  height: 18,
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// INNER CARD
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PROFILE IMAGE
                  const SkeletonBox(
                    width: 70,
                    height: 70,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// DETAILS
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: const [
                        SkeletonBox(
                          width: 170,
                          height: 16,
                        ),

                        SizedBox(height: 8),

                        Row(
                          children: [
                            SkeletonBox(
                              width: 60,
                              height: 12,
                            ),

                            SizedBox(width: 12),

                            SkeletonBox(
                              width: 40,
                              height: 12,
                            ),
                          ],
                        ),

                        SizedBox(height: 8),

                        SkeletonBox(
                          width: 140,
                          height: 12,
                        ),

                        SizedBox(height: 8),

                        SkeletonBox(
                          width: 90,
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}