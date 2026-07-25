import 'package:btcclient/features/profile/presentation/widgets/shared/education_item_card.dart';
import 'package:flutter/material.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';


class EducationSectionCard extends StatelessWidget {
  final List<Education> educations;
  final void Function(Education education)? onEdit;

  const EducationSectionCard({
    super.key,
    required this.educations,
    this.onEdit,
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
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Educational Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffEDF4FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${educations.length} Record${educations.length == 1 ? "" : "s"}",
                  style: const TextStyle(
                    color: Color(0xff246BFD),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (educations.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: const Color(0xffF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Column(
                children: const [
                  Icon(
                    Icons.school_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No education information available.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            )
          else
            ...educations.map(
              (education) => EducationItemCard(
                education: education,
                onEdit: onEdit == null
                    ? null
                    : () => onEdit!(education),
              ),
            ),
        ],
      ),
    );
  }
}