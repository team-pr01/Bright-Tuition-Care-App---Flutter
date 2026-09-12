import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme.dart';
import '../../responsive/responsive.dart';

class HelplineCard extends StatelessWidget {
  final String phone;
  final String timing;
  final VoidCallback? onTap;

  const HelplineCard({
    super.key,
    required this.phone,
    required this.timing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------
    // RESPONSIVE VALUES
    // -------------------------------------------------------------------------

    final horizontalPadding = context.responsiveValue<double>(
      extraSmall: 4,
      small: 5,
      medium: 6,
      large: 8,
    );

    

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary03,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primaryGradientStart, width: 1.5),
        ),
        child: Row(
          children: [
            // -----------------------------------------------------------------
            // LEFT ICON
            // -----------------------------------------------------------------

            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                "assets/icons/visual/connection.svg",
                colorFilter: const ColorFilter.mode(
                  AppColors.primary01,
                  BlendMode.srcIn,
                ),
              ),
            ),

            SizedBox(width: 12),

            // -----------------------------------------------------------------
            // PHONE + TIMING
            // -----------------------------------------------------------------

            Expanded(
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "$phone ",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: AppColors.backgroundDark,
                        ),
                      ),
                      TextSpan(
                        text: " ($timing)",
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: AppColors.backgroundDark,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}