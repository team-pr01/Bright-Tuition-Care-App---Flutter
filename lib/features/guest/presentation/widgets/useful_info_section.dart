import 'package:flutter/material.dart';

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/features/guest/presentation/widgets/overview_bottom_sheets.dart';

class UsefulInfoSection extends StatelessWidget {
  const UsefulInfoSection({
    super.key,
  });

  static const List<UsefulItem> _items = [
    UsefulItem(
      icon: Icons.info_outline_rounded,
      title: 'About Us',
    ),
    UsefulItem(
      icon: Icons.support_agent_outlined,
      title: 'Contact Us',
    ),
    UsefulItem(
      icon: Icons.share_rounded,
      title: 'Social Links',
    ),
    UsefulItem(
      icon: Icons.link_rounded,
      title: 'Quick Links',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.neutrals01,
        borderRadius: BorderRadius.circular(
          AppRadius.large,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary04.withValues(
              alpha: 0.06,
            ),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Useful Info',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.neutrals02,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),

          const SizedBox(
            height: AppSpacing.lg,
          ),

          Row(
            children: _items.map((item) {
              return Expanded(
                child: _buildUsefulItem(
                  context,
                  item,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUsefulItem(
    BuildContext context,
    UsefulItem item,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(
        AppRadius.medium,
      ),
      onTap: () {
        switch (item.title) {
          case 'About Us':
            OverviewBottomSheets.showAboutUs(context);
            break;

          case 'Contact Us':
            OverviewBottomSheets.showContactUs(context);
            break;

          case 'Social Links':
            OverviewBottomSheets.showSocialLinks(context);
            break;

          case 'Quick Links':
            OverviewBottomSheets.showQuickLinks(context);
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 2,
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.primary02,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                size: 26,
                color: AppColors.primary01,
              ),
            ),

            const SizedBox(
              height: AppSpacing.sm,
            ),

            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary04,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UsefulItem {
  final IconData icon;
  final String title;

  const UsefulItem({
    required this.icon,
    required this.title,
  });
}