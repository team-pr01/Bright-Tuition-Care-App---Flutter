import 'package:btcclient/core/models/notice_model.dart';
import 'package:btcclient/core/widgets/dashboard/dashboard_nav_links.dart';
import 'package:btcclient/core/widgets/dashboard/skeletons/home_skeleton.dart';
import 'package:btcclient/core/widgets/dashboard/verify_profile_card.dart';
import 'package:btcclient/features/tutor/presentation/provider/tutor_dashboard_provider.dart';
import 'package:btcclient/features/tutor/presentation/screens/tutor_application_screen.dart';
import 'package:btcclient/features/tutor/presentation/widgets/tutor_cards_section.dart';
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

    // ============================================================
    // LOADING
    // ============================================================

    if (dashboardState.loading && dashboardState.data == null) {
      return const Scaffold(body: SafeArea(child: HomeSkeleton()));
    }

    // ============================================================
    // ERROR
    // ============================================================

    if (dashboardState.error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(dashboardState.error!, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(tutorDashboardProvider.notifier).fetchStats();
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ============================================================
    // DATA
    // ============================================================

    final data = dashboardData?["data"] ?? {};

    final tutor = data["tutorOfTheMonth"] ?? {};

    final applications = data["applications"] ?? {};

    final notices = (dashboardData?["data"]?["notices"] as List? ?? [])
        .map((notice) => NoticeModel.fromJson(notice))
        .toList();

    final isVerified = data["isVerified"] ?? false;

    final profileCompleted = data["profileCompleted"] ?? 0;

    final totalNearbyJobs = data["totalNearbyJobs"] ?? 0;

    final preferredCities = List<String>.from(data["preferredCities"] ?? []);

    final preferredLocations = List<String>.from(
      data["preferredLocations"] ?? [],
    );

    final confirmationLetters = data["confirmationLetterCount"] ?? 0;

    final invoices = data["invoiceCount"] ?? 0;

    // ============================================================
    // SCREEN
    // ============================================================

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return ref
                .read(tutorDashboardProvider.notifier)
                .fetchStats(refresh: true);
          },

          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            slivers: [
              // ===============P===================================
              // STICKY HEADER
              // SEARCH + APPLICATION STATUS
              // ==================================================
              SliverPersistentHeader(
                pinned: true,

                delegate: _TutorStickyHeaderDelegate(
                  height: 180,

                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,

                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),

                    child: Column(
                      children: [
                        // ========================================
                        // SEARCH BAR
                        // ========================================
                        TutorSearchBar(
                          onTap: () {
                            widget.changeTab(3);
                          },
                        ),

                        const SizedBox(height: 18),

                        // ========================================
                        // APPLICATION STATUS
                        // ========================================
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Expanded(
                                child: Expanded(
                                  child: DashboardNavLinks(
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
                                    count: applications["applied"] ?? 0,
                                    onTap: () {
                                      _openApplications(context, "applied");
                                    },
                                  ),
                                ),
                              ),

                              Expanded(
                                child: DashboardNavLinks(
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
                                  count: applications["shortlisted"] ?? 0,
                                  onTap: () {
                                    _openApplications(context, "shortlisted");
                                  },
                                ),
                              ),

                              Expanded(
                                child: DashboardNavLinks(
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
                                  count: applications["appointed"] ?? 0,
                                  onTap: () {
                                    _openApplications(context, "appointed");
                                  },
                                ),
                              ),

                              Expanded(
                                child: DashboardNavLinks(
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
                                  count: applications["confirmed"] ?? 0,
                                  onTap: () {
                                    _openApplications(context, "confirmed");
                                  },
                                ),
                              ),

                              Expanded(
                                child: DashboardNavLinks(
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
                                  count: applications["rejected"] ?? 0,
                                  onTap: () {
                                    _openApplications(context, "cancelled");
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ==================================================
              // SCROLLABLE CONTENT
              // ==================================================
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),

                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ==========================================
                    // REFRESHING
                    // ==========================================
                    if (dashboardState.refreshing)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: LinearProgressIndicator(),
                      ),

                    // ==========================================
                    // NOTICE BOARD
                    // ==========================================
                    NoticeSection(notices: notices),

                    const SizedBox(height: 20),

                    // ==========================================
                    // TUTOR OF THE MONTH
                    // ==========================================
                    if (dashboardData != null)
                      RecognitionCard(
                        image:
                            tutor["imageUrl"] ??
                            "assets/images/dummy-avatar.jpg",

                        title: "Tutor of the Month",

                        tutorId: tutor["tutorId"] ?? "",

                        rating: tutor["rating"]?.toString() ?? "0",

                        name: tutor["userId"]?["name"] ?? "",

                        date: "This Month",
                      ),

                    const SizedBox(height: 20),

                    // ==========================================
                    // DASHBOARD CARDS
                    // ==========================================
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

                    // ==========================================
                    // VERIFY PROFILE
                    // ==========================================
                    VerifyProfileCard(isVerified: isVerified),

                    const SizedBox(height: 20),

                    // ==========================================
                    // HELPLINE
                    // ==========================================
                    HelplineCard(
                      phone: "+880 1616-012 365",

                      timing: "10:00 Am - 10:00 Pm",

                      onTap: () {
                        launchUrl(Uri.parse("tel:+8801616012365"));
                      },
                    ),

                    const SizedBox(height: 20),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // OPEN APPLICATIONS
  // ============================================================

  void _openApplications(BuildContext context, String status) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MyApplicationPage(
          changeTab: widget.changeTab,
          initialStatus: status,
        ),
      ),
    );
  }
}

// ==================================================================
// RESPONSIVE STICKY APPLICATION ITEM
// ==================================================================

class _StickyApplicationItem extends StatelessWidget {
  final String icon;
  final String label;
  final int count;
  final VoidCallback onTap;

  const _StickyApplicationItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ======================================================
          // ICON CIRCLE
          // ======================================================
          SizedBox(
            width: 50,
            height: 50,

            child: Material(
              color: const Color(0xFF159BE5),

              shape: const CircleBorder(),

              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: 28,
                  height: 28,

                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 7),

          // ======================================================
          // LABEL
          // ======================================================
          SizedBox(
            height: 20,

            child: FittedBox(
              fit: BoxFit.scaleDown,

              child: Text(
                label,
                maxLines: 1,
                softWrap: false,

                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          const SizedBox(height: 2),

          // ======================================================
          // COUNT
          // ======================================================
          Text(
            count.toString(),

            maxLines: 1,

            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// STICKY HEADER DELEGATE
// ==================================================================

class _TutorStickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _TutorStickyHeaderDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,

      elevation: overlapsContent ? 3 : 0,

      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _TutorStickyHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
