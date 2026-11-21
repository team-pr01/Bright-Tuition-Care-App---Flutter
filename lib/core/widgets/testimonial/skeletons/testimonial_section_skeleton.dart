import 'package:btcclient/core/widgets/testimonial/skeletons/testimonial_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:btcclient/core/config/theme.dart';

class TestimonialSectionSkeleton extends StatelessWidget {
  const TestimonialSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 160,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: TestimonialCardSkeleton(),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

       
      ],
    );
  }
}