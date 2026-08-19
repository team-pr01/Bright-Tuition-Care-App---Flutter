import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/layout/dashboard_layout.dart';
import 'package:btcclient/core/screens/join_community.dart';
import 'package:btcclient/core/widgets/navbar/sidebar_item.dart';
import 'package:btcclient/core/widgets/navbar/side_drawer.dart';
import 'package:btcclient/core/widgets/share_card/share_card.dart';
import 'package:btcclient/features/auth/presentation/screens/login_screen.dart';
import 'package:btcclient/features/auth/presentation/screens/register_screen.dart';
import 'package:btcclient/features/auth/presentation/screens/welcome_screen.dart';
import 'package:btcclient/features/guest/presentation/screens/overview_screen.dart';
import 'package:btcclient/features/jobs/presentation/screen/job_page.dart';
import 'package:btcclient/features/tutor/presentation/screens/how_it_works_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GuestDashboardScreen extends StatelessWidget {
  final int initialIndex;

  const GuestDashboardScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      // =========================================================
      // INITIAL TAB
      // =========================================================
      initialIndex: initialIndex,
      pageTitles: const ["Job Board", "Invoices", "Share the App"],
      // =========================================================
      // APP BAR
      // =========================================================
      appBarAction: DashboardAppBarAction.user,

      onUserPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const RegisterScreen(
              role: "tutor",
            ),
          ),
        );
      },

      // =========================================================
      // DRAWER
      // =========================================================
      drawerBuilder: (changeTab) {
        return AppSidebar(
          user: null,

          // =======================================================
          // PRIMARY MENU
          // =======================================================
          menuItems: [
            SidebarItem(
              label: "Job Board",
              icon: _icon(
                "assets/icons/navigations/job-board.svg",
              ),
              onTap: () {
                Navigator.pop(context);

                // TAB 0 = JOBS
                changeTab(0);
              },
            ),

            // SidebarItem(
            //   label: "Overview",
            //   icon: _icon(
            //     "assets/icons/navigations/dashboard-square-edit.svg",
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);

            //     // TAB 1 = GUARDIAN OVERVIEW
            //     changeTab(1);
            //   },
            // ),
          ],

          // =======================================================
          // COMMON MENU
          // =======================================================
          menuItemsCommon: [
            SidebarItem(
              label: "Join Community",
              icon: _icon(
                "assets/icons/social_media/facebook.svg",
              ),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CommunityPage(
                      title: "Tutor Community",
                      description:
                          "Join our tutor community to exchange "
                          "teaching strategies, gain valuable insights, "
                          "stay informed on the latest trends and access "
                          "resources that support your professional growth.",
                      buttonText: "Join Community",
                      link:
                          "https://www.facebook.com/groups/252670130864095",
                    ),
                  ),
                );
              },
            ),

            SidebarItem(
              label: "How It Works",
              icon: _icon(
                "assets/icons/navigations/how-it-works.svg",
              ),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HowItWorksScreen(),
                  ),
                );
              },
            ),
          ],

          // =======================================================
          // LOGIN
          // =======================================================
          onLogin: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WelcomeScreen(),
              ),
              // MaterialPageRoute(
              //   builder: (_) => const LoginScreen(role:"tutor"),
              // ),
            );
          },
        );
      },

      // ===========================================================
      // PAGES
      //
      // 0 = Jobs
      // 1 = Guardian Overview
      // 2 = Share App
      // ===========================================================
      pages: [
        // =========================================================
        // TAB 0 — JOBS
        // =========================================================
        (changeTab, status) {
          return JobsPage(
            role: "guest",
            changeTab: changeTab,
          );
        },

        // =========================================================
        // TAB 1 — GUARDIAN OVERVIEW
        // =========================================================
        // (changeTab, status) {
        //   return const OverviewScreen();
        // },

        // =========================================================
        // TAB 2 — SHARE APP
        // =========================================================
        (changeTab, status) {
          return const Center(
            child: ShareCard(
              title: "Share with your Friends and Relatives",
              description:
                  "Help your friends and relatives to find the right "
                  "tutor for their children by sharing our platform "
                  "— and earn exclusive rewards!",
              link:
                  "https://www.brighttuitioncare.com",
            ),
          );
        },
      ],

      // ===========================================================
      // BOTTOM NAVIGATION
      // ===========================================================
      navItems: [
        // =========================================================
        // TAB 0 — JOBS
        // =========================================================
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/icons/navigations/job-search.svg",
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              AppColors.neutrals06,
              BlendMode.srcIn,
            ),
          ),
          activeIcon: SvgPicture.asset(
            "assets/icons/navigations/job-search.svg",
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              AppColors.primary01,
              BlendMode.srcIn,
            ),
          ),
          label: "Jobs",
        ),

        // =========================================================
        // TAB 1 — OVERVIEW
        // =========================================================
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/icons/navigations/dashboard-square-edit.svg",
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              AppColors.neutrals06,
              BlendMode.srcIn,
            ),
          ),
          activeIcon: SvgPicture.asset(
            "assets/icons/navigations/dashboard-square-edit.svg",
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              AppColors.primary01,
              BlendMode.srcIn,
            ),
          ),
          label: "Overview",
        ),

        // =========================================================
        // TAB 2 — SHARE APP
        // =========================================================
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/icons/navigations/share-outline.svg",
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              AppColors.neutrals06,
              BlendMode.srcIn,
            ),
          ),
          activeIcon: SvgPicture.asset(
            "assets/icons/navigations/share-outline.svg",
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              AppColors.primary01,
              BlendMode.srcIn,
            ),
          ),
          label: "Share App",
        ),
      ],
    );
  }

  // =============================================================
  // SIDEBAR ICON
  // =============================================================
  static Widget _icon(String path) {
    return SvgPicture.asset(
      path,
      width: 20,
      height: 20,
      colorFilter: const ColorFilter.mode(
        Colors.white,
        BlendMode.srcIn,
      ),
    );
  }
}