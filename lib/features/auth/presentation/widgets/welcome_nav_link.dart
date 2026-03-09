import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';

class WelcomeNavLink extends StatelessWidget {
  final Widget icon;
  final String label;

  const WelcomeNavLink({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primary01,
            shape: BoxShape.circle,
          ),
          child: icon, // ✅ correct
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
    );
  }
}