import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/invoices/presentation/notifier/invoice_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/invoice_provider.dart';
import '../widgets/invoice_bottom_sheet.dart';
import '../widgets/invoice_card.dart';

class InvoiceScreen extends ConsumerStatefulWidget {
  final String role;
  const InvoiceScreen({super.key, required this.role});

  @override
  ConsumerState<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends ConsumerState<InvoiceScreen> {
  @override
  void initState() {
    super.initState();

    /// INITIAL FETCH
    Future.microtask(() {
      ref.read(invoiceProvider.notifier).fetchInvoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceProvider);

    return Scaffold(
      appBar: widget.role == "guardian"
          ? const CommonAppBar()
          : null,

      body: SafeArea(child: _buildBody(state)),
    );
  }

  /// ================= BODY =================
  Widget _buildBody(InvoiceState state) {
    /// INITIAL LOADING
    if (state.isLoading && state.invoices.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    /// ERROR
    if (state.error != null && state.invoices.isEmpty) {
      return Center(child: Text(state.error ?? "Something went wrong"));
    }

    /// EMPTY
    if (!state.isLoading && state.invoices.isEmpty) {
      return const Center(child: Text("No invoices found"));
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(invoiceProvider.notifier).refresh();
      },

      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),

        itemCount: state.invoices.length,

        itemBuilder: (context, index) {
          final invoice = state.invoices[index];

          return InvoiceCard(
            invoice: invoice,

            onView: () {
              showModalBottomSheet(
                context: context,

                isScrollControlled: true,

                backgroundColor: Colors.transparent,

                builder: (_) {
                  return InvoiceBottomSheet(invoice: invoice);
                },
              );
            },
          );
        },
      ),
    );
  }
}
