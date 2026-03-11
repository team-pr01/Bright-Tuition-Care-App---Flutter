import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/layout/dashboard_layout.dart';
import 'package:btcclient/core/widgets/navbar/side_drawer.dart';
import 'package:btcclient/core/widgets/navbar/sidebar_item.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:btcclient/features/auth/presentation/screens/welcome_screen.dart';
import 'package:btcclient/features/guardian/presentation/screens/guardian_dashboard.dart';
import 'package:btcclient/features/tutor/presentation/screens/job_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GuardianDashboardScreen extends ConsumerWidget {
  const GuardianDashboardScreen({super.key});
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DashboardLayout(
      drawerBuilder: (changeTab) => AppSidebar(
        user: user,

        menuItems: [
          SidebarItem(
            label: "Home",
            icon: SvgPicture.asset(
              "assets/icons/navigations/dashboard-square.svg",
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            onTap: () {},
          ),
          SidebarItem(
            label: "Job Board",
            icon: SvgPicture.asset(
              "assets/icons/navigations/job-board.svg",
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            onTap: () {},
          ),
          SidebarItem(
            label: "How it Works",
            icon: SvgPicture.asset(
              "assets/icons/navigations/how-it-works.svg",
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              changeTab(2);
            },
          ),
          SidebarItem(
            label: "Profile",
            icon: SvgPicture.asset(
              "assets/icons/navigations/user-circle.svg",
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              changeTab(3);
            },
          ),

          SidebarItem(
            label: "Payments",
            icon: SvgPicture.asset(
              "assets/icons/navigations/payment.svg",
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              changeTab(4);
            },
          ),
          SidebarItem(
            label: "Settings",
            icon: SvgPicture.asset(
              "assets/icons/navigations/settings.svg",
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              changeTab(4);
            },
          ),
        ],

        /// sidebar extra links
        menuItemsCommon: [
          SidebarItem(
            label: "Refer and Earn",
            icon: SvgPicture.asset(
              "assets/icons/navigations/refer.svg",
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            onTap: () {},
          ),
        ],

        onLogout: () async {
          await ref.read(authProvider.notifier).logout();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            (route) => false,
          );
        },
      ),

      pages: [
  (changeTab) => const TutorJobsScreen(),
  (changeTab) => const TutorJobsScreen(),
  (changeTab) => GuardianHomeScreen(),
  (changeTab) => const TutorJobsScreen(),
  (changeTab) => const TutorJobsScreen(),
],

      //       pages: const [

      //   JobsScreen(),
      //   MessagesScreen(),
      //   StudentsScreen(),
      //   ProfileScreen(),
      // ],
       navItems: [
         BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/icons/navigations/posting.svg",
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(AppColors.neutrals06, BlendMode.srcIn),
          ),
          activeIcon: SvgPicture.asset(
            "assets/icons/navigations/posting.svg",
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(
              AppColors.primary01,
              BlendMode.srcIn,
            ),
          ),
          label: "Posting",
        ),

        
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/icons/navigations/job-search.svg",
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(AppColors.neutrals06, BlendMode.srcIn),
          ),
          activeIcon: SvgPicture.asset(
            "assets/icons/navigations/job-search.svg",
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(
              AppColors.primary01,
              BlendMode.srcIn,
            ),
          ),
          label: "Job Board",
        ),

       /// CENTER HOME
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/icons/navigations/dashboard-square.svg",
            width: 26,
            height: 26,
            colorFilter: const ColorFilter.mode(AppColors.neutrals06, BlendMode.srcIn),
          ),
          activeIcon: SvgPicture.asset(
           "assets/icons/navigations/dashboard-square.svg",
            width: 26,
            height: 26,
            colorFilter: ColorFilter.mode(
              AppColors.primary01,
              BlendMode.srcIn,
            ),
          ),
          label: "Dashboard",
        ),

        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/icons/navigations/payment.svg",
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(AppColors.neutrals06, BlendMode.srcIn),
          ),
          activeIcon: SvgPicture.asset(
            "assets/icons/navigations/payment.svg",
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(
              AppColors.primary01,
              BlendMode.srcIn,
            ),
          ),
          label: "Payments",
        ),

        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/icons/navigations/user-circle.svg",
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(AppColors.neutrals06, BlendMode.srcIn),
          ),
          activeIcon: SvgPicture.asset(
            "assets/icons/navigations/user-circle.svg",
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(
              AppColors.primary01,
              BlendMode.srcIn,
            ),
          ),
          label: "Profile",
        ),
      ],
   
    );
  }
}
