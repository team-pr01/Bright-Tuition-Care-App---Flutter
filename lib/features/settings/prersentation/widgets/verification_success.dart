import 'package:btcclient/core/config/theme.dart';

import 'package:flutter/material.dart';

Widget verificationSuccess() {

  return Center(
    child: Container(

      width: double.infinity,

      padding: const EdgeInsets.all(
        AppSpacing.xl,
      ),

      decoration: BoxDecoration(

        color:
            Colors.green.withOpacity(
          0.05,
        ),

        borderRadius:
            BorderRadius.circular(
          AppRadius.large,
        ),

        border: Border.all(
          color:
              Colors.green.withOpacity(
            0.15,
          ),
        ),
      ),

      child: Column(
        mainAxisSize:
            MainAxisSize.min,

        children: [

          /// ================= ICON =================
          Container(
            width: 90,
            height: 90,

            decoration: BoxDecoration(
              color:
                  Colors.green
                      .withOpacity(
                0.1,
              ),

              shape:
                  BoxShape.circle,
            ),

            child: const Icon(
              Icons.verified,

              size: 50,

              color: Colors.green,
            ),
          ),

          const SizedBox(
            height:
                AppSpacing.lg,
          ),

          /// ================= TITLE =================
          Text(
            "Verification Complete 🎉",

            textAlign:
                TextAlign.center,

            style: AppTextStyles
                .headlineSmall
                .copyWith(
              color: Colors.green,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(
            height:
                AppSpacing.sm,
          ),

          /// ================= DESCRIPTION =================
          Text(
            "Your profile has been successfully verified.",

            textAlign:
                TextAlign.center,

            style: AppTextStyles
                .bodyMedium
                .copyWith(
              color:
                  AppColors
                      .neutrals03,
              height: 1.5,
            ),
          ),
        ],
      ),
    ),
  );
}