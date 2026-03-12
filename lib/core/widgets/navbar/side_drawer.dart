import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/navbar/profile_section.dart';
import 'package:btcclient/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final UserModel user;
  final List<Widget> menuItems;
  final List<Widget> menuItemsCommon;
  final VoidCallback onLogout;

  const AppSidebar({
    super.key,
    required this.user,
    required this.menuItems,
    required this.menuItemsCommon,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      width: 244,
      backgroundColor: AppColors.primary01,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Center(
              child: Image.asset(
                "assets/images/logo-white.png",
                height: 38,
                fit: BoxFit.contain,
              ),
            ),

            /// USER HEADER
            ProfileSection(
              name: user.name,
              role: user.role,
              profilePicture: user.profilePicture,
              isVerified: user.isVerified,
              roleBasedId: user.roleBasedId,
              createdAt: user.createdAt,
              extraLine1: "Children: 2",
            ),
            Text(user.email),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Divider(color: AppColors.neutrals05, thickness: 1.5),
            ),

            /// MENU ITEMS
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                children: [
                  ...menuItems,

                  Divider(color: AppColors.neutrals05, thickness: 1.5),

                  ...menuItemsCommon,
                ],
              ),
            ),

            /// LOGOUT BUTTON
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: ListTile(
                leading: Transform.rotate(
                  angle: 3.1416,
                  child: const Icon(Icons.logout, color: AppColors.neutrals01),
                ),
                title: const Text(
                  "Sign Out",
                  style: TextStyle(color: AppColors.neutrals01),
                ),
                onTap: onLogout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
