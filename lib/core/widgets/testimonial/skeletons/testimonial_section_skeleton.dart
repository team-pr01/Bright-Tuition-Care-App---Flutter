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

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: index == 0 ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}