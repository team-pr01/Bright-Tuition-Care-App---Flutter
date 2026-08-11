import 'dart:io';

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/file_picker_utils.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/requests/pay_request.dart';

import '../provider/payment_provider.dart';

class SubmitProofForm extends ConsumerStatefulWidget {
  final double amount;

  final String selectedPaymentMethod;

  final String invoiceId;

  final String paidFor;

  const SubmitProofForm({
    super.key,
    required this.amount,
    required this.selectedPaymentMethod,
    required this.invoiceId,
    required this.paidFor,
  });

  @override
  ConsumerState<SubmitProofForm> createState() => _SubmitProofFormState();
}

class _SubmitProofFormState extends ConsumerState<SubmitProofForm> {
  final _formKey = GlobalKey<FormState>();

  final senderController = TextEditingController();

  final transactionController = TextEditingController();

  final bankController = TextEditingController();

  File? selectedFile;

  @override
  void dispose() {
    senderController.dispose();

    transactionController.dispose();

    bankController.dispose();

    super.dispose();
  }

  Future<void> pickFile() async {
    final file = await FilePickerUtils.pickSingleFile( 
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (file != null) {
      setState(() {
        selectedFile = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);
    final user = ref.watch(authProvider).user;
    final isBank = widget.selectedPaymentMethod == "bankTransfer";

    return Form(
      key: _formKey,

      child: Column(
        children: [
          /// ================= BANK NAME =================
          if (isBank)
            AppInputField(
              label: "Bank Name",

              hint: "Enter bank name",

              controller: bankController,

              required: true,

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Bank name is required";
                }

                return null;
              },
            ),

          /// ================= SENDER =================
          AppInputField(
            label: isBank ? "Sender Account Number" : "Sender Phone Number",

            hint: isBank
                ? "Enter sender account number"
                : "Enter sender phone number",

            controller: senderController,

            required: true,

            keyboardType: TextInputType.phone,

            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Required";
              }

              return null;
            },
          ),

          /// ================= TRANSACTION =================
          if (!isBank)
            AppInputField(
              label: "Transaction ID",

              hint: "Enter transaction id",

              controller: transactionController,
            ),

          /// ================= FILE PICKER =================
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Payment Screenshot (Optional)",

                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 6),

              GestureDetector(
                onTap: pickFile,

                child: Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(AppSpacing.md),

                  decoration: BoxDecoration(
                    color: AppColors.neutrals01,

                    borderRadius: BorderRadius.circular(5),

                    border: Border.all(
                      color: AppColors.primary01.withOpacity(0.3),
                    ),
                  ),

                  child: Row(
                    children: [
                      Icon(Icons.upload_file, color: AppColors.primary01),

                      const SizedBox(width: AppSpacing.sm),

                      Expanded(
                        child: Text(
                          selectedFile == null
                              ? "Upload screenshot"
                              : selectedFile!.path.split("/").last,

                          style: AppTextStyles.bodyMedium.copyWith(
                            color: selectedFile == null
                                ? AppColors.neutrals03
                                : AppColors.neutrals02,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),
            ],
          ),

          /// ================= AMOUNT =================
          AppInputField(
            label: "Amount",

            controller: TextEditingController(text: widget.amount.toString() + " BDT"),

            enabled: false,
          ),

          const SizedBox(height: AppSpacing.lg),

          /// ================= SUBMIT =================
          SizedBox(
            width: double.infinity,

            child: AppButton(
              label: paymentState.isLoading
                  ? "Submitting..."
                  : "Submit Payment",

              onPressed: paymentState.isLoading
                  ? null
                  : () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      final request = PayRequest(
                        userId: user?.id ?? "",

                        senderAccountNumber: senderController.text,

                        transactionId: transactionController.text,

                        paymentMethod: widget.selectedPaymentMethod,

                        bankName: bankController.text,

                        invoiceId: widget.invoiceId,

                        paidFor: widget.paidFor,

                        amount: widget.amount.toString(),

                        file: selectedFile,
                      );

                      final success = await ref
                          .read(paymentProvider.notifier)
                          .pay(request);

                      if (!mounted) return;

                      /// ================= SUCCESS =================
                      if (success) {
                        Navigator.pop(context);

                        AppSnackbar.show(
                          context,
                          "Payment submitted successfully",
                          SnackType.success,
                        );
                      } else {
                        /// ================= GET LATEST ERROR =================
                        final latestState = ref.read(paymentProvider);

                        print("PAYMENT ERROR: ${latestState.error}");

                        AppSnackbar.show(
                          context,

                          latestState.error ?? "Payment submission failed",

                          SnackType.error,
                        );
                      }
                    },

              variant: AppButtonVariant.gradient,

              height: 48,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            "Facing any payment issues? Call us",

            textAlign: TextAlign.center,

            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutrals03,
            ),
          ),
        ],
      ),
    );
  }
}
