import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/responsive/responsive.dart';
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
    final iconSize = context.responsiveValue<double>(
      extraSmall: 18,
      small: 20,
      medium: 22,
      large: 24,
    );

    final circlePadding = context.responsiveValue<double>(
      extraSmall: 10,
      small: 11,
      medium: 13,
      large: 14,
    );

    final labelFontSize = context.responsiveValue<double>(
      extraSmall: 8,
      small: 9,
      medium: 10,
      large: 11,
    );

    final spacing = context.responsiveValue<double>(
      extraSmall: 4,
      small: 5,
      medium: 6,
      large: 8,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Padding(
        padding: EdgeInsets.all(
          context.responsiveValue<double>(
            extraSmall: 2,
            small: 3,
            medium: 4,
            large: 4,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(circlePadding),
              decoration: const BoxDecoration(
                color: AppColors.primary01,
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: iconSize,
                height: iconSize,
                child: icon,
              ),
            ),

            SizedBox(height: spacing),

            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutrals03,
                    fontSize: labelFontSize,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}