import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/dashboard/dashboard_cards/profile_progress_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/widgets/dashboard/dashboard_cards/dashboard_small_card.dart';
import '../../../../core/widgets/dashboard/dashboard_cards/dashboard_large_card.dart';

class TutorCardsSection extends StatelessWidget {
  final int profileCompletion;
  final int nearbyJobsCount;
  final int confirmationLettersCount;
  final int invoicesCount;
  const TutorCardsSection({
    super.key,
    required this.profileCompletion,
    required this.nearbyJobsCount,
    required this.confirmationLettersCount,
    required this.invoicesCount,
  });

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
                  title: profileCompletion.toString() + "%",
                  description:
                      "Complete & organized profile may help to get better response",
                  icon: ProfileProgressIcon(
                    progress: (profileCompletion / 100).clamp(0.0, 1.0),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// NEARBY JOBS CARD
              Expanded(
                child: DashboardSmallCard(
                  subtitle: "Nearby Jobs",
                  title: nearbyJobsCount.toString(),
                  description: " jobs available in your nearest area.",
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
          description: confirmationLettersCount > 0
              ? "$confirmationLettersCount confirmation letter(s) available."
              : "You have not confirmed any tuition jobs yet.",
          actionText: confirmationLettersCount > 0 ? "View All" : "",
          icon: SvgPicture.asset(
            "assets/icons/visual/letter.svg",
            width: 80,
            colorFilter: const ColorFilter.mode(
              AppColors.primary01,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(height: 14),
        DashboardLargeCard(
          title: "Invoices",
          description: invoicesCount > 0
              ? "$invoicesCount invoice(s) available."
              : "No invoice is available because you have not confirmed any tuition jobs yet.",
          actionText: invoicesCount > 0 ? "View All" : "",
          icon: SvgPicture.asset("assets/icons/visual/invoice.svg", width: 80),
        ),
      ],
    );
  }
}
