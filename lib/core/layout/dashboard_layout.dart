import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/services/navigation_service.dart';
import 'package:btcclient/core/widgets/navbar/bottom_navbar.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';
import 'package:btcclient/features/jobs/data/models/job_filter.dart';
import 'package:btcclient/features/notifications/presentations/provider/notification_notifier.dart';
import 'package:btcclient/features/notifications/presentations/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class DashboardLayout extends ConsumerStatefulWidget {
  /// 👇 IMPORTANT: updated signature (added String?)
  final List<Widget Function(Function(int, {String? status}), String?)> pages;

  final List<BottomNavigationBarItem> navItems;
  final Widget Function(Function(int, {String? status})) drawerBuilder;

  const DashboardLayout({
    super.key,
    required this.pages,
    required this.navItems,
    required this.drawerBuilder,
  });

  @override
  ConsumerState<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends ConsumerState<DashboardLayout> {
  int currentIndex = 2;

  /// 🔥 NEW: filter holder
  String? jobStatusFilter;

  DateTime? lastBackPressed;
  @override
  void dispose() {
    debugPrint('🏠 DashboardLayout DISPOSE');

    NavigationService.unregisterJobDetailsHandler();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    debugPrint('🏠 DashboardLayout INIT');
    debugPrint('🏠 Dashboard registering notification handler');

    NavigationService.registerJobDetailsHandler(_openJobFromNotification);

    debugPrint('🏠 Dashboard handler registration COMPLETE');

    Future.microtask(() {
      ref.read(notificationNotifierProvider.notifier).loadNotifications();
    });
  }

Future<void> _openJobFromNotification(String jobId) async {
  if (!mounted) return;

  debugPrint(
    '🔔 Dashboard received notification job: $jobId',
  );

  // Store the job for Job Board.
  NavigationService.setPendingJob(jobId);

  // Go directly to Job Board.
  debugPrint(
    '➡️ Navigating to Job Board tab 0',
  );

  changeTab(0);
}

   /// 🔥 UPDATED
  void changeTab(int index, {String? status}) {
    setState(() {
      currentIndex = index;
      jobStatusFilter = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationNotifierProvider);

    final unreadCount = notificationState.unreadCount;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        if (currentIndex != 2) {
          setState(() {
            currentIndex = 2;
          });
          return;
        }

        final now = DateTime.now();

        if (lastBackPressed == null ||
            now.difference(lastBackPressed!) > const Duration(seconds: 2)) {
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
        drawer: widget.drawerBuilder(changeTab),

        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.neutrals01,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.10),
                  offset: Offset(0, 1.446),
                  blurRadius: 1.446,
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Builder(
                      builder: (context) => IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: AppColors.primary03,
                              width: 1,
                            ),
                          ),
                          child: SvgPicture.asset(
                            "assets/icons/operations/menu.svg",
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              AppColors.primary01,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                  ),

                  Center(
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Stack(
                      children: [
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: AppColors.primary03,
                                width: 1,
                              ),
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/operations/notification.svg",
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                AppColors.primary01,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationScreen(),
                              ),
                            );
                          },
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: 5,
                            top: 5,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                unreadCount > 99 ? '99+' : '$unreadCount',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
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
        ),

        /// 🔥 MAIN BODY (FILTER PASSED HERE)
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: widget.pages[currentIndex](changeTab, jobStatusFilter),
        ),

        bottomNavigationBar: AppBottomNavBar(
          currentIndex: currentIndex,
          items: widget.navItems,
          onTap: (index) => changeTab(index),
        ),
      ),
    );
  }
}
