import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/reusable_bottom_sheet/reusable_bottom_sheet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RefundPolicySheet extends StatelessWidget {
  const RefundPolicySheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ReusableBottomSheet(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(
              "Refund Policy",
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            /// INTRO
            Text(
              "At Bright Tuition Care, we maintain a clear and fair refund policy for our tutors. "
              "If a tutor loses a tuition job for a valid reason, they may apply for a partial refund "
              "of the paid service charge under the following conditions:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 16),

            /// VALID REASON
            Text(
              "• Valid Reason",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: AppColors.neutrals02,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "The discontinuation must be due to a genuine issue from the guardian or student’s side.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 12),

            /// REFUND AMOUNT
            Text(
              "• Refund Amount",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: AppColors.neutrals02,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "If a confirmed tuition is cancelled by the guardian within the first month, "
              "the tutor may receive 30% of the paid service charge.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 12),

            /// IMMEDIATE NOTIFICATION
            Text(
              "• Immediate Notification",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: AppColors.neutrals02,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyLarge,
                children: [
                  const TextSpan(
                    text:
                        "Tutors must inform our team immediately by calling our helpline: ",
                  ),
                  TextSpan(
                    text: "09617-785588",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.primary01,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final Uri uri = Uri.parse("tel:09617785588");

                        if (!await launchUrl(uri)) {
                          debugPrint("Could not launch dialer");
                        }
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            /// INVESTIGATION PROCESS
            Text(
              "• Investigation Process",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: AppColors.neutrals02,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "If cancellation occurs due to the tutor’s fault, negligence, or failure to fulfill responsibilities, "
              "no refund will be issued.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
