import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:flutter/material.dart';

Widget payVerificationFeeForm({
  required ThemeData theme,
  required String invoiceId,
  required VoidCallback onPay,
}) {
  return Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: Colors.orange.withOpacity(0.05),
      borderRadius: BorderRadius.circular(AppRadius.large),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Invoice Payment Required",
            style: theme.textTheme.titleMedium),

        const SizedBox(height: AppSpacing.sm),

        Text("Pay verification fee to continue",
            style: theme.textTheme.bodySmall),

        const SizedBox(height: AppSpacing.md),

        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.neutrals01,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Column(
            children: [
              _row("Fee", "500 BDT"),
              _row("Invoice ID", invoiceId),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        AppButton(
          label: "Pay Verification Fee",
          variant: AppButtonVariant.gradient,
          onPressed: onPay,
        ),
      ],
    ),
  );
}

Widget _row(String k, String v) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [Text(k), Text(v)],
  );
}