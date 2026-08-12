import 'package:btcclient/core/models/notice_model.dart';
import 'package:btcclient/core/widgets/dashboard/skeletons/home_skeleton.dart';
import 'package:btcclient/core/widgets/dashboard/verify_profile_card.dart';
import 'package:btcclient/features/jobs/data/models/job_filter.dart';
import 'package:btcclient/features/tutor/presentation/provider/tutor_dashboard_provider.dart';
import 'package:btcclient/features/tutor/presentation/screens/tutor_application_screen.dart';
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
  final Function(int, {String? status}) changeTab;

  const TutorHomeScreen({super.key, required this.changeTab});

  @override
  ConsumerState<TutorHomeScreen> createState() => _TutorHomeScreenState();
}

class _TutorHomeScreenState extends ConsumerState<TutorHomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(tutorDashboardProvider);

      if (state.data == null) {
        ref.read(tutorDashboardProvider.notifier).fetchStats();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(tutorDashboardProvider);
    final dashboardData = dashboardState.data;
    if (dashboardState.loading && dashboardState.data == null) {
      return const Scaffold(body: SafeArea(child: HomeSkeleton()));
    }
    if (dashboardState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(dashboardState.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(tutorDashboardProvider.notifier).fetchStats();
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }
    final data = dashboardData?["data"] ?? {};
    final tutor = data["tutorOfTheMonth"];
    final applications = data["applications"] ?? {};
    final notices = (dashboardData?["data"]?["notices"] as List? ?? [])
        .map((notice) => NoticeModel.fromJson(notice))
        .toList();
    final isVerified = dashboardData != null
        ? data["isVerified"] ?? false
        : false;
    final profileCompleted = dashboardData != null
        ? data["profileCompleted"]
        : 0;
    final totalNearbyJobs = dashboardData != null ? data["totalNearbyJobs"] : 0;
    final preferredCities = List<String>.from(data["preferredCities"] ?? []);

    final preferredLocations = List<String>.from(
      data["preferredLocations"] ?? [],
    );
    final confirmationLetters = dashboardData != null
        ? data["confirmationLetterCount"]
        : 0;
    final invoices = dashboardData != null ? data["invoiceCount"] : 0;
    return RefreshIndicator(
      onRefresh: () {
        return ref
            .read(tutorDashboardProvider.notifier)
            .fetchStats(refresh: true);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            if (dashboardState.refreshing) const LinearProgressIndicator(),

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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MyApplicationPage(
                          changeTab: widget.changeTab,
                          initialStatus: "applied",
                        ),
                      ),
                    );
                  },
                  label: "Applied",
                  count: applications["applied"] ?? 0,
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MyApplicationPage(
                          changeTab: widget.changeTab,
                          initialStatus: "shortlisted",
                        ),
                      ),
                    );
                  },
                  label: "Shortlisted",
                  count: applications["shortlisted"] ?? 0,
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MyApplicationPage(
                          changeTab: widget.changeTab,
                          initialStatus: "appointed",
                        ),
                      ),
                    );
                  },
                  label: "Appointed",
                  count: applications["appointed"] ?? 0,
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MyApplicationPage(
                          changeTab: widget.changeTab,
                          initialStatus: "confirmed",
                        ),
                      ),
                    );
                  },
                  label: "Confirmed",
                  count: applications["confirmed"] ?? 0,
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MyApplicationPage(
                          changeTab: widget.changeTab,
                          initialStatus: "cancelled",
                        ),
                      ),
                    );
                  },
                  label: "Cancelled",
                  count: applications["rejected"] ?? 0,
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// NOTICE
            NoticeSection(notices: notices), const SizedBox(height: 20),

            /// TUTOR OF THE MONTH (FROM API)
            if (dashboardData != null)
              RecognitionCard(
                image: tutor["imageUrl"] ?? "assets/images/dummy-avatar.jpg",
                title: "Tutor of the Month",
                tutorId: tutor["tutorId"] ?? "",
                rating: tutor["rating"].toString() ?? "0",
                name: tutor["userId"]["name"] ?? "",
                date: "This Month",
              ),

            const SizedBox(height: 20),

            TutorCardsSection(
              profileCompletion: profileCompleted,
              nearbyJobsCount: totalNearbyJobs,
              confirmationLettersCount: confirmationLetters,
              invoicesCount: invoices,
              preferredCities: preferredCities,
              preferredLocations: preferredLocations,
              changeTab: widget.changeTab,
            ),

            const SizedBox(height: 20),

            VerifyProfileCard(
              isVerified: isVerified, // real value
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
