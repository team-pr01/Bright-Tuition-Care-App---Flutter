import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/services/navigation_service.dart';
import 'package:btcclient/core/widgets/navbar/bottom_navbar.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';
import 'package:btcclient/features/notifications/presentations/provider/notification_notifier.dart';
import 'package:btcclient/features/notifications/presentations/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardLayout extends ConsumerStatefulWidget {
  /// Pages used by the dashboard.
  ///
  /// IMPORTANT:
  /// pages.length should normally match navItems.length.
  final List<Widget Function(Function(int, {String? status}), String?)> pages;

  /// Bottom navigation items.
  final List<BottomNavigationBarItem> navItems;

  /// Drawer builder.
  final Widget Function(
    Function(int, {String? status}),
  ) drawerBuilder;

  /// Index that should be opened when dashboard starts.
  ///
  /// Example:
  /// Logged-in dashboard -> 2
  /// Guest dashboard -> 0
  final int initialIndex;

  const DashboardLayout({
    super.key,
    required this.pages,
    required this.navItems,
    required this.drawerBuilder,
    this.initialIndex = 0,
  });

  @override
  ConsumerState<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends ConsumerState<DashboardLayout> {
  late int currentIndex;

  /// Current job status filter.
  String? jobStatusFilter;

  /// Used for double-back-to-exit behaviour.
  DateTime? lastBackPressed;

  // =============================================================
  // SAFE INDEX HELPERS
  // =============================================================

  /// Returns a valid index for navItems.
  ///
  /// This prevents:
  ///
  /// currentIndex = 2
  /// navItems.length = 2
  ///
  /// from causing:
  ///
  /// 0 <= currentIndex < items.length
  ///
  /// assertion failure.
  int get safeNavIndex {
    if (widget.navItems.isEmpty) {
      return 0;
    }

    return currentIndex.clamp(
      0,
      widget.navItems.length - 1,
    );
  }

  /// Returns a valid index for pages.
  int get safePageIndex {
    if (widget.pages.isEmpty) {
      return 0;
    }

    return currentIndex.clamp(
      0,
      widget.pages.length - 1,
    );
  }

  /// Returns the dashboard's configured initial index,
  /// but guarantees that it is valid.
  int get safeInitialIndex {
    if (widget.navItems.isEmpty) {
      return 0;
    }

    return widget.initialIndex.clamp(
      0,
      widget.navItems.length - 1,
    );
  }

  // =============================================================
  // LIFECYCLE
  // =============================================================

  @override
  void initState() {
    super.initState();

    // NEVER assign widget.initialIndex directly without validation.
    currentIndex = safeInitialIndex;

    debugPrint('🏠 DashboardLayout INIT');
    debugPrint('Initial index: ${widget.initialIndex}');
    debugPrint('Safe current index: $currentIndex');
    debugPrint('Nav items count: ${widget.navItems.length}');
    debugPrint('Pages count: ${widget.pages.length}');

    Future.microtask(() async {
      if (!mounted) return;

      ref
          .read(notificationNotifierProvider.notifier)
          .loadNotifications();
    });

    NavigationService.registerJobDetailsHandler(
      _openJobFromNotification,
    );
  }

  @override
  void dispose() {
    debugPrint('🏠 DashboardLayout DISPOSE');

    NavigationService.unregisterJobDetailsHandler();

    super.dispose();
  }

  // =============================================================
  // NOTIFICATION JOB NAVIGATION
  // =============================================================

  Future<void> _openJobFromNotification(String jobId) async {
    if (!mounted) return;

    debugPrint(
      '🔔 Dashboard received notification job: $jobId',
    );

    NavigationService.setPendingJob(jobId);

    // Job Board is index 0.
    if (widget.navItems.isEmpty) {
      return;
    }

    debugPrint('➡️ Navigating to Job Board tab 0');

    changeTab(0);
  }

  // =============================================================
  // TAB CHANGE
  // =============================================================

  void changeTab(
    int index, {
    String? status,
  }) {
    if (!mounted) return;

    // If there are no navigation items, don't attempt
    // to navigate anywhere.
    if (widget.navItems.isEmpty) {
      return;
    }

    final safeIndex = index.clamp(
      0,
      widget.navItems.length - 1,
    );

    setState(() {
      currentIndex = safeIndex;
      jobStatusFilter = status;
    });

    debugPrint(
      '📍 Dashboard tab changed: '
      '$index -> $safeIndex',
    );
  }

  // =============================================================
  // APP BAR
  // =============================================================

  bool get _showAppBar {
    // Don't hard-code Profile = 4 here.
    //
    // The dashboard can have different numbers of pages.
    // For example:
    //
    // Guest:
    // 0 = Jobs
    // 1 = How It Works
    //
    // Logged in:
    // 0 = Jobs
    // 1 = ...
    // 2 = Dashboard
    // 4 = Profile
    //
    // If later you want to hide the AppBar on a particular page,
    // make that configurable instead of hard-coding it.
    return true;
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final notificationState =
        ref.watch(notificationNotifierProvider);

    final unreadCount =
        notificationState.unreadCount;

    final navIndex = safeNavIndex;

    final hasPages = widget.pages.isNotEmpty;

    final pageIndex = hasPages
        ? safePageIndex
        : 0;

    return PopScope(
      canPop: false,

      onPopInvoked: (didPop) async {
        if (didPop) return;

        // =======================================================
        // BACK BEHAVIOUR
        // =======================================================
        //
        // IMPORTANT:
        // We DO NOT use:
        //
        // currentIndex = 2
        //
        // anymore.
        //
        // Instead we return to whatever initialIndex was provided.
        // Guest -> 0
        // Logged in -> whatever its initialIndex is.
        // =======================================================

        final defaultIndex = safeInitialIndex;

        if (currentIndex != defaultIndex) {
          setState(() {
            currentIndex = defaultIndex;
            jobStatusFilter = null;
          });

          return;
        }

        // =======================================================
        // DOUBLE BACK TO EXIT
        // =======================================================

        final now = DateTime.now();

        if (lastBackPressed == null ||
            now.difference(lastBackPressed!) >
                const Duration(seconds: 2)) {
          lastBackPressed = now;

          AppSnackbar.show(
            context,
            "Press back again to exit",
            SnackType.natural,
            showIcon: false,
          );

          return;
        }

        SystemNavigator.pop();
      },

      child: Scaffold(
        // =======================================================
        // DRAWER
        // =======================================================

        drawer: widget.drawerBuilder(changeTab),

        // =======================================================
        // APP BAR
        // =======================================================

        appBar: _showAppBar
            ? PreferredSize(
                preferredSize:
                    const Size.fromHeight(56),

                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),

                  decoration:
                      const BoxDecoration(
                    color: AppColors.neutrals01,
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromRGBO(
                          0,
                          0,
                          0,
                          0.10,
                        ),
                        offset:
                            Offset(0, 1.446),
                        blurRadius: 1.446,
                      ),
                    ],
                  ),

                  child: SafeArea(
                    bottom: false,

                    child: Stack(
                      alignment:
                          Alignment.center,

                      children: [
                        // =================================================
                        // MENU BUTTON
                        // =================================================

                        Align(
                          alignment:
                              Alignment.centerLeft,

                          child: Builder(
                            builder: (context) {
                              return IconButton(
                                icon: Container(
                                  padding:
                                      const EdgeInsets.all(6),

                                  decoration:
                                      BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(
                                      30,
                                    ),
                                    border:
                                        Border.all(
                                      color:
                                          AppColors.primary03,
                                      width: 1,
                                    ),
                                  ),

                                  child:
                                      SvgPicture.asset(
                                    "assets/icons/operations/menu.svg",
                                    width: 20,
                                    height: 20,
                                    colorFilter:
                                        const ColorFilter.mode(
                                      AppColors.primary01,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),

                                onPressed: () {
                                  Scaffold.of(
                                    context,
                                  ).openDrawer();
                                },
                              );
                            },
                          ),
                        ),

                        // =================================================
                        // LOGO
                        // =================================================

                        Center(
                          child: Image.asset(
                            "assets/images/logo.png",
                            height: 32,
                            fit: BoxFit.contain,
                          ),
                        ),

                        // =================================================
                        // NOTIFICATION BUTTON
                        // =================================================

                        Align(
                          alignment:
                              Alignment.centerRight,

                          child: Stack(
                            children: [
                              IconButton(
                                icon: Container(
                                  padding:
                                      const EdgeInsets.all(6),

                                  decoration:
                                      BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(
                                      30,
                                    ),
                                    border:
                                        Border.all(
                                      color:
                                          AppColors.primary03,
                                      width: 1,
                                    ),
                                  ),

                                  child:
                                      SvgPicture.asset(
                                    "assets/icons/operations/notification.svg",
                                    width: 20,
                                    height: 20,
                                    colorFilter:
                                        const ColorFilter.mode(
                                      AppColors.primary01,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),

                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const NotificationScreen(),
                                    ),
                                  );
                                },
                              ),

                              if (unreadCount > 0)
                                Positioned(
                                  right: 5,
                                  top: 5,

                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(
                                      4,
                                    ),

                                    decoration:
                                        const BoxDecoration(
                                      color: Colors.red,
                                      shape:
                                          BoxShape.circle,
                                    ),

                                    constraints:
                                        const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),

                                    child: Text(
                                      unreadCount > 99
                                          ? '99+'
                                          : '$unreadCount',

                                      textAlign:
                                          TextAlign.center,

                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.white,
                                        fontSize: 10,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : null,

        // =========================================================
        // BODY
        // =========================================================

        body: hasPages
            ? AnimatedSwitcher(
                duration:
                    const Duration(milliseconds: 300),

                child: widget.pages[pageIndex](
                  changeTab,
                  jobStatusFilter,
                ),
              )
            : const SizedBox.shrink(),

        // =========================================================
        // BOTTOM NAVIGATION
        // =========================================================

        bottomNavigationBar:
            widget.navItems.isEmpty
                ? null
                : AppBottomNavBar(
                    // ALWAYS pass a valid index.
                    currentIndex: navIndex,

                    items: widget.navItems,

                    onTap: (index) {
                      changeTab(index);
                    },
                  ),
      ),
    );
  }
}