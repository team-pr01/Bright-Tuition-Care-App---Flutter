import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/number_formatter.dart';
import 'package:btcclient/core/widgets/dashboard/dashboard_cards/dashboard_large_card.dart';
import 'package:btcclient/core/widgets/dashboard/dashboard_cards/dashboard_small_card.dart';
import 'package:btcclient/core/widgets/dashboard/dashboard_cards/profile_progress_icon.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GuardianCardsSection extends StatelessWidget {
  final int profileCompletion;
  final int confirmationLettersCount;

  const GuardianCardsSection({
    super.key,
    required this.profileCompletion,
    required this.confirmationLettersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardLargeCard(
          title: "Looking for a tutor?",
          description:
              "Submit your requirements to find expert and verified tutors.",
          actionText: "Hire Tutor",
          icon: SvgPicture.asset(
            "assets/icons/visual/location.svg",
            width: 80,
            colorFilter: const ColorFilter.mode(
              AppColors.primary01,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(height: 14),

        /// TOP TWO SMALL CARDS
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// PROFILE COMPLETION CARD
              Expanded(
                child: DashboardSmallCard(
                  title: "$profileCompletion%",
                  description:
                      "Complete & organized profile may help to get better response",
                  icon: ProfileProgressIcon(
                    progress: (profileCompletion / 100).clamp(0.0, 1.0),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// CONFIRMATION LETTER CARD (NOW SMALL)
              Expanded(
                child: DashboardSmallCard(
                  subtitle: "Confirmation Letter",
                  title: confirmationLettersCount > 0
                      ? formatNumber(confirmationLettersCount).toString()
                      : formatNumber(0).toString(),
                  description: confirmationLettersCount > 0
                      ? "$confirmationLettersCount letter(s) available."
                      : "No confirmed tuition yet.",
                  actionText: confirmationLettersCount > 0 ? "View All" : "",
                  icon: SvgPicture.asset(
                    "assets/icons/visual/letter.svg",
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
      ],
    );
  }
}
