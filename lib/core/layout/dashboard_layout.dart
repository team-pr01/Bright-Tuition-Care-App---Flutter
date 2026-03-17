import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/navbar/bottom_navbar.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardLayout extends StatefulWidget {
  final List<Widget Function(Function(int))> pages;
  final List<BottomNavigationBarItem> navItems;
  final Widget Function(Function(int)) drawerBuilder;

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
  DateTime? lastBackPressed;

  void changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  int notificationCount = 3;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        /// If not on dashboard → go to dashboard
        if (currentIndex != 2) {
          setState(() {
            currentIndex = 2;
          });
          return;
        }

        /// Double back to exit
        final now = DateTime.now();

        if (lastBackPressed == null ||
            now.difference(lastBackPressed!) > const Duration(seconds: 2)) {
          lastBackPressed = now;

          AppSnackbar.show(
            context,
            "Press back again to exit",
            SnackType.natural,
          );

          return;
        }

        Navigator.of(context).pop();
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
                  /// LEFT MENU BUTTON
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

                  /// CENTER LOGO
                  Center(
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                  ),

                  /// RIGHT NOTIFICATION BUTTON
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

        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: widget.pages[currentIndex](changeTab),
        ),

        bottomNavigationBar: AppBottomNavBar(
          currentIndex: currentIndex,
          items: widget.navItems,
          onTap: changeTab,
        ),
      ),
    );
  }
}