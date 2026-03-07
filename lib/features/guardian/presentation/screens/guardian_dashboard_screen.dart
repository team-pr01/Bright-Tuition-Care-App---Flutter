
import 'package:btcclient/core/layout/dashboard_layout.dart';
import 'package:btcclient/core/widgets/navbar/side_drawer.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:btcclient/features/auth/presentation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuardianDashboardScreen extends ConsumerWidget {
  const GuardianDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
return DashboardLayout(

  drawerBuilder: (changeTab) => AppSidebar(
    user: user!,

    menuItems: [
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text("Home"),
        onTap: () {
          Navigator.pop(context);
          changeTab(0);
        },
      ),

      ListTile(
        leading: const Icon(Icons.work),
        title: const Text("Jobs"),
        onTap: () {
          Navigator.pop(context);
          changeTab(1);
        },
      ),

      ListTile(
        leading: const Icon(Icons.chat),
        title: const Text("Messages"),
        onTap: () {
          Navigator.pop(context);
          changeTab(2);
        },
      ),

      ListTile(
        leading: const Icon(Icons.school),
        title: const Text("Students"),
        onTap: () {
          Navigator.pop(context);
          changeTab(3);
        },
      ),

      ListTile(
        leading: const Icon(Icons.person),
        title: const Text("Profile"),
        onTap: () {
          Navigator.pop(context);
          changeTab(4);
        },
      ),
    ],

    /// sidebar extra links
    menuItemsCommon: [
      ListTile(
        leading: const Icon(Icons.settings),
        title: const Text("Settings"),
        onTap: () {},
      ),

      ListTile(
        leading: const Icon(Icons.help),
        title: const Text("Help"),
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

  pages: const [
    Center(child: Text("Home")),
    Center(child: Text("Jobs")),
    Center(child: Text("Messages")),
    Center(child: Text("Students")),
    Center(child: Text("Profile")),
  ],

  navItems: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.work), label: "Jobs"),
    BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Messages"),
    BottomNavigationBarItem(icon: Icon(Icons.school), label: "Students"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  ],
); }
}
