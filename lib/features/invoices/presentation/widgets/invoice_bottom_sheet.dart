import 'package:btcclient/core/utils/date_formatter.dart';
import 'package:btcclient/core/utils/number_formatter.dart';
import 'package:btcclient/features/payment/presentation/widgets/select_payment_method_sheet.dart';
import 'package:btcclient/features/payment/presentation/widgets/selected_payment_method_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/theme.dart';
import '../../../../core/widgets/button/app_button.dart';
import '../../../../core/widgets/reusable_bottom_sheet/reusable_bottom_sheet.dart';
import '../../data/models/invoice_model.dart';

class InvoiceBottomSheet extends ConsumerWidget {
  final InvoiceModel invoice;

  const InvoiceBottomSheet({super.key, required this.invoice});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaid = invoice.status == "paid";

    return ReusableBottomSheet(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// ================= PAYMENT HELPLINE =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Payment Helpline",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Text(
                          "Contact: ",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),

                        Text(
                          "01610-785588",
                          style: TextStyle(
                            color: AppColors.primary01,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ================= MAIN CARD =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    /// ================= BILL TO =================
                    const Text(
                      "Bill To",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoText(title: "Name", value: "Prerna Badwane"),

                        const SizedBox(height: 8),

                        _infoText(
                          title: "Email",
                          value: "prernabadwane@gmail.com",
                        ),

                        const SizedBox(height: 8),

                        _infoText(title: "Phone", value: "01608249337"),
                      ],
                    ),

                    const SizedBox(height: 28),

                    /// ================= PAYMENT STATUS =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Payment Status: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),

                          decoration: BoxDecoration(
                            color: isPaid
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),

                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Text(
                            isPaid ? "Paid" : "Due",

                            style: TextStyle(
                              color: isPaid ? Colors.green : Colors.red,

                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// ================= DATES =================
                    /// ================= DATES =================
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoText(
                          title: "Issue Date",
                          value: invoice.createdDate != null
                              ? DateFormatter.formattedDate(
                                  invoice.createdDate!,
                                )
                              : "N/A",
                        ),

                        const SizedBox(height: 12),

                        _infoText(
                          title: "Due Date",
                          value: invoice.dueDate != null
                              ? DateFormatter.formattedDate(invoice.dueDate!)
                              : "N/A",
                        ),

                        if (invoice.paidDate != null) ...[
                          const SizedBox(height: 12),

                          _infoText(
                            title: "Paid Date",
                            value: DateFormatter.formattedDate(
                              invoice.paidDate!,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 34),

                    /// ================= INVOICE DETAILS =================
                    const Text(
                      "Invoice Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoText(
                          title: "Title",
                          value: invoice.invoiceType == "verificationCharge"
                              ? "Verification Charge"
                              : "Platform Charge",
                        ),

                        const SizedBox(height: 12),

                        _infoText(
                          title: "Invoice ID",
                          value: invoice.invoiceId,
                        ),

                        const SizedBox(height: 12),

                        if (invoice.jobId != null)
                          _infoText(title: "Job ID", value: invoice.jobId!),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Text(
                              "Amount: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),

                            Text(
                              "${invoice.amount} BDT",

                              style: TextStyle(
                                color: AppColors.primary01,

                                fontWeight: FontWeight.bold,

                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// ================= PAY BUTTON =================
                    /// ================= PAY BUTTON =================
                    if (!isPaid)
                      SizedBox(
                        width: double.infinity,

                        child: AppButton(
                          label: "Pay Now",

                          onPressed: () async {
                            showModalBottomSheet(
                              context: context,

                              isScrollControlled: true,

                              backgroundColor: Colors.transparent,

                              builder: (_) {
                                return SelectPaymentMethodSheet(
                                  onSelected: (selectedMethod) async {
                                    /// CLOSE METHOD SHEET
                                    Navigator.pop(context);

                                    await Future.delayed(
                                      const Duration(milliseconds: 250),
                                    );

                                    /// OPEN PAYMENT DETAILS
                                    showModalBottomSheet(
                                      context: context,

                                      isScrollControlled: true,

                                      backgroundColor: Colors.transparent,

                                      builder: (_) {
                                        return SelectedPaymentMethodSheet(
                                          selectedPaymentMethod: selectedMethod,

                                          amount: invoice.amount,

                                          invoiceId: invoice.invoiceId,

                                          paidFor: invoice.invoiceType,
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                          variant: AppButtonVariant.gradient,

                          height: 45,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoText({required String title, required String value}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 16),

        children: [
          TextSpan(
            text: "$title: ",
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),

          TextSpan(
            text: value,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
