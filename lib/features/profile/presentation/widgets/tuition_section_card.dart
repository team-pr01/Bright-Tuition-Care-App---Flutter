import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/profile/presentation/widgets/profile_overview_card.dart';
import 'package:flutter/material.dart';

class TuitionSectionCard extends StatelessWidget {
  final TutorProfileModel profile;

  const TuitionSectionCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TuitionInfoCard(
          title: "Accessibility Information",
          items: [
            ProfileInfoItem(
              "Tutoring Method",
              profile.tuitionPreference.tutoringMethod,
            ),

            ProfileInfoItem(
              "Tutoring Styles",
              profile.tuitionPreference.tuitionStyle.join(", "),
            ),

            ProfileInfoItem(
              "Expected Salary",
              profile.tuitionPreference.expectedSalary,
            ),

            ProfileInfoItem(
              "Preferred Cities",
              profile.tuitionPreference.preferredCities.join(", "),
            ),

            ProfileInfoItem(
              "Preferred Locations",
              profile.tuitionPreference.preferredLocations.join(", "),
            ),
          ],
        ),

        const SizedBox(height: 16),

        _TuitionInfoCard(
          title: "Additional Information",
          items: [
            ProfileInfoItem(
              "Preferred Categories",
              profile.tuitionPreference.preferredCategories.join(", "),
            ),

            ProfileInfoItem(
              "Preferred Classes",
              profile.tuitionPreference.preferredClasses.join(", "),
            ),

            ProfileInfoItem(
              "Preferred Subjects",
              profile.tuitionPreference.preferredSubjects.join(", "),
            ),

            ProfileInfoItem(
              "Place Of Tutoring",
              profile.tuitionPreference.placeOfTuition.join(", "),
            ),

            ProfileInfoItem(
              "Total Experience",
              profile.experience.totalExperience,
            ),
          ],
        ),
      ],
    );
  }
}
class _TuitionInfoCard extends StatelessWidget {
  final String title;
  final List<ProfileInfoItem> items;

  const _TuitionInfoCard({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          ...items.map(
            (item) => TuitionInfoRow(
              label: item.label,
              value: item.value,
            ),
          ),
        ],
      ),
    );
  }
}

class TuitionInfoRow extends StatelessWidget {
  final String label;
  final String? value;

  const TuitionInfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isMissing =
        value == null ||
        value!.trim().isEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const Text(": "),

          Expanded(
            child: Text(
              isMissing
                  ? "Not Provided"
                  : value!,
              style: TextStyle(
                color: isMissing
                    ? Colors.red
                    : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}