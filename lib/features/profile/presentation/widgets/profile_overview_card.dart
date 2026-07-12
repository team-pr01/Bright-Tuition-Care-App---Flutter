import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/features/profile/presentation/widgets/tuition_section_card.dart';
import 'package:flutter/material.dart';

class ProfileInfoItem {
  final String label;
  final String? value;
  const ProfileInfoItem(this.label, this.value);
}

class ProfileOverviewCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String overview;
  final List<ProfileInfoItem> items;
  const ProfileOverviewCard({
    super.key,
    required this.title,
    this.icon,
    required this.overview,
    required this.items,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary02),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Overview",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      overview,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                label: const Text("Edit Info"),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: AppColors.primary02),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => TuitionInfoRow(label: item.label, value: item.value),
          ),
        ],
      ),
    );
  }
}

