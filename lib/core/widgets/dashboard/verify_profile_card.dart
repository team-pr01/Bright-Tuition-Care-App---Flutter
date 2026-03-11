import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:btcclient/core/config/theme.dart';

class VerifyProfileCard extends StatelessWidget {
  const VerifyProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutrals05, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// ICON
          SvgPicture.asset(
            "assets/icons/visual/verify-shield.svg",
            width: 70,
            height: 70,
          ),

          const SizedBox(height: 16),

          /// TITLE
          Text(
            "Verify Your Profile",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 6),

          /// DESCRIPTION
          Text(
            "Verify your profile to build trust and ensure a safe learning environment. "
            "Verified accounts get higher visibility and faster matches. "
            "Complete verification to start connecting confidently.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.neutrals03,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 14),

          /// BUTTON
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              side: const BorderSide(color: AppColors.primary01, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {},
            child: Text(
              "Verify Now",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.primary01,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
