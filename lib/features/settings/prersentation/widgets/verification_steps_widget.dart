import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/features/invoices/data/models/invoice_model.dart';
import 'package:btcclient/features/settings/prersentation/enums/verification_status.dart';
import 'package:btcclient/features/settings/prersentation/widgets/address_verification_form.dart';
import 'package:btcclient/features/settings/prersentation/widgets/pay_verification_fee_form.dart';
import 'package:btcclient/features/settings/prersentation/widgets/verification_success.dart';
import 'package:flutter/material.dart';

class VerificationStepsWidget extends StatelessWidget {
  final VerificationStatus currentStep;
  final String? addressVerificationCode;
  final InvoiceModel? invoice;
  final VoidCallback onPay;

  const VerificationStepsWidget({
    super.key,
    required this.currentStep,
    this.addressVerificationCode,
    required this.invoice,
    required this.onPay,
  });

  int getCurrentIndex() {
    return VerificationStatus.values.indexOf(currentStep);
  }

  String getStepTitle(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.pending:
        return "Request Pending";
      case VerificationStatus.accepted:
        return "Request Accepted";
      case VerificationStatus.reviewing:
        return "Reviewing";
      case VerificationStatus.invoiceDue:
        return "Invoice Due";
      case VerificationStatus.addressVerification:
        return "Address Verification";
      case VerificationStatus.verified:
        return "Verified";
    }
  }

  String getStepDescription(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.pending:
        return "Your verification request has been submitted";
      case VerificationStatus.accepted:
        return "Your verification request has been accepted";
      case VerificationStatus.reviewing:
        return "Your documents are being reviewed";
      case VerificationStatus.invoiceDue:
        return "Your documents are being reviewed";
      case VerificationStatus.addressVerification:
        return "Enter verification code which you've received by notification";
      case VerificationStatus.verified:
        return "Verification completed successfully";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final steps = VerificationStatus.values;
    final currentIndex = getCurrentIndex();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Profile Verification", style: theme.textTheme.headlineSmall),

            /// PROGRESS CIRCLE
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary01, width: 4),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "${currentIndex + 1}/${steps.length}",
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        /// PROGRESS BAR
        LinearProgressIndicator(
          value: (currentIndex + 1) / steps.length,
          color: AppColors.primary01,
          backgroundColor: AppColors.neutrals04,
        ),

        const SizedBox(height: AppSpacing.lg),

        /// STEP INDICATORS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length, (index) {
            final bool isVerifiedFlow =
                currentStep == VerificationStatus.verified;
            final isCurrent = !isVerifiedFlow && index == currentIndex;
            final isCompleted = isVerifiedFlow
                ? index <= currentIndex
                : index < currentIndex;

            return Column(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.primary01
                        : isCurrent
                        ? Colors.white
                        : AppColors.neutrals04,
                    border: Border.all(color: AppColors.primary01),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : Text("${index + 1}"),
                  ),
                ),
                const SizedBox(height: 4),
                Text("Step ${index + 1}", style: theme.textTheme.bodySmall),
              ],
            );
          }),
        ),

        const SizedBox(height: AppSpacing.lg),

        /// STEP CONTENT
        _buildStepContent(currentStep),

        const SizedBox(height: AppSpacing.lg),

        /// STEP LIST (like React)
        Column(
          children: steps.map((step) {
            final index = steps.indexOf(step);
            final bool isVerifiedFlow =
                currentStep == VerificationStatus.verified;
            final isCurrent = !isVerifiedFlow && index == currentIndex;
            final isCompleted = isVerifiedFlow
                ? index <= currentIndex
                : index < currentIndex;

            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppColors.primary01.withOpacity(0.1)
                    : isCompleted
                    ? Colors.green.withOpacity(0.1)
                    : AppColors.neutrals04,
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isCompleted ? Icons.check_circle : Icons.circle,
                    color: isCompleted ? Colors.green : AppColors.primary01,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getStepTitle(step),
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          getStepDescription(step),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (isCurrent)
                    const Text(
                      "Current",
                      style: TextStyle(color: AppColors.primary01),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStepContent(VerificationStatus step) {
    switch (step) {
      case VerificationStatus.pending:
      case VerificationStatus.accepted:
      case VerificationStatus.reviewing:
        return _statusMessage(step);

      case VerificationStatus.invoiceDue:
        return PayVerificationFeeForm(invoice: invoice, onPay: onPay);

      case VerificationStatus.addressVerification:
        return AddressVerificationForm(
          addressCodeFromApi: addressVerificationCode,
        );

      case VerificationStatus.verified:
        return verificationSuccess();
    }
  }

  Widget _statusMessage(VerificationStatus step) {
    String title = "";
    String text = "";

    IconData icon = Icons.access_time_filled;

    Color iconColor = Colors.grey.shade500;

    bool isLoading = false;

    switch (step) {
      /// ================= PENDING =================
      case VerificationStatus.pending:
        title = "Request Submitted";

        text =
            "Your verification request has been submitted. Our team will review it shortly.";

        icon = Icons.access_time_filled;

        iconColor = Colors.grey.shade500;

        isLoading = false;

        break;

      /// ================= ACCEPTED =================
      case VerificationStatus.accepted:
        title = "Request Accepted";

        text =
            "Your request has been accepted. Document review will begin shortly.";

        icon = Icons.autorenew;

        iconColor = Colors.orange;

        isLoading = true;

        break;

      /// ================= REVIEWING =================
      case VerificationStatus.reviewing:
        title = "Under Review";

        text =
            "Your documents are currently under review. This may take 24–48 hours.";

        icon = Icons.autorenew;

        iconColor = Colors.orange;

        isLoading = true;

        break;

      default:
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.lg,
      ),

      child: Column(
        children: [
          /// ================= ICON =================
          Container(
            width: 60,
            height: 60,

            decoration: BoxDecoration(
              color: Colors.grey.shade100,

              shape: BoxShape.circle,
            ),

            child: Center(
              child: isLoading
                  ? TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),

                      duration: const Duration(seconds: 1),

                      builder: (context, value, child) {
                        return Transform.rotate(
                          angle: value * 6.3,

                          child: child,
                        );
                      },

                      onEnd: () {},

                      child: Icon(icon, size: 26, color: iconColor),
                    )
                  : Icon(icon, size: 26, color: iconColor),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          /// ================= TITLE =================
          Text(
            title,

            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.neutrals02,
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          /// ================= DESCRIPTION =================
          Text(
            text,

            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 16,
              height: 1.2,
              color: AppColors.neutrals03,
            ),
          ),
        ],
      ),
    );
  }
}
