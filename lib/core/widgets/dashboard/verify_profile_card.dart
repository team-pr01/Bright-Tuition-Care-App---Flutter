import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/features/settings/prersentation/screens/verification_screen.dart';

class VerifyProfileCard extends StatelessWidget {
  final bool isVerified;

  const VerifyProfileCard({super.key, required this.isVerified});

  @override
  Widget build(BuildContext context) {
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
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
              // ============================================================
              // LEFT CONTENT
              // ============================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isVerified
                          ? "You are a verified member of Bright Tuition Care community."
                          : "Verify your profile to build trust, increase visibility, and get faster matches.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.neutrals03,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ========================================================
                    // VIEW / VERIFY BUTTON
                    // ========================================================
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

              // ============================================================
              // RIGHT ICON
              // ============================================================
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
