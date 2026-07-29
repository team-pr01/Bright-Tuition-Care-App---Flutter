import 'package:btcclient/core/network/api_error_handler.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';
import 'package:btcclient/features/refer/data/models/lead_model.dart';
import 'package:btcclient/features/refer/data/request/payment_request.dart';
import 'package:btcclient/features/refer/presentation/provider/refer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPaymentMethodScreen extends ConsumerStatefulWidget {
  final LeadModel lead;

  const AddPaymentMethodScreen({
    super.key,
    required this.lead,
  });

  @override
  ConsumerState<AddPaymentMethodScreen> createState() =>
      _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState
    extends ConsumerState<AddPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();

  final accountController = TextEditingController();

  String? paymentMethod;

  final paymentMethods = const [
    "Bkash",
    "Nagad",
    "Rocket",
    "Bank",
  ];

  @override
  void initState() {
    super.initState();

    paymentMethod = widget.lead.paymentMethod;
    accountController.text = widget.lead.paymentAccountNumber ?? "";
  }

  @override
  void dispose() {
    accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(referProvider, (previous, next) {
      next.whenOrNull(
        data: (response) {
          if (!mounted || response == null) return;

          if (response.success) {
            AppSnackbar.show(
              context,
              "Payment information updated successfully.",
              SnackType.success,
            );

            Navigator.pop(context, true);
          } else {
            AppSnackbar.show(
              context,
              response.message,
              SnackType.error,
            );
          }
        },
        error: (error, stack) {
          if (!mounted) return;

          AppSnackbar.show(
            context,
            ApiErrorHandler.getMessage(error),
            SnackType.error,
          );
        },
      );
    });

    final state = ref.watch(referProvider);

    return Scaffold(
      appBar: const CommonAppBar( 
        title: "Refer & Earn",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Add Payment Method",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Provide your preferred payment details.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),

                const SizedBox(height: 30),

                AppInputField(
                  label: "Payment Method",
                  hint: "Select Payment Method",
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

                AppInputField(
                  label: "Payment Account Number",
                  hint: "Enter payment account number",
                  required: true,
                  controller: accountController,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 10),

                AppButton(
                  label: "Save Payment",
                  variant: AppButtonVariant.gradient,
                  loading: state.isLoading,
                  onPressed: state.isLoading ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (paymentMethod == null || paymentMethod!.isEmpty) {
      AppSnackbar.show(
        context,
        "Please select payment method.",
        SnackType.error,
      );
      return;
    }

    final request = UpdatePaymentRequest(
      paymentMethod: paymentMethod!,
      paymentAccountNumber: accountController.text.trim(),
    );

    await ref.read(referProvider.notifier).updatePayment(
          id: widget.lead.id,
          request: request,
        );
  }
}