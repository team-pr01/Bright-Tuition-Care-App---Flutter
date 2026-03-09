import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/dashboard/dashboard_cards/profile_progress_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dashboard_small_card.dart';
import 'dashboard_large_card.dart';

class DashboardCardsSection extends StatelessWidget {
  const DashboardCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// TOP TWO CARDS (SAME HEIGHT)
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              /// PROFILE COMPLETION CARD
              Expanded(
                child: DashboardSmallCard(
                  title: "50%",
                  description:
                      "Complete & organized profile may help to get better response",
                  icon: const ProfileProgressIcon(
                    progress: 0.5,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// NEARBY JOBS CARD
              Expanded(
                child: DashboardSmallCard(
                  subtitle: "Nearby Jobs",
                  description: "167 jobs available in your nearest area.",
                  actionText: "View All",
                  icon: SvgPicture.asset(
                    "assets/icons/visual/location.svg",
                    width: 40,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary01,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        /// LARGE CARD
        DashboardLargeCard(
          title: "Confirmation Letter",
          description: "167 jobs available in your nearest area.",
          actionText: "View All",
          icon: SvgPicture.asset(
            "assets/icons/visual/letter.svg",
            width: 80,
            colorFilter: const ColorFilter.mode(
              AppColors.primary01,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }
}