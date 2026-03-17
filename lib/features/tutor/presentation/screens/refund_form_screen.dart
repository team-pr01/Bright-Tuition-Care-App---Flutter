import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:flutter/material.dart';

class RefundFormScreen extends StatefulWidget {
  const RefundFormScreen({super.key});

  @override
  State<RefundFormScreen> createState() => _RefundFormScreenState();
}

class _RefundFormScreenState extends State<RefundFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final jobIdController = TextEditingController();
  final amountController = TextEditingController();
  final accountController = TextEditingController();
  final reasonController = TextEditingController();
  final bankNameController = TextEditingController();

  String? paymentMethod;

  final paymentMethods = ["bKash", "Nagad", "Rocket", "Bank Transfer"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),

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
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitRefund() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (paymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select payment method")),
      );
      return;
    }

    final refundData = {
      "jobId": jobIdController.text,
      "amount": amountController.text,
      "paymentMethod": paymentMethod,
      "bankName": paymentMethod == "Bank Transfer"
          ? bankNameController.text
          : null,
      "accountNumber": accountController.text,
      "refundReason": reasonController.text,
    };

    print(refundData);

    /// CALL API HERE
  }
}
