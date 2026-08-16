import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/theme.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary03,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primaryGradientStart, width: 1.5),
        ),
        child: Row(
          children: [
            /// LEFT ICON
            SvgPicture.asset(
              "assets/icons/visual/connection.svg",
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.primary01,
                BlendMode.srcIn,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: AppColors.neutrals03,
                    ),
                    children: [
                      TextSpan(
                        text: "$phone ",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: AppColors.backgroundDark,
                        ),
                      ),
                      TextSpan(
                        text: " ($timing)",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: AppColors.backgroundDark,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// RIGHT ICON
            // SvgPicture.asset(
            //   "assets/icons/visual/send.svg",
            //   width: 24,
            //   height: 24,
            //   colorFilter: const ColorFilter.mode(
            //     AppColors.primary01,
            //     BlendMode.srcIn,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
