import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;

  const StepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const totalSteps = 3; // only actual steps

    final isPreview = currentStep == 3;

    final progress = isPreview
        ? 1.0
        : (currentStep + 1) / totalSteps;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isPreview
                ? "Ready to Submit"
                : "${(progress * 100).toInt()}% Complete",
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: AppColors.primary01,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 220,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.neutrals04,
                borderRadius: BorderRadius.circular(10),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary01,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}