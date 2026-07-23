import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';

class ProfileInfoItem {
  final String label;
  final String? value;

  const ProfileInfoItem(
    this.label,
    this.value,
  );
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.neutrals04,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),

          Divider(
            height: 1,
            color: AppColors.neutrals04,
          ),

          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(),

                const SizedBox(height: 20),

                ...items.map(
                  (e) => _ProfileRow(item: e),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary01.withOpacity(.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description_outlined,
              color: AppColors.primary01,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Overview",
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  overview.trim().isEmpty
                      ? "No overview added yet."
                      : overview,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.neutrals03,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text("Edit"),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      children: [
       

        Expanded(
          child: Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final ProfileInfoItem item;

  const _ProfileRow({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue =
        item.value != null && item.value!.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Label
          SizedBox(
            width: 110,
            child: Text(
              item.label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.neutrals02,
              ),
            ),
          ),

          /// Colon
          const SizedBox(
            width: 20,
            child: Center(
              child: Text(
                ":",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          /// Value
          Expanded(
            child: Text(
              hasValue ? item.value! : "Not Added",
              style: AppTextStyles.bodyMedium.copyWith(
                color: hasValue
                    ? AppColors.neutrals02
                    : Colors.grey.shade500,
                fontStyle:
                    hasValue ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}