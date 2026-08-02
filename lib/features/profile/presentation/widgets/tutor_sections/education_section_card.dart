import 'package:flutter/material.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/profile/presentation/widgets/shared/education_item_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/shared/education_progress_bar.dart';
import 'package:btcclient/features/profile/presentation/widgets/shared/education_empty_widget.dart';

class EducationSectionCard extends StatelessWidget {
  final List<Education> educations;

  final void Function(Education)? onEdit;

  final VoidCallback? onAdd;

  const EducationSectionCard({
    super.key,
    required this.educations,
    this.onEdit,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {

    final progressBars = [
      educations.length > 0,
      educations.length > 1,
      educations.length > 2,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            children: [

              const Expanded(
                child: Text(
                  "Educational Information",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              FilledButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: Text(
                  educations.isEmpty
                      ? "Add Education"
                      : "Add More",
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// PROGRESS BAR
          Row(
            children: [

              EducationProgressBar(
                label: "Education 1",
                completed: progressBars[0],
              ),

              const SizedBox(width: 12),

              EducationProgressBar(
                label: "Education 2",
                completed: progressBars[1],
              ),

              const SizedBox(width: 12),

              EducationProgressBar(
                label: "Education 3",
                completed: progressBars[2],
              ),
            ],
          ),

          const SizedBox(height: 30),

          if (educations.isEmpty)

            EducationEmptyWidget(
              onAdd: onAdd ?? () {},
            )

          else

            AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 350,
              ),

              child: Column(
                children: List.generate(
                  educations.length,
                  (index) {

                    final education = educations[index];

                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 18,
                      ),

                      child: EducationItemCard(
                        education: education,
                        onEdit: onEdit == null
                            ? null
                            : () => onEdit!(education),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}