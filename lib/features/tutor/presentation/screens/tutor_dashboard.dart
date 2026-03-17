import 'package:btcclient/core/models/notice_model.dart';
import 'package:btcclient/core/widgets/dashboard/verify_profile_card.dart';
import 'package:btcclient/features/tutor/presentation/provider/tutor_dashboard_provider.dart';
import 'package:btcclient/features/tutor/presentation/widgets/tutor_cards_section.dart';
import 'package:btcclient/core/widgets/dashboard/dashboard_nav_links.dart';
import 'package:btcclient/core/widgets/dashboard/notice_board/notice_section.dart';
import 'package:btcclient/core/widgets/helpline_card/helpline_card.dart';
import 'package:btcclient/core/widgets/recognition_card.dart';
import 'package:btcclient/features/tutor/presentation/widgets/tutor_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorHomeScreen extends ConsumerStatefulWidget {
  final Function(int) changeTab;

  const TutorHomeScreen({super.key, required this.changeTab});

  @override
  ConsumerState<TutorHomeScreen> createState() => _TutorHomeScreenState();
}

class _TutorHomeScreenState extends ConsumerState<TutorHomeScreen> {
  @override
  void initState() {
    super.initState();

    /// call dashboard API when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tutorDashboardProvider.notifier).fetchStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardData = ref.watch(tutorDashboardProvider);
    final notices = (dashboardData?["data"]?["notices"] as List? ?? [])
        .map((notice) => NoticeModel.fromJson(notice))
        .toList();
    final profileCompleted = dashboardData != null
        ? dashboardData["data"]["profileCompleted"]
        : 0;
    final totalNearbyJobs = dashboardData != null
        ? dashboardData["data"]["totalNearbyJobs"]
        : 0;
    final confirmationLetters = dashboardData != null
        ? dashboardData["data"]["confirmationLetterCount"]
        : 0;
    final invoices = dashboardData != null
        ? dashboardData["data"]["invoiceCount"]
        : 0;
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(tutorDashboardProvider.notifier).fetchStats();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            /// SEARCH BAR
            TutorSearchBar(
              onTap: () {
                widget.changeTab(0);
              },
            ),

            const SizedBox(height: 20),

            /// NAV LINKS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DashboardNavLinks(
                  icon: SvgPicture.asset(
                    "assets/icons/navigations/applied.svg",
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "Applied",
                  count:
                      dashboardData?["data"]?["applications"]["applied"] ?? 0,
                ),
                DashboardNavLinks(
                  icon: SvgPicture.asset(
                    "assets/icons/navigations/shortlisted.svg",
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "Shortlisted",
                  count:
                      dashboardData?["data"]?["applications"]["shortlisted"] ??
                      0,
                ),
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
                  label: "Appointed",
                  count:
                      dashboardData?["data"]?["applications"]["appointed"] ?? 0,
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
                  count:
                      dashboardData?["data"]?["applications"]["confirmed"] ?? 0,
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
                      dashboardData?["data"]?["applications"]["rejected"] ?? 0,
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// NOTICE
            NoticeSection(notices: notices), const SizedBox(height: 20),

            /// TUTOR OF THE MONTH (FROM API)
            if (dashboardData != null)
              RecognitionCard(
                image:
                    dashboardData["data"]?["tutorOfTheMonth"]["imageUrl"] ??
                    "assets/images/logo-1.png",
                title: "Tutor of the Month",
                tutorId:
                    dashboardData["data"]?["tutorOfTheMonth"]["tutorId"] ?? "",
                rating:
                    dashboardData["data"]?["tutorOfTheMonth"]["rating"]
                        .toString() ??
                    "0",
                name:
                    dashboardData["data"]?["tutorOfTheMonth"]["userId"]["name"] ??
                    "",
                date: "This Month",
              ),

            const SizedBox(height: 20),

            TutorCardsSection(
              profileCompletion: profileCompleted,
              nearbyJobsCount: totalNearbyJobs,
              confirmationLettersCount: confirmationLetters,
              invoicesCount: invoices,
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
      ),
    );
  }
}
