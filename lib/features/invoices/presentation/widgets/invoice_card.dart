import 'package:btcclient/core/utils/date_formatter.dart';
import 'package:btcclient/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/theme.dart';
import '../../../../core/widgets/button/app_button.dart';

import '../../data/models/invoice_model.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
 

  final VoidCallback onView;

  const InvoiceCard({super.key, required this.invoice, required this.onView});

  @override
  Widget build(BuildContext context) {
    final isPaid = invoice.status == "paid";

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),

      padding: const EdgeInsets.all(AppSpacing.md),

      decoration: BoxDecoration(
        color: AppColors.neutrals01,

        borderRadius: BorderRadius.circular(AppRadius.large),

        border: Border.all(color: AppColors.primary01.withOpacity(0.08)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// ================= TOP =================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// ================= ICON =================
              Container(
                height: 54,
                width: 54,

                decoration: BoxDecoration(
                  color: AppColors.primary02,

                  borderRadius: BorderRadius.circular(14),
                ),

                child: Icon(
                  Icons.receipt_long,

                  color: AppColors.primary01,

                  size: 28,
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              /// ================= TITLE =================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      invoice.invoiceType == "verificationCharge"
                          ? "Verification Charge"
                          : "Platform Charge",

                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xs),

                    Text(
                      "Invoice ID: ${invoice.invoiceId}",

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.neutrals03,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              /// ================= STATUS =================
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),

                decoration: BoxDecoration(
                  color: isPaid ? AppColors.success : AppColors.error,

                  borderRadius: BorderRadius.circular(100),
                ),

                child: Text(
                  invoice.status.toUpperCase(),

                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,

                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          Divider(color: AppColors.neutrals04, thickness: 1),

          const SizedBox(height: AppSpacing.md),

          /// ================= DETAILS =================
          _infoRow(
            title: "Amount",
            value: "${invoice.amount} BDT",
            isBold: true,
          ),

          const SizedBox(height: AppSpacing.sm),

          _infoRow(
            title: "Invoice Type",
            value: invoice.invoiceType == "verificationCharge"
                ? "Verification Charge"
                : "Platform Charge",
          ),

          if (invoice.jobId != null) ...[
            const SizedBox(height: AppSpacing.sm),

            _infoRow(title: "Job ID", value: invoice.jobId!),
          ],

          const SizedBox(height: AppSpacing.sm),

          _infoRow(
            title: isPaid ? "Paid Date" : "Due Date",

            value: isPaid
                ? ( DateFormatter.formattedDate(invoice.paidDate ?? "") ?? "N/A")
                : ( DateFormatter.formattedDate(invoice.dueDate ?? "") ?? "N/A"),
          ),

          const SizedBox(height: AppSpacing.lg),

          /// ================= BUTTON =================
          AppButton(
            label: "View Details",

            onPressed: onView,

            variant: AppButtonVariant.gradient,

            icon: Icons.remove_red_eye,

            height: 48,
          ),
        ],
      ),
    );
  }

  /// ================= INFO ROW =================
  Widget _infoRow({
    required String title,
    required String value,
    bool isBold = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          "$title : ",

          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutrals03),
        ),

        Expanded(
          child: Text(
            value,

            textAlign: TextAlign.end,

            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,

              color: AppColors.neutrals02,
            ),
          ),
        ),
      ],
    );
  }
}
