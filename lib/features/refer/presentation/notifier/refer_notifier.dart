import 'package:btcclient/features/refer/data/refer_repository.dart';
import 'package:btcclient/features/refer/data/request/add_lead_request.dart';
import 'package:btcclient/features/refer/data/response/add_lead_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReferNotifier extends StateNotifier<AsyncValue<AddLeadResponse?>> {
  final ReferRepository repository;

  ReferNotifier(this.repository) : super(const AsyncValue.data(null));

  Future<void> addLead(AddLeadRequest request) async {
    state = const AsyncValue.loading();

    try {
      final response = await repository.addLead(request);
      state = AsyncValue.data(response);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}