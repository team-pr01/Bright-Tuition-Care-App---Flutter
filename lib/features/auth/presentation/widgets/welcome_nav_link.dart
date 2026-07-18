import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';

class WelcomeNavLink extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  const WelcomeNavLink({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: AppColors.primary01,
                shape: BoxShape.circle,
              ),
              child: icon,
            ),

            const SizedBox(height: 6),

            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w300,
                    color: AppColors.neutrals03,
                    fontSize: 11,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}