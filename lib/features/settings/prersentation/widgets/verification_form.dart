import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/features/invoices/data/models/invoice_model.dart';
import 'package:btcclient/features/payment/presentation/widgets/select_payment_method_sheet.dart';
import 'package:btcclient/features/payment/presentation/widgets/selected_payment_method_sheet.dart';
import 'package:btcclient/features/settings/prersentation/enums/verification_status.dart';
import 'package:btcclient/features/settings/prersentation/widgets/card_wrapper.dart';
import 'package:btcclient/features/settings/prersentation/widgets/show_verification_modal.dart';
import 'package:btcclient/features/settings/prersentation/widgets/verification_steps_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget verificationForm(
  BuildContext context,
  ThemeData theme,
  WidgetRef ref,
  bool isVerified,
  bool hasRequested,
  String? currentStepFromApi,
  String? addressCode,
  InvoiceModel? invoice,
) {
  /// ================= NO REQUEST =================
  if (!hasRequested && !isVerified) {
    return cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text("Verify Your Profile", style: theme.textTheme.headlineSmall),

          const SizedBox(height: AppSpacing.md),

          RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,

              children: [
                const TextSpan(
                  text: "Your profile is not verified yet. Click to ",
                ),

                TextSpan(
                  text: "Request for Verification.",

                  style: TextStyle(
                    fontWeight: FontWeight.bold,

                    color: AppColors.primary01,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          AppButton(
            label: "Request for Verification",

            variant: AppButtonVariant.gradient,

            onPressed: () {
              showVerificationModal(context, ref);
            },
          ),
        ],
      ),
    );
  }

  /// ================= STEP =================
  VerificationStatus currentStep = VerificationStatus.pending;

  if (currentStepFromApi != null) {
    currentStep = VerificationStatus.values.firstWhere(
      (e) => e.name == currentStepFromApi,

      orElse: () => VerificationStatus.pending,
    );
  }

  return cardWrapper(
    child: VerificationStepsWidget(
      currentStep: currentStep,
      invoice: invoice,
      addressVerificationCode:addressCode,
      onPay: () async {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,

          builder: (_) {
            return SelectPaymentMethodSheet(
              onSelected: (selectedMethod) async {
                /// CLOSE METHOD SHEET
                Navigator.pop(context);

                await Future.delayed(const Duration(milliseconds: 250));

                /// OPEN PAYMENT DETAILS
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,

                  builder: (_) {
                    return SelectedPaymentMethodSheet(
                      selectedPaymentMethod: selectedMethod,
                      amount: invoice!.amount,
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
    ),
  );
}
