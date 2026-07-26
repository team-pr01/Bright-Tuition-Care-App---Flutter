import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btcclient/core/network/api_error_handler.dart';

import '../../data/models/invoice_model.dart';
import '../../data/invoice_repository.dart';
import '../../data/requests/update_invoice_request.dart';

class InvoiceState {
  final bool isLoading;
  final List<InvoiceModel> invoices;
  final String? error;

  const InvoiceState({
    this.isLoading = false,
    this.invoices = const [],
    this.error,
  });

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

  InvoiceNotifier(this.repository) : super(const InvoiceState());

  Future<void> fetchInvoices() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final invoices = await repository.getMyInvoices();

      state = state.copyWith(
        isLoading: false,
        invoices: invoices,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ApiErrorHandler.getMessage(e),
      );
    }
  }

  Future<void> refresh() async {
    await fetchInvoices();
  }

  Future<void> deleteInvoice(String id) async {
    try {
      await repository.deleteInvoice(id);

      state = state.copyWith(
        invoices: state.invoices.where((e) => e.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        error: ApiErrorHandler.getMessage(e),
      );
      rethrow;
    }
  }

  Future<void> updateInvoice({
    required String id,
    required double amount,
    required String dueDate,
  }) async {
    try {
      await repository.updateInvoice(
        id: id,
        request: UpdateInvoiceRequest(
          amount: amount,
          dueDate: dueDate,
        ),
      );

      await fetchInvoices();
    } catch (e) {
      state = state.copyWith(
        error: ApiErrorHandler.getMessage(e),
      );
      rethrow;
    }
  }

  void clear() {
    state = const InvoiceState();
  }
}