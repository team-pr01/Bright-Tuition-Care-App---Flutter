import 'package:btcclient/core/network/api_error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';

import 'package:btcclient/features/tutor/data/requests/refund_application_request.dart';
import 'package:btcclient/features/tutor/presentation/provider/refund_provider.dart';

class RefundFormScreen extends ConsumerStatefulWidget {
  const RefundFormScreen({super.key});

  @override
  ConsumerState<RefundFormScreen> createState() => _RefundFormScreenState();
}

class _RefundFormScreenState extends ConsumerState<RefundFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final jobIdController = TextEditingController();
  final amountController = TextEditingController();
  final accountController = TextEditingController();
  final reasonController = TextEditingController();
  final bankNameController = TextEditingController();

  String? paymentMethod = "bKash";

  final paymentMethods = ["bKash", "Nagad", "Rocket", "Bank Transfer"];

  @override
  void initState() {
    super.initState();

    // ✅ LISTEN TO PROVIDER (handles success/error)
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(refundProvider, (previous, next) {
      next.whenOrNull(
        data: (response) {
          if (!mounted || response == null) return;

          AppSnackbar.show(
            context,
            response.message,
            response.success ? SnackType.success : SnackType.error,
          );

          if (response.success) {
            _formKey.currentState?.reset();

            jobIdController.clear();
            amountController.clear();
            accountController.clear();
            reasonController.clear();
            bankNameController.clear();

            setState(() {
              paymentMethod = "bKash";
            });
             Navigator.of(context).pop();
          }
        },
        error: (error, stack) {
          if (!mounted) return;

          AppSnackbar.show(context, error.toString(), SnackType.error);
        },
      );
    });
    final refundState = ref.watch(refundProvider);
    return Scaffold(
      appBar: const CommonAppBar( title: "Refunds",),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              Text(
                "Refund Form",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),

              /// JOB ID
              AppInputField(
                label: "Job ID",
                controller: jobIdController,
                required: true,
              ),

              /// AMOUNT
              AppInputField(
                label: "Refund Amount",
                controller: amountController,
                keyboardType: TextInputType.number,
                required: true,
              ),

              /// PAYMENT METHOD
              AppInputField(
                label: "Payment Method",
                type: AppInputType.dropdown,
                required: true,
                dropdownItems: paymentMethods,
                value: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value;
                  });
                },
              ),

              /// BANK NAME (conditional)
              if (paymentMethod == "Bank Transfer")
                AppInputField(
                  label: "Bank Name",
                  controller: bankNameController,
                  required: true,
                ),

              /// ACCOUNT NUMBER
              AppInputField(
                label: "Account Number",
                controller: accountController,
                required: true,
                keyboardType: TextInputType.number,
              ),

              /// REFUND REASON
              AppInputField(
                label: "Refund Reason",
                type: AppInputType.multiline,
                controller: reasonController,
                maxLines: 4,
                required: true,
              ),

              const SizedBox(height: 16),

              /// SUBMIT BUTTON
              AppButton(
                label: "Submit Refund Request",
                variant: AppButtonVariant.gradient,
                onPressed: refundState.isLoading ? null : submitRefund,
                loading: refundState.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitRefund() async {
    if (!_formKey.currentState!.validate()) return;

    if (paymentMethod == null) {
      AppSnackbar.show(context, "Select payment method", SnackType.warning);
      return;
    }

    final amount = double.tryParse(amountController.text);
    if (amount == null) {
      AppSnackbar.show(context, "Enter valid amount", SnackType.error);
      return;
    }

    final request = RefundApplicationRequest(
      jobId: jobIdController.text.trim(),
      amount: amount,
      paymentMethod: paymentMethod!,
      bankName: paymentMethod == "Bank Transfer"
          ? bankNameController.text.trim()
          : null,
      accountNumber: accountController.text.trim(),
      refundReason: reasonController.text.trim(),
    );

    // ✅ TRIGGER PROVIDER
    await ref.read(refundProvider.notifier).applyRefund(request);
  }
}
