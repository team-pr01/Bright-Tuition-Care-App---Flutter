import 'package:btcclient/core/network/dio_client.dart';
import 'package:btcclient/features/refer/data/models/lead_model.dart';
import 'package:btcclient/features/refer/data/request/add_lead_request.dart';
import 'package:btcclient/features/refer/data/request/payment_request.dart';
import 'package:btcclient/features/refer/data/request/update_lead_request.dart';
import 'package:btcclient/features/refer/data/response/add_lead_response.dart';
import 'package:btcclient/features/refer/data/response/lead_list_response.dart';

class ReferApi {
  /// ----------------------------
  /// Add Lead
  /// ----------------------------
  Future<AddLeadResponse> addLead(AddLeadRequest request) async {
    final response = await DioClient.dio.post(
      "/lead/add",
      data: request.toJson(),
    );

    return AddLeadResponse.fromJson(response.data);
  }

  /// ----------------------------
  /// My Leads
  /// ----------------------------
  Future<LeadListResponse> getMyLeads({
    int page = 1,
    int limit = 10,
    String? keyword,
  }) async {
    final response = await DioClient.dio.get(
      "/lead/tutor/my-leads",
      queryParameters: {
        "page": page,
        "limit": limit,
        if (keyword != null && keyword.isNotEmpty)
          "keyword": keyword,
      },
    );

    return LeadListResponse.fromJson(response.data);
  }

  /// ----------------------------
  /// Single Lead
  /// ----------------------------
  Future<LeadModel> getLead(String id) async {
    final response = await DioClient.dio.get(
      "/lead/$id",
    );

    return LeadModel.fromJson(response.data["data"]);
  }

  /// ----------------------------
  /// Update Lead
  /// ----------------------------
  Future<AddLeadResponse> updateLead({
    required String id,
    required UpdateLeadRequest request,
  }) async {
    final response = await DioClient.dio.patch(
      "/lead/update/$id",
      data: request.toJson(),
    );

    return AddLeadResponse.fromJson(response.data);
  }
  
  Future<AddLeadResponse> updatePayment({
  required String id,
  required UpdatePaymentRequest request,
}) async {
  final response = await DioClient.dio.patch(
    "/lead/update/$id",
    data: request.toJson(),
  );

  return AddLeadResponse.fromJson(response.data);
}
}