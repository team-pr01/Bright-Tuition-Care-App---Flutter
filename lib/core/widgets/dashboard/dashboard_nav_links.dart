import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/responsive/responsive.dart';
import 'package:btcclient/core/utils/number_formatter.dart';
import 'package:flutter/material.dart';

class DashboardNavLinks extends StatelessWidget {
  final Widget icon;
  final String label;
  final int count;
  final VoidCallback? onTap;
  final bool isSelected;

  const DashboardNavLinks({
    super.key,
    required this.icon,
    required this.label,
    this.count = 0,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------
    // RESPONSIVE VALUES
    // -------------------------------------------------------------------------

    final outerPadding = context.responsiveValue<double>(
      extraSmall: 2,
      small: 3,
      medium: 4,
      large: 4,
    );

    final circlePadding = context.responsiveValue<double>(
      extraSmall: 9,
      small: 10,
      medium: 12,
      large: 14,
    );

    final iconSize = context.responsiveValue<double>(
      extraSmall: 18,
      small: 20,
      medium: 22,
      large: 24,
    );

    final labelSpacing = context.responsiveValue<double>(
      extraSmall: 4,
      small: 5,
      medium: 6,
      large: 7,
    );

    final labelFontSize = context.responsiveFontSize(
      extraSmall: 9,
      small: 10,
      medium: 11,
      large: 12,
    );

    final badgeSize = context.responsiveValue<double>(
      extraSmall: 15,
      small: 16,
      medium: 18,
      large: 20,
    );

    final badgeBorderWidth = context.responsiveValue<double>(
      extraSmall: 1.5,
      small: 1.5,
      medium: 2,
      large: 2,
    );

    final badgeIconSize = context.responsiveValue<double>(
      extraSmall: 8,
      small: 9,
      medium: 10,
      large: 11,
    );

    final badgeOffset = context.responsiveValue<double>(
      extraSmall: -1,
      small: -1,
      medium: -2,
      large: -2,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        context.responsiveValue<double>(
          extraSmall: 10,
          small: 11,
          medium: 12,
          large: 14,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(outerPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // -----------------------------------------------------------------
            // ICON + SELECTED BADGE
            // -----------------------------------------------------------------

            Stack(
              clipBehavior: Clip.none,
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

                // -------------------------------------------------------------
                // SELECTED BADGE
                // -------------------------------------------------------------

                if (isSelected)
                  Positioned(
                    top: badgeOffset,
                    right: badgeOffset,
                    child: Container(
                      height: badgeSize,
                      width: badgeSize,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: badgeBorderWidth,
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        size: badgeIconSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),

            // -----------------------------------------------------------------
            // LABEL
            // -----------------------------------------------------------------

            SizedBox(height: labelSpacing),

            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w300,
                    color: AppColors.neutrals02,
                    fontSize: labelFontSize,
                  ),
            ),

            // -----------------------------------------------------------------
            // COUNT
            // -----------------------------------------------------------------

            Text(
              formatNumber(count),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w300,
                    color: AppColors.neutrals02,
                    fontSize: labelFontSize,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}