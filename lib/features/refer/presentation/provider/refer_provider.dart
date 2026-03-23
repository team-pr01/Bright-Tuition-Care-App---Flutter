import 'package:btcclient/features/refer/data/refer_api.dart';
import 'package:btcclient/features/refer/data/refer_repository.dart';
import 'package:btcclient/features/refer/data/response/add_lead_response.dart';
import 'package:btcclient/features/refer/presentation/notifier/refer_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final referApiProvider = Provider((ref) => ReferApi());

final referRepositoryProvider = Provider(
  (ref) => ReferRepository(ref.watch(referApiProvider)),
);

final referProvider =
    StateNotifierProvider<ReferNotifier, AsyncValue<AddLeadResponse?>>((ref) {
  final repo = ref.watch(referRepositoryProvider);
  return ReferNotifier(repo);
});