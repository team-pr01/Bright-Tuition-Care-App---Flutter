import 'package:btcclient/features/settings/prersentation/widgets/address_verification_form.dart';
import 'package:btcclient/features/settings/prersentation/widgets/pay_verification_fee_form.dart';
import 'package:btcclient/features/settings/prersentation/widgets/verification_success.dart';
import 'package:flutter/material.dart';

Widget buildVerificationStep({
  required ThemeData theme,
  required String currentStep,
  required String? addressCode,
}) {
  switch (currentStep) {
    case "pending":
    case "accepted":
    case "reviewing":
      return Center(
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text("Under review..."),
          ],
        ),
      );

    case "invoiceDue":
      return payVerificationFeeForm(
        theme: theme,
        invoiceId: "INV123",
        onPay: () {
          /// TODO: navigate to invoice screen
        },
      );

    case "addressVerification":
      return addressVerificationForm(
        theme: theme,
        addressCodeFromApi: addressCode,
        onSubmit: (code) {
          /// TODO: call submit API
          print("Code submitted: $code");
        },
      );

    case "verified":
      return verificationSuccess(theme);

    default:
      return const SizedBox();
  }
}