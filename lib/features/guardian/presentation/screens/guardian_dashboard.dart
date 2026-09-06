import 'dart:async';

import 'package:btcclient/core/models/notice_model.dart';
import 'package:btcclient/core/widgets/dashboard/skeletons/home_skeleton.dart';
import 'package:btcclient/core/widgets/dashboard/verify_profile_card.dart';
import 'package:btcclient/core/widgets/recognition_card.dart';
import 'package:btcclient/core/widgets/reusable_modal.dart';
import 'package:btcclient/features/guardian/presentation/provider/guardain_dashboard_provider.dart';
import 'package:btcclient/features/guardian/presentation/widgets/guardian_cards_section.dart';
import 'package:btcclient/features/guardian/presentation/widgets/hire_tutor_bar.dart';
import 'package:btcclient/core/widgets/dashboard/dashboard_nav_links.dart';
import 'package:btcclient/core/widgets/dashboard/notice_board/notice_section.dart';
import 'package:btcclient/core/widgets/helpline_card/helpline_card.dart';

import 'package:btcclient/features/promotions/data/models/promotion_model.dart';
import 'package:btcclient/features/promotions/presentation/notifier/promotion_notifier.dart';
import 'package:btcclient/features/promotions/presentation/provider/promotion_provider.dart';
import 'package:btcclient/features/promotions/presentation/widgets/promotion_modal.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class GuardianHomeScreen extends ConsumerStatefulWidget {
  final Function(int, {String? status}) changeTab;

  const GuardianHomeScreen({
    super.key,
    required this.changeTab,
  });

  @override
  ConsumerState<GuardianHomeScreen> createState() =>
      _GuardianHomeScreenState();
}

