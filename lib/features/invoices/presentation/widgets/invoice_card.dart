import 'package:btcclient/core/utils/date_formatter.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/theme.dart';
import '../../../../core/widgets/button/app_button.dart';
import '../../data/models/invoice_model.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  final VoidCallback onView;

  const InvoiceCard({
    super.key,
    required this.invoice,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = invoice.status == "paid";
    final statusColor = isPaid ? AppColors.success : AppColors.error02;
    final dateValue = isPaid
        ? (DateFormatter.formattedDate(invoice.paidDate ?? "") ?? "N/A")
        : (DateFormatter.formattedDate(invoice.dueDate ?? "") ?? "N/A");

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.neutrals04.withOpacity(0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onView,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ================= HEADER =================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary02,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.receipt_long_outlined,
                        color: AppColors.primary01,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            invoice.invoiceType == "verificationCharge"
                                ? "Verification Charge"
                                : "Platform Charge",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.headlineSmall.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                              color: AppColors.neutrals02,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "ID: ${invoice.invoiceId}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 12,
                              color: AppColors.neutrals03,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: statusColor.withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            invoice.status.toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.neutrals04.withOpacity(0.5),
                ),
                const SizedBox(height: 14),

                /// ================= AMOUNT & DATE =================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TOTAL AMOUNT",
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                              color: AppColors.neutrals03,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "${invoice.amount.round()}", 
                                  style: AppTextStyles.headlineSmall.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.4,
                                    color: AppColors.neutrals02,
                                  ),
                                ),
                                TextSpan(
                                  text: " BDT",
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.neutrals03,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isPaid ? "PAID DATE" : "DUE DATE",
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                            color: AppColors.neutrals03,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                           
                            Text(
                              dateValue,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.neutrals02,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                /// ================= OPTIONAL JOB ID =================
                if (invoice.jobId != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.work_outline_rounded,
                        size: 14,
                        color: AppColors.neutrals03,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Job ID: ",
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                          color: AppColors.neutrals03,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          invoice.jobId!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.neutrals02,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 14),

                /// ================= BUTTON =================
                AppButton(
                  label: "View Details",
                  onPressed: onView,
                  variant: AppButtonVariant.outline,
                  icon: Icons.visibility_outlined,
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}