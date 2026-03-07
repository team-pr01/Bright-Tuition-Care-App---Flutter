import 'package:btcclient/core/layout/dashboard_layout.dart';
import 'package:btcclient/core/widgets/navbar/side_drawer.dart';
import 'package:btcclient/core/widgets/navbar/sidebar_item.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:btcclient/features/auth/presentation/screens/welcome_screen.dart';
import 'package:btcclient/features/tutor/presentation/job_board.dart';
import 'package:btcclient/features/tutor/presentation/tutor_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TutorDashboardScreen extends ConsumerWidget {
  const TutorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return DashboardLayout(
      drawerBuilder: (changeTab) => AppSidebar(
        user: user!,

        menuItems: [
          SidebarItem(
            label: "Home",
            icon: Icons.home,
            onTap: () {
              Navigator.pop(context);
              changeTab(0);
            },
          ),
          SidebarItem(
            label: "Jobs",
            icon: Icons.work,
            onTap: () {
              Navigator.pop(context);
              changeTab(1);
            },
          ),
          SidebarItem(
            label: "Messages",
            icon: Icons.chat,
            onTap: () {
              Navigator.pop(context);
              changeTab(2);
            },
          ),
          SidebarItem(
            label: "Students",
            icon: Icons.school,
            onTap: () {
              Navigator.pop(context);
              changeTab(3);
            },
          ),

          SidebarItem(
            label: "Profile",
            icon: Icons.person,
            onTap: () {
              Navigator.pop(context);
              changeTab(4);
            },
          ),
        ],

        /// sidebar extra links
        menuItemsCommon: [
          SidebarItem(label: "Settings", icon: Icons.settings, onTap: () {}),

          SidebarItem(label: "Help", icon: Icons.help, onTap: () {}),
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

      pages: const [
        TutorHomeScreen(),
        TutorJobsScreen(),
      ],

      //       pages: const [

      //   JobsScreen(),
      //   MessagesScreen(),
      //   StudentsScreen(),
      //   ProfileScreen(),
      // ],
      navItems: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.work), label: "Jobs"),
        // BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Messages"),
        // BottomNavigationBarItem(icon: Icon(Icons.school), label: "Students"),
        // BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
