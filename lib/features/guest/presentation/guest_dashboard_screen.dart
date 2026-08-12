import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/layout/dashboard_layout.dart';
import 'package:btcclient/core/screens/join_community.dart';
import 'package:btcclient/core/screens/share_app.dart';
import 'package:btcclient/core/widgets/navbar/sidebar_item.dart';
import 'package:btcclient/core/widgets/navbar/side_drawer.dart';
import 'package:btcclient/features/auth/presentation/screens/login_screen.dart';
import 'package:btcclient/features/auth/presentation/screens/welcome_screen.dart';
import 'package:btcclient/features/jobs/presentation/screen/job_page.dart';
import 'package:btcclient/features/legal/data/important_guidelines_data.dart';
import 'package:btcclient/features/legal/presentation/important_guidelines_screen.dart';
import 'package:btcclient/features/tutor/presentation/screens/how_it_works_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GuestDashboardScreen extends StatelessWidget {
  const GuestDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      initialIndex: 0,
      // =========================================================
      // SIDEBAR
      // =========================================================
      drawerBuilder: (changeTab) {
        return AppSidebar(
          // Guest has no authenticated user.
          user: null,

          // =======================================================
          // PRIMARY MENU
          // =======================================================
          menuItems: [
            SidebarItem(
              label: "Job Board",
              icon: _icon("assets/icons/navigations/job-board.svg"),
              onTap: () {
                Navigator.pop(context);

                // There is only ONE guest page.
                // Therefore its index is always 0.
                changeTab(0);
              },
            ),
          ],

          // =======================================================
          // COMMON / PUBLIC MENU
          // =======================================================
          menuItemsCommon: [
            SidebarItem(
              label: "Important Guidelines",
              icon: _icon("assets/icons/navigations/question-mark.svg"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImportantGuidelinesScreen(
                      document: importantGuidelinesData,
                    ),
                  ),
                );
              },
            ),

            SidebarItem(
              label: "Join Community",
              icon: _icon("assets/icons/social_media/facebook.svg"),
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
                      link: "https://www.facebook.com/groups/252670130864095",
                    ),
                  ),
                );
              },
            ),

            SidebarItem(
              label: "Share The App",
              icon: _icon("assets/icons/navigations/share.svg"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShareScreen()),
                );
              },
            ),
          ],

          // =======================================================
          // GUEST HAS NO LOGOUT
          // =======================================================
          // onLogout: () {},
          onLogin: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
        );
      },

      // ===========================================================
      // GUEST PAGES
      //
      // IMPORTANT:
      // pages.length MUST MATCH navItems.length.
      //
      // Guest currently has ONLY:
      // 0 -> Job Board
      // ===========================================================
      pages: [
        // 0 - JOB BOARD
        (changeTab, status) => JobsPage(role: "guest", changeTab: changeTab),

        // 1 - HOW IT WORKS
        (changeTab, status) {
          return const HowItWorksScreen();
        },
      ],

      // ===========================================================
      // BOTTOM NAVIGATION
      // ===========================================================
      navItems: [
        // =========================================================
        // JOBS
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
        // HOW IT WORKS
        // =========================================================
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/icons/navigations/how-it-works.svg",
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              AppColors.neutrals06,
              BlendMode.srcIn,
            ),
          ),
          activeIcon: SvgPicture.asset(
            "assets/icons/navigations/how-it-works.svg",
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              AppColors.primary01,
              BlendMode.srcIn,
            ),
          ),
          label: "How It Works",
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
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );
  }
}
