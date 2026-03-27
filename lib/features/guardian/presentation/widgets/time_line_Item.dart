import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/models/how_it_works_model.dart';
import 'package:flutter/material.dart';

class TimelineItem extends StatelessWidget {
  final HowItWorksStep step;
  final bool isLast;

  const TimelineItem({
    super.key,
    required this.step,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// 🔵 ICON
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary01,
            shape: BoxShape.circle,
          ),
          child: Icon(
            step.icon,
            color: Colors.white,
            size: 24,
          ),
        ),

        const SizedBox(height: 12),

        /// 🔹 TITLE
        Text(
          step.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary01,
              ),
        ),

        const SizedBox(height: 8),

        /// 🔸 DESCRIPTION
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            step.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.neutrals03,
                ),
          ),
        ),

        const SizedBox(height: 20),

        // /// 🧵 CONNECTOR LINE
        // if (!isLast)
        //   Container(
        //     width: 2,
        //     height: 40,
        //     color: Colors.grey[300],
        //   ),

        // const SizedBox(height: 20),
      ],
    );
  }
}