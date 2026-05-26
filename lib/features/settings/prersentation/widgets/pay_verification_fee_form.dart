import 'package:btcclient/core/config/theme.dart';

import 'package:btcclient/core/widgets/button/app_button.dart';

import 'package:btcclient/features/invoices/data/models/invoice_model.dart';

import 'package:flutter/material.dart';

class PayVerificationFeeForm extends StatelessWidget {
  final InvoiceModel? invoice;

  final VoidCallback onPay;

  const PayVerificationFeeForm({
    super.key,
    required this.invoice,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),

      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),

        borderRadius: BorderRadius.circular(AppRadius.large),

        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),

      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              /// ================= ICON =================
              Container(
                width: 52,
                height: 52,

                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),

                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.payments_outlined,

                  color: Colors.orange,

                  size: 28,
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              /// ================= CONTENT =================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Invoice Payment Required",

                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),
                  ],
                ),
              ),
            ],
          ),
             const SizedBox(height: AppSpacing.md),
          Text(
            "Pay the profile verification charge to proceed to the next step.",

            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.neutrals03,

            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          /// ================= INVOICE BOX =================
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(AppRadius.medium),

              border: Border.all(color: Colors.orange.withOpacity(0.1)),
            ),

            child: Column(
              children: [
                _row("Verification Fee", "500 BDT"),

                const SizedBox(height: AppSpacing.sm),

                _row(
                  "Invoice ID",

                  invoice == null ? "Please wait..." : invoice!.invoiceId,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          /// ================= BUTTON =================
          AppButton(
            label: "Pay Verification Fee",

            icon: Icons.currency_exchange,

            variant: AppButtonVariant.gradient,

            onPressed: invoice == null ? null : onPay,
          ),
        ],
      ),
    );
  }

  Widget _row(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(key, style: TextStyle(color: AppColors.neutrals03)),

        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
