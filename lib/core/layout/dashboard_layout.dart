import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/navbar/bottom_navbar.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class DashboardLayout extends StatefulWidget {
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
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  int currentIndex = 2;

  /// 🔥 NEW: filter holder
  String? jobStatusFilter;

  DateTime? lastBackPressed;

  /// 🔥 UPDATED
  void changeTab(int index, {String? status}) {
    setState(() {
      currentIndex = index;
      jobStatusFilter = status;
    });
  }

  int notificationCount = 3;

  @override
  Widget build(BuildContext context) {
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
                          onPressed: () {},
                        ),
                        if (notificationCount > 0)
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
                                "$notificationCount",
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
          child: widget.pages[currentIndex](
            changeTab,
            jobStatusFilter,
          ),
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