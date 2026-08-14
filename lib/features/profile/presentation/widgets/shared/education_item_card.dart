import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/features/profile/presentation/widgets/shared/profile_info_row.dart';
import 'package:flutter/material.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';

class EducationItemCard extends StatelessWidget {
  final Education education;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EducationItemCard({
    super.key,
    required this.education,
    this.onEdit,
    this.onDelete,
  });

  bool get _isSchoolLevel {
    return education.level == "Secondary" ||
        education.level == "Higher Secondary" ||
        education.level == "O Level" ||
        education.level == "A Level";
  }

  @override
  Widget build(BuildContext context) {
    final bool isCurrent = education.isCurrentInstitute ?? false;

    return Container(
      width: double.infinity,
      // decoration: BoxDecoration(
      //   color: const Color(0xffF8FAFD),
      //   borderRadius: BorderRadius.circular(18),
      //   border: Border.all(color: Colors.grey.shade300),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      education.degree.isEmpty ? "Education" : education.degree,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      education.institute.isEmpty
                          ? "Institute Not Provided"
                          : education.institute,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),

              AppButton(
                iconOnly: true,
                icon: Icons.edit_outlined,
                variant: AppButtonVariant.outlineGray,
                width: 32,
                height: 32,
                onPressed: onEdit,
              ),

              const SizedBox(width: 8),
              AppButton(
                iconOnly: true,
                icon: Icons.delete_outline,
                variant: AppButtonVariant.outlineGray,
                width: 32,
                height: 32,
                onPressed: onDelete,
                textColor: AppColors.error,
                backgroundColor: AppColors.backgroundLight,
              ),
            ],
          ),

          const SizedBox(height: 20),
          Wrap(
            children: [
              ProfileInfoRow(label: "Level", value: education.level),

              ProfileInfoRow(label: "Degree", value: education.degree),

              ProfileInfoRow(label: "Institute", value: education.institute),

              ProfileInfoRow(label: "Curriculum", value: education.curriculum),

              /// GROUP & BOARD
              if (_isSchoolLevel) ...[
                ProfileInfoRow(label: "Group", value: education.group),

                ProfileInfoRow(label: "Board", value: education.board),
                ProfileInfoRow(
                  label: "Is Current Institute",
                  value: education.isCurrentInstitute == true ? "Yes" : "No",
                ),
              ],

              /// DEPARTMENT & SEMESTER
              if (!_isSchoolLevel) ...[
                ProfileInfoRow(
                  label: "Department",
                  value: education.department,
                ),

                ProfileInfoRow(label: "Semester", value: education.semester),
              ],

              // ProfileInfoRow(
              //   label: "Result",
              //   value: education.result,
              // ),
              if (!isCurrent)
                ProfileInfoRow(
                  label: "Passing Year",
                  value: education.passingYear,
                ),
            
                ProfileInfoRow(label: "Result", value: "${education.result!}"),
            ],
          ),

          const SizedBox(height: 18),
          Divider(color: AppColors.primary01, height: 1),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusChip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
