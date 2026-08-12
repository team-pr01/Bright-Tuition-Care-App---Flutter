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

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.neutrals01,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: bothSigned
              ? AppColors.success.withOpacity(0.2)
              : AppColors.primary01.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ========== HEADER ==========
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: bothSigned
                    ? [
                        AppColors.success.withOpacity(0.05),
                        AppColors.neutrals01,
                      ]
                    : [
                        AppColors.primary03.withOpacity(0.05),
                        AppColors.neutrals01,
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.large),
                topRight: Radius.circular(AppRadius.large),
              ),
            ),
            child: Row(
              children: [
                /// Icon
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: bothSigned
                          ? [
                              AppColors.success,
                              AppColors.success.withOpacity(0.7),
                            ]
                          : [
                              AppColors.primary01,
                              AppColors.primary01.withOpacity(0.7),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (bothSigned
                                    ? AppColors.success
                                    : AppColors.primary01)
                                .withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    bothSigned
                        ? Icons.verified_rounded
                        : Icons.description_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                /// Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Confirmation Letter",
                        style: AppTextStyles.headlineSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutrals02,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary03,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "Job #${letter.job.jobId}",
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primary01,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "•",
                            style: TextStyle(
                              color: AppColors.neutrals04,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
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

                /// Status Badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: bothSigned
                              ? [
                                  AppColors.success,
                                  AppColors.success.withOpacity(0.8),
                                ]
                              : [Colors.orange, Colors.orange.withOpacity(0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (bothSigned ? AppColors.success : Colors.orange)
                                    .withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            bothSigned
                                ? Icons.check_circle_rounded
                                : Icons.pending,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            bothSigned ? "Completed" : "Pending",
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(height: 4),
                    // Text(
                    //   "$totalSigned/2 Signed",
                    //   style: AppTextStyles.labelSmall.copyWith(
                    //     color: AppColors.neutrals03,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),

          /// ========== CONTENT ==========
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Job Title
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary03.withOpacity(0.08),
                    // borderRadius: BorderRadius.circular(AppRadius.small),
                    // border: Border.all(
                    //   color: AppColors.primary01.withOpacity(0.1),
                    // ),
                  ),
                  child: Row(
                    children: [
                      // Icon(
                      //   Icons.work_outline_rounded,
                      //   size: 18,
                      //   color: AppColors.primary01,
                      // ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          letter.job.title,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.neutrals02,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                /// ========== PARTICIPANTS ==========
                Text(
                  "Participants",
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.neutrals03,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
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
                const SizedBox(height: 6),
                _participantTile(
                  icon: Icons.person_outline_rounded,
                  name: letter.tutor.name,
                  role: "Tutor",
                  isSigned: tutorSigned,
                ),

                const SizedBox(height: AppSpacing.md),

                /// ========== PROGRESS ==========
                _buildProgressIndicator(totalSigned: totalSigned),

                const SizedBox(height: AppSpacing.md),

                /// ========== VIEW BUTTON ==========
                AppButton(
                  label: "View Letter",
                  onPressed: onView,
                  variant: AppButtonVariant.gradient,
                  icon: Icons.remove_red_eye_outlined,
                  height: 48,
                ),
              ],
            ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isSigned
            ? AppColors.success.withOpacity(0.05)
            : AppColors.neutrals01,
        borderRadius: BorderRadius.circular(AppRadius.small),
        border: Border.all(
          color: isSigned
              ? AppColors.success.withOpacity(0.2)
              : AppColors.neutrals04.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSigned
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.neutrals04.withOpacity(0.2),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isSigned
                  ? AppColors.success.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSigned ? Icons.check_circle_rounded : Icons.pending,
                  size: 12,
                  color: isSigned ? AppColors.success : Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  isSigned ? "Signed" : "Pending",
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isSigned ? AppColors.success : Colors.orange,
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
                letterSpacing: 0.5,
              ),
            ),
            Text(
              "$totalSigned/2",
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary01,
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
            minHeight: 6,
            backgroundColor: AppColors.neutrals04.withOpacity(0.2),
            color: totalSigned == 2 ? AppColors.success : AppColors.primary01,
          ),
        ),
        if (totalSigned == 2) ...[
          const SizedBox(height: 4),
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

  /// ========== OLD STATUS ROW (Kept for reference but not used) ==========
  Widget _statusRow(String title, bool signed) {
    return Row(
      children: [
        Text(
          "$title : ",
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutrals03),
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
