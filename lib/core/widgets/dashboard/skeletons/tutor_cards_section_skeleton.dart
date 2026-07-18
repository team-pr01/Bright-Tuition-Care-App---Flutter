import 'package:flutter/material.dart';
import 'dashboard_large_card_skeleton.dart';
import 'dashboard_small_card_skeleton.dart';

class TutorCardsSectionSkeleton extends StatelessWidget {
  const TutorCardsSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        /// TOP TWO CARDS
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: DashboardSmallCardSkeleton(),
              ),

              SizedBox(width: 12),

              Expanded(
                child: DashboardSmallCardSkeleton(),
              ),
            ],
          ),
        ),

        SizedBox(height: 14),

        /// CONFIRMATION LETTER
        DashboardLargeCardSkeleton(),

        SizedBox(height: 14),

        /// INVOICES
        DashboardLargeCardSkeleton(),
      ],
    );
  }
}