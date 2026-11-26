import 'package:btcclient/core/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/features/settings/prersentation/screens/verification_screen.dart';

class VerifyProfileCard extends StatelessWidget {
  final bool isVerified;
  final String role;
  final bool hasPostedAnyJob;
  final bool hasConfirmedAnyJob;

  const VerifyProfileCard({
    super.key,
    required this.isVerified,
    required this.role,
    this.hasPostedAnyJob = false,
    this.hasConfirmedAnyJob = false,
  });

  @override
  Widget build(BuildContext context) {
    // 👈 1. Logic for Description
    String getDescription() {
      if (isVerified) {
        return "You are a verified member of Bright Tuition Care community.";
      }

      if (role == "tutor") {
        if (hasConfirmedAnyJob) {
          return "Get exclusive benefits by completing your profile verification.";
        }
        return "Get exclusive benefits by completing your profile verification.";
      } else if (role == "guardian") {
        if (hasPostedAnyJob) {
          return "Submit a verification request to become a trusted member on the platform.";
        }
        return "Submit a verification request to become a trusted member on the platform.";
      }

      return "Get exclusive benefits by completing your profile verification.";
    }

    // 👈 2. Logic for "Recommended" Badge
    bool showRecommended = false;
    if (!isVerified) {
      if (role == "tutor" && hasConfirmedAnyJob) {
        showRecommended = true;
      } else if (role == "guardian" && hasPostedAnyJob) {
        showRecommended = true;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary03,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  "Verify Your Profile",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    fontSize: context.responsiveFontSize(
                      extraSmall: 14,
                      small: 18,
                      medium: 18,
                      large: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // 👈 3. Conditionally show the Badge
              if (showRecommended)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary01.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    "Recommended",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary01,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getDescription(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.neutrals03,
                      ),
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton(
                      onPressed: isVerified
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const VerificationScreen(),
                                ),
                              );
                            },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 7,
                        ),
                        minimumSize: Size.zero,
                        side: BorderSide(
                          color: AppColors.primary01,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        isVerified ? "Verified" : "Verify Now",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary01,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 25),
              SvgPicture.asset(
                "assets/icons/visual/verify-shield.svg",
                width: 70,
                height: 70,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
