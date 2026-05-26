import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/invoice_model.dart';
import '../../data/invoice_repository.dart';
import '../../data/requests/update_invoice_request.dart';

class InvoiceState {
  final bool isLoading;

  final List<InvoiceModel> invoices;

  final String? error;

  InvoiceState({this.isLoading = false, this.invoices = const [], this.error});

  InvoiceState copyWith({
    bool? isLoading,
    List<InvoiceModel>? invoices,
    String? error,
  }) {
    return InvoiceState(
      isLoading: isLoading ?? this.isLoading,
      invoices: invoices ?? this.invoices,
      error: error,
    );
  }
}

class InvoiceNotifier extends StateNotifier<InvoiceState> {
  final InvoiceRepository repository;

  InvoiceNotifier(this.repository) : super(InvoiceState());

  /// ================= FETCH =================
  Future<void> fetchInvoices() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final invoices = await repository.getAllInvoices();

      state = state.copyWith(isLoading: false, invoices: invoices);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// ================= REFRESH =================
  Future<void> refresh() async {
    await fetchInvoices();
  }

  /// ================= DELETE =================
  Future<void> deleteInvoice(String id) async {
    await repository.deleteInvoice(id);

    state = state.copyWith(
      invoices: state.invoices.where((e) => e.id != id).toList(),
    );
  }

  /// ================= UPDATE =================
  Future<void> updateInvoice({
    required String id,
    required double amount,
    required String dueDate,
  }) async {
    await repository.updateInvoice(
      id: id,

      request: UpdateInvoiceRequest(amount: amount, dueDate: dueDate),
    );

    await fetchInvoices();
  }

  void clear() {
    state = InvoiceState(invoices: [], isLoading: false, error: null);
  }
}
