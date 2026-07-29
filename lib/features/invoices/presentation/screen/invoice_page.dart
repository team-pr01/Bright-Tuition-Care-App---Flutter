import 'package:btcclient/core/storage/local_storage.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/auth/data/models/user_model.dart';
import 'package:btcclient/features/invoices/presentation/notifier/invoice_notifier.dart';
import 'package:btcclient/features/invoices/presentation/widgets/skeleton/invoice_card_skeleton.dart';
import 'package:btcclient/features/payment/presentation/widgets/select_payment_method_sheet.dart';
import 'package:btcclient/features/payment/presentation/widgets/selected_payment_method_sheet.dart';
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
  UserModel? currentUser;
  @override
  void initState() {
    super.initState();

    /// INITIAL FETCH
    Future.microtask(() async {
      currentUser = await LocalStorage.getUser();

      if (mounted) {
        setState(() {});
      }
      ref.read(invoiceProvider.notifier).fetchInvoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceProvider);
    return Scaffold(
      appBar: widget.role == "guardian"
          ? const CommonAppBar(title: "Invoices",)
          : null,

      body: SafeArea(child: _buildBody(state)),
    );
  }

  /// ================= BODY =================
  Widget _buildBody(InvoiceState state) {
    /// INITIAL LOADING
    if (state.isLoading && state.invoices.isEmpty) {
     return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (_, __) => const InvoiceCardSkeleton(),
    );
    }

    /// ERROR
    if (state.error != null && state.invoices.isEmpty) {
      return Center(child: Text(state.error ?? "Something went wrong"));
    }

    /// EMPTY
    if (!state.isLoading && state.invoices.isEmpty) {
      return const Center(child: Text("No invoices yet"));
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
                  return InvoiceBottomSheet(invoice: invoice  ,user: currentUser, 
                  onPayNow: () async {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) {
                                return SelectPaymentMethodSheet(
                                  onSelected: (selectedMethod) async {
                                    /// CLOSE METHOD SHEET
                                    Navigator.pop(context);
                                    await Future.delayed(
                                      const Duration(milliseconds: 250),
                                    );

                                    /// OPEN PAYMENT DETAILS
                                    showModalBottomSheet(
                                      context: context,

                                      isScrollControlled: true,

                                      backgroundColor: Colors.transparent,

                                      builder: (_) {
                                        return SelectedPaymentMethodSheet(
                                          selectedPaymentMethod: selectedMethod,

                                          amount: invoice.amount,

                                          invoiceId: invoice.invoiceId,

                                          paidFor: invoice.invoiceType,
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },);
                },
              );
            },
          );
        },
      ),
    );
  }
}
