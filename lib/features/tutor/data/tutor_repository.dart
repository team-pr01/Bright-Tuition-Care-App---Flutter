import 'package:btcclient/core/network/api_exception.dart';
import 'package:btcclient/features/tutor/data/requests/refund_application_request.dart';
import 'package:btcclient/features/tutor/data/results/refund_application_result.dart';

import 'tutor_api.dart';

class TutorRepository {
  final TutorApi api;

  TutorRepository(this.api);

 Future<Map<String, dynamic>> getStats() async {
  final response = await api.getStats();

  if (response["success"] != true) {
    throw ApiException(
      response["message"] ?? "Failed to load dashboard",
    );
  }

  return response;
}
  Future<RefundResponse> applyRefund(RefundApplicationRequest request) async {
    return await api.applyRefund(request);
  }
}
