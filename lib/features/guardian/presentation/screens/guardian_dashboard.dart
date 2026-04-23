import 'package:btcclient/core/models/notice_model.dart';
import 'package:btcclient/core/widgets/dashboard/verify_profile_card.dart';
import 'package:btcclient/core/widgets/recognition_card.dart';
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
  final Function(int, {String? status}) changeTab;
  const GuardianHomeScreen({super.key, required this.changeTab});

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

    final isVerified = dashboardData != null
        ? dashboardData["data"]["isVerified"] ?? false
        : false;

    final notices = (dashboardData?["data"]?["notices"] as List? ?? [])
        .map((notice) => NoticeModel.fromJson(notice))
        .toList();

    final profileCompleted = dashboardData != null
        ? dashboardData["data"]["profileCompleted"]
        : 0;

    final confirmationLetters = dashboardData != null
        ? dashboardData["data"]["confirmationLetterCount"]
        : 0;

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(guardianDashboardProvider.notifier)
            .fetchStats();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // 🔥 IMPORTANT FIX
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
                  count: dashboardData?["data"]?["jobs"]["total"] ?? 0,
                  onTap: () {
                    widget.changeTab(0, status: null);
                  },
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
                  label: "Pending",
                  count: dashboardData?["data"]?["jobs"]["pending"] ?? 0,
                  onTap: () {
                    widget.changeTab(0, status: "pending");
                  },
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
                  count: dashboardData?["data"]?["jobs"]["live"] ?? 0,
                  onTap: () {
                    widget.changeTab(0, status: "live");
                  },
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
                  label: "Closed",
                  count: dashboardData?["data"]?["jobs"]["closed"] ?? 0,
                  onTap: () {
                    widget.changeTab(0, status: "closed");
                  },
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
                  count: dashboardData?["data"]?["jobs"]["cancelled"] ?? 0,
                  onTap: () {
                    widget.changeTab(0, status: "cancelled");
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            NoticeSection(notices: notices),

            const SizedBox(height: 20),

            if (dashboardData != null)
              RecognitionCard(
                image:
                    dashboardData["data"]?["guardianOfTheMonth"]["imageUrl"] ??
                        "assets/images/dummy-avatar.jpg",
                title: "Guardian of the Month",
                tutorId:
                    dashboardData["data"]?["guardianOfTheMonth"]["guardianId"] ??
                        "",
                rating:
                    dashboardData["data"]?["guardianOfTheMonth"]["rating"]
                            .toString() ??
                        "0",
                name:
                    dashboardData["data"]?["guardianOfTheMonth"]["userId"]
                            ["name"] ??
                        "",
                date: "This Month",
              ),

            const SizedBox(height: 20),

            GuardianCardsSection(
              profileCompletion: profileCompleted,
              confirmationLettersCount: confirmationLetters,
            ),

            const SizedBox(height: 20),

            VerifyProfileCard(
              isVerified: isVerified,
            ),

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
      ),
    );
  }
}