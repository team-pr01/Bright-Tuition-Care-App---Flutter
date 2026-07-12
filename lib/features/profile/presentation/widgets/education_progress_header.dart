import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';

class EducationProgress {
  final String title;
  final int percentage;

  EducationProgress({required this.title, required this.percentage});
}

class EducationProgressHeader extends StatelessWidget {
  final List<EducationProgress> educations;

  const EducationProgressHeader({super.key, required this.educations});

  Color getProgressColor(int percentage) {
    if (percentage >= 100) {
      return Colors.blue;
    }

    if (percentage >= 50) {
      return const Color.fromARGB(255, 255, 238, 0);
    }

    return Colors.red;
  }

  String getStatus(int percentage) {
    if (percentage >= 100) {
      return "Completed";
    }

    if (percentage >= 50) {
      return "In Progress";
    }

    return "Incomplete";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(educations.length, (index) {
        final education = educations[index];

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == educations.length - 1 ? 0 : 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(education.title, style: const TextStyle(fontSize: 13)),

                    // Text(
                    //   getStatus(education.percentage),
                    //   style: TextStyle(
                    //     fontSize: 11,
                    //     color: getProgressColor(education.percentage),
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                  ],
                ),

                const SizedBox(height: 6),

                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Stack(
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),

                      FractionallySizedBox(
                        widthFactor: education.percentage / 100,
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: const LinearGradient(
                              colors: [Color.fromARGB(255, 213, 233, 250), Color.fromARGB(255, 190, 224, 250), AppColors.primary01],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
