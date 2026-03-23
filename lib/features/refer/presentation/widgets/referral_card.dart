import 'package:btcclient/features/refer/data/models/referral_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/config/theme.dart';

class ReferralCard extends StatelessWidget {
  final ReferralStep step;

  const ReferralCard({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔵 STEP NUMBER
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary01,
            child: Text(
              step.step.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          /// 🔹 TITLE
          Text(
            step.title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutrals02,
                ),
          ),

          const SizedBox(height: AppSpacing.sm),

          /// 🔹 DESCRIPTION
          Text(
            step.description,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.neutrals03,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}