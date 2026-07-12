import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';

class ProfileTabCard extends StatelessWidget {
  final String title;

  final String subtitle;

  final IconData icon;

  final bool isActive;

  final bool isCompleted;

  final VoidCallback onTap;

  const ProfileTabCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isActive,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: SizedBox(
        width: 70,

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            /// ================= ICON SECTION =================

            Stack(
              clipBehavior: Clip.none,

              children: [

                /// ICON BG

                AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 250),

                  width: 48,
                  height: 48,

                  decoration: BoxDecoration(

                    /// 🔥 ACTIVE = GRADIENT
                    gradient: isActive
                        ? const LinearGradient(
                            colors: [
                              AppColors.primary01,
                              AppColors.primary01,
                            ],
                          )

                        /// 🔥 INACTIVE = GREY
                        : null,

                    color: isActive
                        ? null
                        : AppColors.neutrals05,

                    shape: BoxShape.circle,

                    boxShadow: [
                      BoxShadow(
                        color: isActive
                            ? AppColors.primary01
                                .withOpacity(0.15)
                            : Colors.black
                                .withOpacity(0.05),

                        blurRadius: 12,

                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: Icon(
                    icon,

                    size: 24,

                    color: isActive
                            ? AppColors.neutrals01
                            : const Color.fromARGB(255, 82, 82, 82)

                  ),
                ),

                /// COMPLETED TICK

                if (isCompleted)
                  Positioned(
                    top: 0,
                    right: -2,

                    child: Container(
                      width: 16,
                      height: 16,

                      decoration: BoxDecoration(
                        color: AppColors.primary01,

                        shape: BoxShape.circle,

                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),

                      child: const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            /// ================= TITLE =================

            Text(
              title,

              textAlign: TextAlign.center,

              style: AppTextStyles.labelSmall.copyWith(
                color: isActive
                    ? AppColors.primary01
                    : AppColors.neutrals02,
              ),
            ),
          ],
        ),
      ),
    );
  }
}