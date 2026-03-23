
import 'package:btcclient/features/refer/data/request/add_lead_request.dart';
import 'package:btcclient/features/refer/data/response/add_lead_response.dart';

import '../data/refer_api.dart';

class ReferRepository {
  final ReferApi api;

  ReferRepository(this.api);

  Future<AddLeadResponse> addLead(AddLeadRequest request) async {
    return await api.addLead(request);
  }
}