import 'package:btcclient/features/tutor/data/models/RefundData.dart';

class RefundResponse {
  final bool success;
  final String message;
  final RefundData data;

  RefundResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RefundResponse.fromJson(Map<String, dynamic> json) {
    return RefundResponse(
      success: json["success"],
      message: json["message"],
      data: RefundData.fromJson(json["data"]),
    );
  }
}