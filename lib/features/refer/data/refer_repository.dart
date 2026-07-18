import 'package:btcclient/features/refer/data/models/lead_model.dart';
import 'package:btcclient/features/refer/data/refer_api.dart';
import 'package:btcclient/features/refer/data/request/add_lead_request.dart';
import 'package:btcclient/features/refer/data/request/update_lead_request.dart';
import 'package:btcclient/features/refer/data/response/add_lead_response.dart';
import 'package:btcclient/features/refer/data/response/lead_list_response.dart';

class ReferRepository {
  final ReferApi api;

  ReferRepository(this.api);

  Future<AddLeadResponse> addLead(
    AddLeadRequest request,
  ) async {
    return await api.addLead(request);
  }

  Future<LeadListResponse> getMyLeads({
    int page = 1,
    int limit = 10,
    String? keyword,
  }) async {
    return await api.getMyLeads(
      page: page,
      limit: limit,
      keyword: keyword,
    );
  }

  Future<LeadModel> getLead(
    String id,
  ) async {
    return await api.getLead(id);
  }

  Future<AddLeadResponse> updateLead({
    required String id,
    required UpdateLeadRequest request,
  }) async {
    return await api.updateLead(
      id: id,
      request: request,
    );
  }
}