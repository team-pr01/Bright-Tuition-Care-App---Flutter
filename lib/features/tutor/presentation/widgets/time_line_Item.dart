import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/models/how_it_works_model.dart';
import 'package:flutter/material.dart';

class TimelineItem extends StatelessWidget {
  final HowItWorksStep step;
  final bool isLast;

  const TimelineItem({
    required this.step,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔵 LEFT TIMELINE
        Column(
          children: [

            /// ICON CIRCLE
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary01,
                shape: BoxShape.circle,
              ),
              child: Icon(
                step.icon,
                color: Colors.white,
                size: 20,
              ),
            ),

            /// LINE
            if (!isLast)
              Container(
                width: 2,
                height: 80,
                color: Colors.grey[300],
              ),
          ],
        ),

        const SizedBox(width: 12),

        /// 🔹 CONTENT CARD
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary01.withOpacity(0.3)),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// STEP LABEL
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary03,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    step.step,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  ),
                ),

                const SizedBox(height: 8),

                /// TITLE
                Text(
                  step.title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),

                const SizedBox(height: 6),

                /// DESCRIPTION
                Text(
                  step.description,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.neutrals03,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}