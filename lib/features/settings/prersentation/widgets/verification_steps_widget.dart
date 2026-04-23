import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/features/settings/prersentation/enums/verification_status.dart';
import 'package:flutter/material.dart';

class VerificationStepsWidget extends StatelessWidget {
  final VerificationStatus currentStep;
  final String? addressVerificationCode;

  const VerificationStepsWidget({
    super.key,
    required this.currentStep,
    this.addressVerificationCode,
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
            Text(
              "Profile Verification",
              style: theme.textTheme.headlineSmall,
            ),

            /// PROGRESS CIRCLE
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary01,
                  width: 4,
                ),
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
            final isCompleted = index < currentIndex;
            final isCurrent = index == currentIndex;

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
                    border: Border.all(
                      color: AppColors.primary01,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : Text("${index + 1}"),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Step ${index + 1}",
                  style: theme.textTheme.bodySmall,
                ),
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
            final isCurrent = index == currentIndex;
            final isCompleted = index < currentIndex;

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
                children: [
                  Icon(
                    isCompleted ? Icons.check_circle : Icons.circle,
                    color: isCompleted
                        ? Colors.green
                        : AppColors.primary01,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      getStepTitle(step),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  if (isCurrent)
                    const Text("Current",
                        style: TextStyle(color: AppColors.primary01)),
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
        return const Text("Pay Verification Fee (TODO)");

      case VerificationStatus.addressVerification:
        return const Text("Enter Address Code (TODO)");

      case VerificationStatus.verified:
        return const Text("Verification Successful");

    }
  }

  Widget _statusMessage(VerificationStatus step) {
    String text;

    switch (step) {
      case VerificationStatus.pending:
        text = "Your request has been submitted";
        break;
      case VerificationStatus.accepted:
        text = "Your request is accepted";
        break;
      case VerificationStatus.reviewing:
        text = "Documents are under review";
        break;
      default:
        text = "";
    }

    return Center(child: Text(text));
  }
}


