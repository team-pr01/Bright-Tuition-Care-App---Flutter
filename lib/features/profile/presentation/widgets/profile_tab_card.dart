import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';

class ProfileTabCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const ProfileTabCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive
                  ? AppColors.primary01
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? AppColors.primary01
                    : Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 8),

            Icon(
              icon,
              size: 18,
              color: isActive
                  ? AppColors.primary01
                  : Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }
}