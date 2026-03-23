import 'package:btcclient/core/network/dio_client.dart';
import 'package:btcclient/features/refer/data/request/add_lead_request.dart';
import 'package:btcclient/features/refer/data/response/add_lead_response.dart';

class ReferApi {
  Future<AddLeadResponse> addLead(AddLeadRequest request) async {
    final response = await DioClient.dio.post(
      "/lead/add",
      data: request.toJson(),
    );

    return AddLeadResponse.fromJson(response.data);
  }
}