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

  /// 👈 MATCHES the edit screen logic exactly
  bool get _isSchoolLevel {
    return education.level == "Secondary" ||
        education.level == "Higher Secondary";
  }

  /// 👈 MATCHES the edit screen logic exactly
  bool get _isHigherEdLevel {
    return education.level == "Diploma" ||
        education.level == "Bachelor" ||
        education.level == "Masters" ||
        education.level == "Honors" ||
        education.level == "Doctoral";
  }

  @override
  Widget build(BuildContext context) {
    final bool isCurrent = education.isCurrentInstitute ?? false;

    return Container(
      width: double.infinity,
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

              // 👈 Show Group & Board ONLY for Secondary & Higher Secondary
              if (_isSchoolLevel) ...[
                ProfileInfoRow(label: "Group", value: education.group),
                ProfileInfoRow(label: "Board", value: education.board),
              ],

              // 👈 Show Department & Semester ONLY for Diploma, Bachelor, Masters, Honors, Doctoral
              if (_isHigherEdLevel) ...[
                ProfileInfoRow(label: "Department", value: education.department),
                ProfileInfoRow(label: "Semester", value: education.semester),
              ],

              // For O Level / A Level — nothing extra shows (correct behavior)

              if (!isCurrent)
                ProfileInfoRow(
                  label: "Passing Year",
                  value: education.passingYear,
                ),

              ProfileInfoRow(
                label: "Is Current Institute",
                value: education.isCurrentInstitute == true ? "Yes" : "No",
              ),

              ProfileInfoRow(label: "Result", value: "${education.result ?? "-"}"),
            ],
          ),
        ],
      ),
    );
  }
}