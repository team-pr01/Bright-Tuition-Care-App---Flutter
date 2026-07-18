import 'package:btcclient/features/refer/data/refer_api.dart';
import 'package:btcclient/features/refer/data/refer_repository.dart';
import 'package:btcclient/features/refer/presentation/notifier/my_leads_notifier.dart';
import 'package:btcclient/features/refer/presentation/provider/my_leads_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final referApiProvider = Provider(
  (ref) => ReferApi(),
);

final referRepositoryProvider = Provider(
  (ref) => ReferRepository(
    ref.read(referApiProvider),
  ),
);

final myLeadsProvider =
    StateNotifierProvider<MyLeadsNotifier, MyLeadsState>(
  (ref) => MyLeadsNotifier(
    ref.read(referRepositoryProvider),
  ),
);