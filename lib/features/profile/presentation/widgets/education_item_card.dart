import 'package:btcclient/features/profile/presentation/widgets/profile_overview_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/tuition_section_card.dart';
import 'package:flutter/material.dart';
import 'package:btcclient/core/config/theme.dart';

class EducationItemCard extends StatelessWidget {
  final String title;
  final List<ProfileInfoItem> items;

  const EducationItemCard({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary02,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.edit_outlined,
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

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