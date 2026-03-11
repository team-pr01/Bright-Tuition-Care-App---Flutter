import 'package:btcclient/core/models/notice_model.dart';
import 'package:btcclient/core/widgets/dashboard/verify_profile_card.dart';
import 'package:btcclient/features/guardian/presentation/provider/guardain_dashboard_provider.dart';
import 'package:btcclient/features/guardian/presentation/widgets/guardian_cards_section.dart';
import 'package:btcclient/features/guardian/presentation/widgets/hire_tutor_bar.dart';
import 'package:btcclient/core/widgets/dashboard/dashboard_nav_links.dart';
import 'package:btcclient/core/widgets/dashboard/notice_board/notice_section.dart';
import 'package:btcclient/core/widgets/helpline_card/helpline_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class GuardianHomeScreen extends ConsumerStatefulWidget {
  const GuardianHomeScreen({super.key});

  @override
  ConsumerState<GuardianHomeScreen> createState() => _GuardianHomeScreenState();
}

class _GuardianHomeScreenState extends ConsumerState<GuardianHomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(guardianDashboardProvider.notifier).fetchStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardData = ref.watch(guardianDashboardProvider);
    final notices = (dashboardData?["data"]?["notices"] as List? ?? [])
        .map((notice) => NoticeModel.fromJson(notice))
        .toList();
    final profileCompleted = dashboardData != null
        ? dashboardData["data"]["profileCompleted"]
        : 0;
    final confirmationLetters = dashboardData != null
        ? dashboardData["data"]["confirmationLetterCount"]
        : 0;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          HireTutorBar(
            onTap: () {
              print("Hire Tutor Clicked");
            },
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DashboardNavLinks(
                icon: SvgPicture.asset(
                  "assets/icons/navigations/appointed.svg",
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: "All Jobs",
                count:
                    dashboardData?["data"]?["jobs"]["total"]?.toString() ?? "0",
              ),
              DashboardNavLinks(
                icon: SvgPicture.asset(
                  "assets/icons/navigations/pending-jobs.svg",
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: "pending",
                count:
                    dashboardData?["data"]?["jobs"]["pending"]?.toString() ??
                    "0",
              ),

              DashboardNavLinks(
                icon: SvgPicture.asset(
                  "assets/icons/navigations/jobs-search.svg",
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: "Live",
                count:
                    dashboardData?["data"]?["jobs"]["live"]?.toString() ?? "0",
              ),

              DashboardNavLinks(
                icon: SvgPicture.asset(
                  "assets/icons/navigations/confirmed.svg",
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: "Confirmed",
              ),

              DashboardNavLinks(
                icon: SvgPicture.asset(
                  "assets/icons/navigations/cancelled.svg",
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: "Cancelled",
                count:
                    dashboardData?["data"]?["jobs"]["cancelled"]?.toString() ??
                    "0",
              ),
            ],
          ),
          const SizedBox(height: 20),
          NoticeSection(notices: notices),
          const SizedBox(height: 20),

          GuardianCardsSection(
            profileCompletion: profileCompleted,
            confirmationLettersCount: confirmationLetters,
          ),

          const SizedBox(height: 20),

          const VerifyProfileCard(),
          const SizedBox(height: 20),

          HelplineCard(
            phone: "+880 1616-012 365",
            timing: "10:00 Am - 10:00 Pm",
            onTap: () {
              launchUrl(Uri.parse("tel:+8801616012365"));
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
