import 'package:btcclient/core/utils/date_formatter.dart';
import 'package:btcclient/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/theme.dart';
import '../../../../core/widgets/button/app_button.dart';
import '../../../../core/widgets/reusable_bottom_sheet/reusable_bottom_sheet.dart';
import '../../data/models/invoice_model.dart';

class InvoiceBottomSheet extends ConsumerWidget {
  final InvoiceModel invoice;
  final UserModel? user;
  final Function onPayNow;

  const InvoiceBottomSheet({
    super.key,
    required this.invoice,
    required this.user,
    required this.onPayNow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaid = invoice.status == "paid";
    final statusColor = isPaid ? Colors.green : Colors.red;
    final invoiceTitle = invoice.invoiceType == "verificationCharge"
        ? "Verification Charge"
        : "Platform Charge";

    return ReusableBottomSheet(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= HEADER & AMOUNT =================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invoiceTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            "Invoice #${invoice.invoiceId}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(100),
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
                                  isPaid ? "Paid" : "Due",
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              "TOTAL AMOUNT",
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.7,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${invoice.amount}",
                    style: TextStyle(
                      color: AppColors.primary01,
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextSpan(
                    text: " BDT",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 28, thickness: 1, color: Colors.grey.shade200),

            /// ================= INVOICE DETAILS =================
            _sectionTitle("INVOICE DETAILS"),
            const SizedBox(height: 12),
            _detailRow(title: "Title", value: invoiceTitle),
            const SizedBox(height: 10),
            _detailRow(title: "Invoice ID", value: "#${invoice.invoiceId}"),
            if (invoice.jobId != null) ...[
              const SizedBox(height: 10),
              _detailRow(title: "Job ID", value: invoice.jobId!),
            ],
            const SizedBox(height: 10),
            _detailRow(
              title: "Issue Date",
              value: invoice.createdDate != null
                  ? DateFormatter.formattedDate(invoice.createdDate!)
                  : "N/A",
            ),
            const SizedBox(height: 10),
            _detailRow(
              title: "Due Date",
              value: invoice.dueDate != null
                  ? DateFormatter.formattedDate(invoice.dueDate!)
                  : "N/A",
            ),
            if (invoice.paidDate != null) ...[
              const SizedBox(height: 10),
              _detailRow(
                title: "Paid Date",
                value: DateFormatter.formattedDate(invoice.paidDate!),
              ),
            ],

            Divider(height: 28, thickness: 1, color: Colors.grey.shade200),

            /// ================= BILL TO =================
            _sectionTitle("BILL TO"),
            const SizedBox(height: 12),
            _detailRow(title: "Name", value: user?.name ?? "N/A"),
            const SizedBox(height: 10),
            _detailRow(title: "Email", value: user?.email ?? "N/A"),
            const SizedBox(height: 10),
            _detailRow(title: "Phone", value: user?.phoneNumber ?? "N/A"),

            Divider(height: 28, thickness: 1, color: Colors.grey.shade200),

            /// ================= PAYMENT HELPLINE =================
            InkWell(
              onTap: () {
                launchUrl(Uri.parse("tel:+8801616012365"));
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.support_agent_rounded,
                      size: 20,
                      color: AppColors.primary01,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Payment Helpline",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "01610-785588",
                      style: TextStyle(
                        color: AppColors.primary01,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.call_outlined,
                      size: 16,
                      color: AppColors.primary01,
                    ),
                  ],
                ),
              ),
            ),

            /// ================= PAY BUTTON =================
            if (!isPaid) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: "Pay Now",
                  onPressed: () {
                    Navigator.pop(context); // Close invoice details
                    onPayNow(); // Let parent open payment sheet
                  },
                  variant: AppButtonVariant.gradient,
                  height: 45,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: Colors.grey.shade500,
      ),
    );
  }

  Widget _detailRow({required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13.5,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 13.5,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
