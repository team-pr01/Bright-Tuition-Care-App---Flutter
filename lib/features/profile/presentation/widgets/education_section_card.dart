import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/profile/presentation/widgets/education_item_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/education_progress_header.dart';
import 'package:btcclient/features/profile/presentation/widgets/profile_overview_card.dart';
import 'package:flutter/material.dart';

class EducationSectionCard extends StatelessWidget {
  final List<Education> educations;
  final void Function(Education education)? onEdit;

  const EducationSectionCard({
    super.key,
    required this.educations,
    this.onEdit,
  });

  int calculateEducationProgress(Education education) {
    int filled = 0;
    const int total = 10;

    final fields = [
      education.level,
      education.degree,
      education.institute,
      education.board,
      education.curriculum,
      education.group,
      education.department,
      education.semester,
      education.result,
      education.passingYear,
    ];

    for (final field in fields) {
      if (field != null && field.toString().trim().isNotEmpty) {
        filled++;
      }
    }

    return ((filled / total) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    if (educations.isEmpty) {
      return _EmptyEducationCard();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Educational Information",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 20),

        EducationProgressHeader(
          educations: List.generate(
            educations.length,
            (index) => EducationProgress(
              title: "Education ${index + 1}",
              percentage: calculateEducationProgress(
                educations[index],
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        ...educations.asMap().entries.map((entry) {
          final index = entry.key;
          final education = entry.value;

          return EducationItemCard(
            title: education.degree.trim().isNotEmpty
                ? education.degree
                : "Education ${index + 1}",

            onEdit: () {
              onEdit?.call(education);
            },

            items: [
              ProfileInfoItem(
                "Level Of Education",
                education.level,
              ),
              ProfileInfoItem(
                "Institute Name",
                education.institute,
              ),
              ProfileInfoItem(
                "Board",
                education.board,
              ),
              ProfileInfoItem(
                "Curriculum",
                education.curriculum,
              ),
              ProfileInfoItem(
                "Group",
                education.group,
              ),
              ProfileInfoItem(
                "Department",
                education.department,
              ),
              ProfileInfoItem(
                "Semester",
                education.semester,
              ),
              ProfileInfoItem(
                "Result",
                education.result,
              ),
              ProfileInfoItem(
                "Passing Year",
                education.passingYear,
              ),
              ProfileInfoItem(
                "Current Institute",
                education.isCurrentInstitute == true
                    ? "Yes"
                    : "No",
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _EmptyEducationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(
            Icons.school_outlined,
            size: 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 18),
          const Text(
            "No Education Added",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Complete your educational information to improve your profile.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: () {
              // TODO: Navigate to Add Education Screen
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Education"),
          ),
        ],
      ),
    );
  }
}