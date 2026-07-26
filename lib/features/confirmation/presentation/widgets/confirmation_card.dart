import 'package:flutter/material.dart';
import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/date_formatter.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import '../../data/models/confirmation_letter_model.dart';

class ConfirmationCard extends StatelessWidget {
  final ConfirmationLetterModel letter;
  final VoidCallback onView;

  const ConfirmationCard({
    super.key,
    required this.letter,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final tutorSigned = letter.tutorSignature != null;
    final guardianSigned = letter.guardianSignature != null;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutrals01,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: AppColors.primary01.withOpacity(.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.primary02,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: AppColors.primary01,
                  size: 28,
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Confirmation Letter",
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Job ID : ${letter.job.jobId}",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.neutrals03,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: tutorSigned && guardianSigned
                      ? AppColors.success
                      : Colors.orange,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  tutorSigned && guardianSigned
                      ? "Completed"
                      : "Pending",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          Divider(
            color: AppColors.neutrals04,
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            letter.job.title,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          _infoRow(
            "Guardian",
            letter.guardian.name,
          ),

          const SizedBox(height: AppSpacing.sm),

          _infoRow(
            "Tutor",
            letter.tutor.name,
          ),

          const SizedBox(height: AppSpacing.sm),

          _statusRow(
            "Guardian Sign",
            guardianSigned,
          ),

          const SizedBox(height: AppSpacing.sm),

          _statusRow(
            "Tutor Sign",
            tutorSigned,
          ),

          const SizedBox(height: AppSpacing.sm),

          _infoRow(
            "Created",
            DateFormatter.formattedDate(
                    letter.createdAt.toIso8601String()) ??
                "-",
          ),

          const SizedBox(height: AppSpacing.lg),

          AppButton(
            label: "View Letter",
            onPressed: onView,
            variant: AppButtonVariant.gradient,
            icon: Icons.remove_red_eye_outlined,
            height: 48,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Row(
      children: [
        Text(
          "$title : ",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.neutrals03,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusRow(String title, bool signed) {
    return Row(
      children: [
        Text(
          "$title : ",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.neutrals03,
          ),
        ),
        const Spacer(),
        Icon(
          signed ? Icons.check_circle : Icons.pending,
          color: signed ? AppColors.success : Colors.orange,
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(
          signed ? "Signed" : "Pending",
          style: AppTextStyles.bodyMedium.copyWith(
            color: signed ? AppColors.success : Colors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}