class _GuardianHomeScreenState
    extends ConsumerState<GuardianHomeScreen> {
  Timer? _promotionDelayTimer;

  bool _promotionModalShown = false;

  bool _threeSecondDelayFinished = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ==========================================================
      // EXISTING DASHBOARD API
      // ==========================================================

      ref
          .read(guardianDashboardProvider.notifier)
          .fetchStats();

      // ==========================================================
      // PROMOTION API
      // ==========================================================

      ref
          .read(promotionProvider.notifier)
          .fetchPromotions();

      // ==========================================================
      // WAIT 3 SECONDS
      // ==========================================================

      _promotionDelayTimer = Timer(
        const Duration(seconds: 7),
        () {
          if (!mounted) return;

          _threeSecondDelayFinished = true;

          _tryShowPromotionModal();
        },
      );
    });
  }

  // ==============================================================
  // PROMOTION MODAL
  // ==============================================================

  void _tryShowPromotionModal() {
    if (!mounted) return;

    if (_promotionModalShown) return;

    if (!_threeSecondDelayFinished) return;

    final promotionState =
        ref.read(promotionProvider);

    // API is still loading.
    //
    // The ref.listen below will call this again
    // automatically when the API finishes.
    if (promotionState.isLoading) {
      return;
    }

    // API finished but there are no promotions.
    if (promotionState.promotions.isEmpty) {
      return;
    }

    _openPromotionModal(
      promotionState.promotions,
    );
  }

  void _openPromotionModal(
    List<PromotionModel> promotions,
  ) {
    if (!mounted) return;

    if (_promotionModalShown) return;

    if (promotions.isEmpty) return;

    _promotionModalShown = true;

    ReusableModal.show(
      context: context,
      barrierDismissible: true,
      maxHeightFactor: 0.90,
      verticalPadding: 6,
      horizontalPadding: 6,

      // IMPORTANT:
      // Promotion is an image-based modal.
      // Therefore don't add the normal modal padding.
      // edgeToEdge: true,

      child: PromotionModal(
        promotions: promotions,
      ),
    );
  }

  // ==============================================================
  // DISPOSE
  // ==============================================================

  @override
  void dispose() {
    _promotionDelayTimer?.cancel();

    super.dispose();
  }

  // ==============================================================
  // BUILD
  // ==============================================================

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // LISTEN FOR PROMOTION API
    //
    // This solves the API > 3 second race condition.
    // ============================================================

    ref.listen<PromotionState>(
      promotionProvider,
      (previous, next) {
        if (!mounted) return;

        if (_promotionModalShown) return;

        if (!_threeSecondDelayFinished) return;

        if (next.isLoading) return;

        if (next.promotions.isEmpty) return;

        _openPromotionModal(
          next.promotions,
        );
      },
    );

    // ============================================================
    // DASHBOARD STATE
    // ============================================================

    final dashboardState =
        ref.watch(guardianDashboardProvider);

    final dashboardData =
        dashboardState.data;

    // ============================================================
    // DASHBOARD LOADING
    // ============================================================

    if (dashboardState.loading &&
        dashboardState.data == null) {
      return const Scaffold(
        body: SafeArea(
          child: HomeSkeleton(),
        ),
      );
    }

    // ============================================================
    // DASHBOARD ERROR
    // ============================================================

    if (dashboardState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Text(
              dashboardState.error!,
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                ref
                    .read(
                      guardianDashboardProvider
                          .notifier,
                    )
                    .fetchStats();
              },
              child: const Text(
                "Retry",
              ),
            ),
          ],
        ),
      );
    }

    // ============================================================
    // VERIFIED
    // ============================================================

    final isVerified =
        dashboardData != null
            ? dashboardData["data"]
                    ["isVerified"] ??
                false
            : false;

    // ============================================================
    // NOTICES
    // ============================================================

    final notices =
        (dashboardData?["data"]?["notices"]
                    as List? ??
                [])
            .map(
              (notice) =>
                  NoticeModel.fromJson(
                notice,
              ),
            )
            .toList();

    // ============================================================
    // PROFILE COMPLETION
    // ============================================================

    final profileCompleted =
        dashboardData != null
            ? dashboardData["data"]
                    ["profileCompleted"] ??
                0
            : 0;

    // ============================================================
    // CONFIRMATION LETTERS
    // ============================================================

    final confirmationLetters =
        dashboardData != null
            ? dashboardData["data"]
                    ["confirmationLetterCount"] ??
                0
            : 0;

    // ============================================================
    // DASHBOARD
    // ============================================================

    return RefreshIndicator(
      onRefresh: () {
        return ref
            .read(
              guardianDashboardProvider
                  .notifier,
            )
            .fetchStats(
              refresh: true,
            );
      },

      child: SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(),

        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [
            // ======================================================
            // HIRE TUTOR
            // ======================================================

            HireTutorBar(
              onTap: () {
                widget.changeTab(1);
              },
            ),

            const SizedBox(
              height: 16,
            ),

            // ======================================================
            // JOB NAVIGATION
            // ======================================================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: [
                DashboardNavLinks(
                  icon: SvgPicture.asset(
                    "assets/icons/navigations/appointed.svg",
                    width: 24,
                    height: 24,
                    colorFilter:
                        const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "All Jobs",
                  count:
                      dashboardData?["data"]
                                  ?["jobs"]
                              ?["total"] ??
                          0,
                  onTap: () {
                    widget.changeTab(
                      0,
                      status: null,
                    );
                  },
                ),

                DashboardNavLinks(
                  icon: SvgPicture.asset(
                    "assets/icons/navigations/pending-jobs.svg",
                    width: 24,
                    height: 24,
                    colorFilter:
                        const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "Pending",
                  count:
                      dashboardData?["data"]
                                  ?["jobs"]
                              ?["pending"] ??
                          0,
                  onTap: () {
                    widget.changeTab(
                      0,
                      status: "pending",
                    );
                  },
                ),

                DashboardNavLinks(
                  icon: SvgPicture.asset(
                    "assets/icons/navigations/jobs-search.svg",
                    width: 24,
                    height: 24,
                    colorFilter:
                        const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "Live",
                  count:
                      dashboardData?["data"]
                                  ?["jobs"]
                              ?["live"] ??
                          0,
                  onTap: () {
                    widget.changeTab(
                      0,
                      status: "live",
                    );
                  },
                ),

                DashboardNavLinks(
                  icon: SvgPicture.asset(
                    "assets/icons/navigations/confirmed.svg",
                    width: 24,
                    height: 24,
                    colorFilter:
                        const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "Confirmed",
                  count:
                      dashboardData?["data"]
                                  ?["jobs"]
                              ?["closed"] ??
                          0,
                  onTap: () {
                    widget.changeTab(
                      0,
                      status: "closed",
                    );
                  },
                ),

                DashboardNavLinks(
                  icon: SvgPicture.asset(
                    "assets/icons/navigations/cancelled.svg",
                    width: 24,
                    height: 24,
                    colorFilter:
                        const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "Cancelled",
                  count:
                      dashboardData?["data"]
                                  ?["jobs"]
                              ?["cancelled"] ??
                          0,
                  onTap: () {
                    widget.changeTab(
                      0,
                      status: "cancelled",
                    );
                  },
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // ======================================================
            // NOTICES
            // ======================================================

            NoticeSection(
              notices: notices,
            ),

            const SizedBox(
              height: 20,
            ),

            // ======================================================
            // GUARDIAN OF THE MONTH
            // ======================================================

            if (dashboardData != null)
              RecognitionCard(
                image:
                    dashboardData["data"]
                                ?[
                                    "guardianOfTheMonth"
                                  ]
                            ?["imageUrl"] ??
                        "assets/images/dummy-avatar.jpg",

                title:
                    "Guardian of the Month",

                tutorId:
                    dashboardData["data"]
                                ?[
                                    "guardianOfTheMonth"
                                  ]
                            ?["guardianId"] ??
                        "",

                rating:
                    dashboardData["data"]
                                ?[
                                    "guardianOfTheMonth"
                                  ]
                            ?["rating"]
                            ?.toString() ??
                        "0",

                name:
                    dashboardData["data"]
                                ?[
                                    "guardianOfTheMonth"
                                  ]
                            ?["userId"]
                            ?["name"] ??
                        "",

                date:
                    "This Month",
              ),

            const SizedBox(
              height: 20,
            ),

            // ======================================================
            // GUARDIAN CARDS
            // ======================================================

            GuardianCardsSection(
              profileCompletion:
                  profileCompleted,

              confirmationLettersCount:
                  confirmationLetters,

              onHireTutorTap: () {
                widget.changeTab(1);
              },
            ),

            const SizedBox(
              height: 20,
            ),

            // ======================================================
            // VERIFY PROFILE
            // ======================================================

            VerifyProfileCard(
              isVerified: isVerified,
            ),

            const SizedBox(
              height: 20,
            ),

            // ======================================================
            // HELPLINE
            // ======================================================

            HelplineCard(
              phone:
                  "+880 1616-012 365",

              timing:
                  "10:00 Am - 10:00 Pm",

              onTap: () {
                launchUrl(
                  Uri.parse(
                    "tel:+8801616012365",
                  ),
                );
              },
            ),

            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}