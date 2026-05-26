import 'package:dio/dio.dart';

import 'payment_api.dart';
import 'requests/pay_request.dart';

class PaymentRepository {
  final PaymentApi api;

  PaymentRepository(this.api);

  Future<void> pay(
    PayRequest request,
  ) async {

    final formData = FormData.fromMap({
      "userId": request.userId,
      "senderAccountNumber":
          request.senderAccountNumber,

      "transactionId":
          request.transactionId ?? "",

      "paymentMethod":
          request.paymentMethod,

      "bankName":
          request.bankName ?? "",

      "invoiceId":
          request.invoiceId,

      "paidFor":
          request.paidFor,

      "amount":
          request.amount,
    });

    if (request.file != null) {

      formData.files.add(
        MapEntry(
          "file",

          await MultipartFile.fromFile(
            request.file!.path,
          ),
        ),
      );
    }

    await api.pay(formData);
  }
}