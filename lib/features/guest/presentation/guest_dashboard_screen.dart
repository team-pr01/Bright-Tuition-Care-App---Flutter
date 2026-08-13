import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/layout/dashboard_layout.dart';
import 'package:btcclient/core/screens/join_community.dart';
import 'package:btcclient/core/widgets/navbar/sidebar_item.dart';
import 'package:btcclient/core/widgets/navbar/side_drawer.dart';
import 'package:btcclient/core/widgets/share_card/share_card.dart';
import 'package:btcclient/features/auth/presentation/screens/login_screen.dart';
import 'package:btcclient/features/auth/presentation/screens/register_screen.dart';
import 'package:btcclient/features/jobs/presentation/screen/job_page.dart';
import 'package:btcclient/features/tutor/presentation/screens/how_it_works_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GuestDashboardScreen extends StatelessWidget {
  const GuestDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      appBarAction: DashboardAppBarAction.user,

      onUserPressed: () {
        // Navigate to profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RegisterScreen(role :"tutor")),
        );
      },
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
              label: "How It Works",
              icon: _icon("assets/icons/navigations/how-it-works.svg"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HowItWorksScreen()),
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
          return const Center(
            child: ShareCard(
              title: "Share with your Friends and Relatives",
              description:
                  "Help your friends and relatives to find the right tutor for their children by sharing our platform — and earn exclusive rewards!",
              link: "https://www.brighttuitioncare.com",
            ),
          );
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
            "assets/icons/navigations/share.svg",
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              AppColors.neutrals06,
              BlendMode.srcIn,
            ),
          ),
          activeIcon: SvgPicture.asset(
            "assets/icons/navigations/share.svg",
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              AppColors.primary01,
              BlendMode.srcIn,
            ),
          ),
          label: "Share the App",
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
