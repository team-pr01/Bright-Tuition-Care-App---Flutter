import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/number_formatter.dart';
import 'package:btcclient/core/widgets/dashboard/dashboard_cards/profile_progress_icon.dart';
import 'package:btcclient/features/confirmation/presentation/screen/confirmation_page.dart';
import 'package:btcclient/features/jobs/data/models/job_filter.dart';
import 'package:btcclient/features/jobs/presentation/provider/selected_job_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/widgets/dashboard/dashboard_cards/dashboard_small_card.dart';
import '../../../../core/widgets/dashboard/dashboard_cards/dashboard_large_card.dart';

class TutorCardsSection extends ConsumerWidget {
  final int profileCompletion;
  final int nearbyJobsCount;
  final int confirmationLettersCount;
  final int invoicesCount;

  final void Function(int, {String? status}) changeTab;

  final List<String> preferredCities;
  final List<String> preferredLocations;

  const TutorCardsSection({
    super.key,
    required this.profileCompletion,
    required this.nearbyJobsCount,
    required this.confirmationLettersCount,
    required this.invoicesCount,
    required this.preferredCities,
    required this.preferredLocations,
    required this.changeTab,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  onAction: () => changeTab(4),
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
                  onAction: () {
                    ref
                        .read(selectedJobFilterProvider.notifier)
                        .state = JobFilter(
                      city: preferredCities,
                      area: preferredLocations,
                    );

                    changeTab(0);
                    changeTab(0);
                  },
                  subtitle: "Nearby Jobs",
                  title: formatNumber(nearbyJobsCount).toString(),
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
          subtitle: formatNumber(confirmationLettersCount),
          description: confirmationLettersCount > 0
              ? "$confirmationLettersCount confirmation letter(s) available."
              : "You have not confirmed any tuition jobs yet.",
          actionText: confirmationLettersCount > 0 ? "View All" : "",
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ConfirmationScreen(role: "tutor"),
              ),
            ),
          },
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
          onTap: () => changeTab(1),
          subtitle: formatNumber(invoicesCount),
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
