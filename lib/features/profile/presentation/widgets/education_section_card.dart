import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/profile/presentation/widgets/education_item_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/education_progress_header.dart';
import 'package:btcclient/features/profile/presentation/widgets/profile_overview_card.dart';
import 'package:flutter/material.dart';

class EducationSectionCard extends StatelessWidget {
  final List<Education> educations;

  const EducationSectionCard({
    super.key,
    required this.educations,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Educational Information",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
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

        const SizedBox(height: 20),

        ...educations.asMap().entries.map((entry) {
          final index = entry.key;
          final education = entry.value;

          return EducationItemCard(
            title: education.degree.trim().isNotEmpty
                ? education.degree
                : "Edu ${index + 1}",

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