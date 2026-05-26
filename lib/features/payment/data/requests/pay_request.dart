import 'dart:io';

class PayRequest {
  final String userId;
  final String senderAccountNumber;
  final String? transactionId;
  final String paymentMethod;
  final String? bankName;
  final String invoiceId;
  final String paidFor;
  final String amount;
  final File? file;

  PayRequest({
    required this.userId,
    required this.senderAccountNumber,
    this.transactionId,
    required this.paymentMethod,
    this.bankName,
    required this.invoiceId,
    required this.paidFor,
    required this.amount,
    this.file,
  });
}