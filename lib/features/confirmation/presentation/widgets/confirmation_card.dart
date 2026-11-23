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
    final bothSigned = tutorSigned && guardianSigned;
    final totalSigned = (tutorSigned ? 1 : 0) + (guardianSigned ? 1 : 0);
    final statusColor = bothSigned ? AppColors.success : Colors.orange;
    final accentColor = bothSigned ? AppColors.success : AppColors.primary01;

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
          color: AppColors.neutrals04.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ========== HEADER (JOB TITLE + META + STATUS) ==========
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  bothSigned
                      ? Icons.verified_outlined
                      : Icons.description_outlined,
                  color: accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      letter.job.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutrals02,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 2,
                      children: [
                        Text(
                          "Job #${letter.job.jobId}",
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary01,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "•",
                          style: TextStyle(
                            color: AppColors.neutrals04,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          DateFormatter.formattedDate(
                                letter.createdAt.toIso8601String(),
                              ) ??
                              "-",
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.neutrals03,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      bothSigned ? "Completed" : "Pending",
                      style: AppTextStyles.labelSmall.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.neutrals04.withOpacity(0.45),
            ),
          ),

          /// ========== PARTICIPANTS ==========
          Text(
            "Participants",
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.neutrals03,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),

          _participantTile(
            icon: Icons.person_outline_rounded,
            name: letter.guardian?.name.isNotEmpty == true
                ? letter.guardian!.name
                : "Guardian",
            role: "Guardian",
            isSigned: guardianSigned,
          ),
          const SizedBox(height: 8),
          _participantTile(
            icon: Icons.person_outline_rounded,
            name: letter.tutor.name,
            role: "Tutor",
            isSigned: tutorSigned,
          ),

          const SizedBox(height: 14),

          /// ========== PROGRESS ==========
          _buildProgressIndicator(totalSigned: totalSigned),

          const SizedBox(height: AppSpacing.md),

          /// ========== VIEW BUTTON ==========
          AppButton(
            label: "View Letter",
            onPressed: onView,
            variant: AppButtonVariant.gradient,
            icon: Icons.remove_red_eye_outlined,
            height: 44,
          ),
        ],
      ),
    );
  }

  /// ========== PARTICIPANT TILE ==========
  Widget _participantTile({
    required IconData icon,
    required String name,
    required String role,
    required bool isSigned,
  }) {
    final badgeColor = isSigned ? AppColors.success : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.neutrals01,
        borderRadius: BorderRadius.circular(AppRadius.small),
        border: Border.all(
          color: AppColors.neutrals04.withOpacity(0.45),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSigned
                  ? AppColors.success.withOpacity(0.10)
                  : AppColors.neutrals04.withOpacity(0.20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: isSigned ? AppColors.success : AppColors.neutrals03,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutrals02,
                  ),
                ),
                Text(
                  role,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.neutrals03,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSigned ? Icons.check_circle_rounded : Icons.pending_outlined,
                  size: 12,
                  color: badgeColor,
                ),
                const SizedBox(width: 4),
                Text(
                  isSigned ? "Signed" : "Pending",
                  style: AppTextStyles.labelSmall.copyWith(
                    color: badgeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ========== PROGRESS INDICATOR ==========
  Widget _buildProgressIndicator({required int totalSigned}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Signature Progress",
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.neutrals03,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
            Text(
              "$totalSigned/2",
              style: AppTextStyles.labelMedium.copyWith(
                color: totalSigned == 2 ? AppColors.success : AppColors.primary01,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: totalSigned / 2,
            minHeight: 5,
            backgroundColor: AppColors.neutrals04.withOpacity(0.25),
            color: totalSigned == 2 ? AppColors.success : AppColors.primary01,
          ),
        ),
        if (totalSigned == 2) ...[
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.celebration_outlined,
                size: 14,
                color: AppColors.success,
              ),
              const SizedBox(width: 4),
              Text(
                "All signatures completed! 🎉",
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}