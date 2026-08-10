import 'package:flutter/material.dart';

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';

import 'package:btcclient/features/profile/presentation/widgets/shared/profile_chip_row.dart';
import 'package:btcclient/features/profile/presentation/widgets/shared/profile_info_row.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';

class TuitionSectionCard extends StatelessWidget {
  final TutorProfileModel profile;
  final VoidCallback? onEdit;

  const TuitionSectionCard({
    super.key,
    required this.profile,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          /// MAIN HEADER + EDIT
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Tuition Related Information",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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
            ],
          ),

          const SizedBox(height: 20),

          /// ACCESSIBILITY INFORMATION
          _TuitionInfoCard(
            title: "Accessibility Information",
            children: [
              ProfileInfoRow(
                label: "Tutoring Method",
                value: profile.tuitionPreference.tutoringMethod,
              ),

              ProfileChipRow(
                label: "Tutoring Styles",
                items: profile.tuitionPreference.tuitionStyle,
              ),

              ProfileInfoRow(
                label: "Expected Salary",
                value: profile
                        .tuitionPreference
                        .expectedSalary
                        .isEmpty
                    ? null
                    : "৳ ${profile.tuitionPreference.expectedSalary}",
              ),

              ProfileChipRow(
                label: "Preferred Cities",
                items: profile.tuitionPreference.preferredCities,
              ),

              ProfileChipRow(
                label: "Preferred Locations",
                items: profile.tuitionPreference.preferredLocations,
              ),
            ],
          ),

          const Divider(),
          const SizedBox(height: 20),

          /// ADDITIONAL INFORMATION
          _TuitionInfoCard(
            title: "Additional Information",
            children: [
              ProfileChipRow(
                label: "Preferred Categories",
                items: profile.tuitionPreference.preferredCategories,
              ),

              ProfileChipRow(
                label: "Preferred Classes",
                items: profile.tuitionPreference.preferredClasses,
              ),

              ProfileChipRow(
                label: "Preferred Subjects",
                items: profile.tuitionPreference.preferredSubjects,
              ),

              ProfileChipRow(
                label: "Place Of Tutoring",
                items: profile.tuitionPreference.placeOfTuition,
              ),

              ProfileInfoRow(
                label: "Total Experience",
                value: profile.totalExperience,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TuitionInfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _TuitionInfoCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 18),

          ...children,
        ],
      ),
    );
  }
}