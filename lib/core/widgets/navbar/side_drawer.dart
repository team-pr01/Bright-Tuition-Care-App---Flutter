import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/navbar/profile_section.dart';
import 'package:btcclient/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final UserModel? user;
  final List<Widget> menuItems;
  final List<Widget> menuItemsCommon;

  /// Used only when an authenticated user is logged in.
  final VoidCallback? onLogout;

  /// Optional action for guests.
  /// Usually this should open the login screen.
  final VoidCallback? onLogin;

  const AppSidebar({
    super.key,
    required this.user,
    required this.menuItems,
    required this.menuItemsCommon,
    this.onLogout,
    this.onLogin,
  });

  bool get isGuest => user == null;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 264,
      backgroundColor: AppColors.primary01,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // =====================================================
            // USER / GUEST HEADER
            // =====================================================

            if (user != null)
              ProfileSection(
                name: user!.name,
                role: user!.role,
                profilePicture: user!.profilePicture,
                isVerified: user!.isVerified,
                roleBasedId: user!.roleBasedId,
                createdAt: user!.createdAt,
              )
            else
              _buildGuestHeader(context),

            _divider(),

            // =====================================================
            // MENU
            // =====================================================

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  // horizontal: AppSpacing.lg,
                ),
                children: [
                  ...menuItems,

                  if (menuItems.isNotEmpty && menuItemsCommon.isNotEmpty)
                    _divider(),

                  ...menuItemsCommon,
                ],
              ),
            ),

            // =====================================================
            // AUTH ACTION
            // =====================================================

            _buildAuthAction(context),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // GUEST HEADER
  // ===============================================================

  Widget _buildGuestHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        12,
        AppSpacing.lg,
        8,
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Welcome Guest',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Sign in to access your account',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // DIVIDER
  // ===============================================================

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      child: Divider(
        color: AppColors.neutrals05,
        thickness: 1.5,
      ),
    );
  }

  // ===============================================================
  // LOGIN / SIGN OUT
  // ===============================================================

  Widget _buildAuthAction(BuildContext context) {
    if (isGuest) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          8,
          AppSpacing.lg,
          12,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.login_rounded,
            color: AppColors.neutrals01,
          ),
          title: const Text(
            'Sign In',
            style: TextStyle(
              color: AppColors.neutrals01,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: onLogin,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        8,
        AppSpacing.lg,
        12,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Transform.rotate(
          angle: 3.1416,
          child: const Icon(
            Icons.logout,
            color: AppColors.neutrals01,
          ),
        ),
        title: const Text(
          'Sign Out',
          style: TextStyle(
            color: AppColors.neutrals01,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onLogout,
      ),
    );
  }
}