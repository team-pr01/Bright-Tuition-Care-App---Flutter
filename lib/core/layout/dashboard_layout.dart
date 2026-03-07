import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/navbar/bottom_navbar.dart';
import 'package:flutter/material.dart';

class DashboardLayout extends StatefulWidget {
  final List<Widget> pages;
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
  int currentIndex = 0;

  void changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.drawerBuilder(changeTab),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
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
                      icon: const Icon(Icons.menu),
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
                    height: 28,
                    fit: BoxFit.contain,
                  ),
                ),

                /// RIGHT NOTIFICATION BUTTON
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {
                      // TODO: open notifications screen
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: widget.pages[currentIndex],
      ),

      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        items: widget.navItems,
        onTap: changeTab,
      ),
    );
  }
}
