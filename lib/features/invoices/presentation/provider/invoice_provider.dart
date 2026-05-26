import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/invoice_repository.dart';
import '../../data/invoive_api.dart';
import '../notifier/invoice_notifier.dart';

/// ================= API =================
final invoiceApiProvider = Provider<InvoiceApi>((ref) {
  return InvoiceApi(DioClient.dio);
});

/// ================= REPOSITORY =================
final invoiceRepositoryProvider =
    Provider<InvoiceRepository>((ref) {
  return InvoiceRepository(
    ref.read(invoiceApiProvider),
  );
});

/// ================= NOTIFIER =================
final invoiceProvider =
    StateNotifierProvider<
        InvoiceNotifier,
        InvoiceState>((ref) {
  return InvoiceNotifier(
    ref.read(invoiceRepositoryProvider),
  );
});