import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/services/navigation_service.dart';
import 'package:btcclient/core/storage/local_storage.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/auth/data/models/user_model.dart';
import 'package:btcclient/features/invoices/data/models/invoice_model.dart';
import 'package:btcclient/features/invoices/presentation/notifier/invoice_notifier.dart';
import 'package:btcclient/features/invoices/presentation/widgets/skeleton/invoice_card_skeleton.dart';
import 'package:btcclient/features/payment/presentation/widgets/select_payment_method_sheet.dart';
import 'package:btcclient/features/payment/presentation/widgets/selected_payment_method_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  bool _openingNotificationInvoice = false;

  // ============================================================
  // INIT STATE
  // ============================================================

  @override
  @override
  void initState() {
    super.initState();

    debugPrint('🟢🟢🟢 INVOICE SCREEN INIT');

    NavigationService.registerInvoiceDetailsHandler(_openNotificationInvoice);

    Future.microtask(() async {
      currentUser = await LocalStorage.getUser();

      if (mounted) {
        setState(() {});
      }

      await ref.read(invoiceProvider.notifier).fetchInvoices();
    });
  }

  // ============================================================
  // OPEN INVOICE FROM NOTIFICATION
  // ============================================================

  Future<void> _openNotificationInvoice(String invoiceId) async {
    if (_openingNotificationInvoice) {
      return;
    }

    _openingNotificationInvoice = true;

    try {
      debugPrint('🔔 InvoiceScreen opening notification invoice: $invoiceId');

      final invoicesState = ref.read(invoiceProvider);

      InvoiceModel? invoice;

      // ========================================================
      // CHECK IF INVOICE IS ALREADY LOADED
      // ========================================================

      for (final item in invoicesState.invoices) {
        if (item.invoiceId == invoiceId || item.id == invoiceId) {
          invoice = item;
          break;
        }
      }

      // ========================================================
      // INVOICE ALREADY LOADED
      // ========================================================

      if (invoice != null) {
        debugPrint('⚡ Invoice already loaded → opening bottom sheet');

        if (!mounted) {
          return;
        }

        await _showNotificationInvoiceSheet(invoice);

        return;
      }

      // ========================================================
      // INVOICE NOT LOADED → FETCH SINGLE INVOICE
      // ========================================================

      debugPrint('🌐 Invoice not loaded → fetching invoice: $invoiceId');

      final fetchedInvoice = await ref
          .read(invoiceProvider.notifier)
          .fetchSingleInvoice(invoiceId);

      if (!mounted) {
        return;
      }

      debugPrint(
        '✅ Notification invoice fetched: '
        '${fetchedInvoice.invoiceId}',
      );

      await _showNotificationInvoiceSheet(fetchedInvoice);
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to open notification invoice: $e');

      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _openingNotificationInvoice = false;
    }
  }

  // ============================================================
  // SHOW NOTIFICATION INVOICE BOTTOM SHEET
  // ============================================================

  Future<void> _showNotificationInvoiceSheet(InvoiceModel invoice) async {
    if (!mounted) {
      return;
    }

    debugPrint('📋 Opening InvoiceBottomSheet: ${invoice.invoiceId}');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return InvoiceBottomSheet(
          invoice: invoice,
          user: currentUser,

          // ====================================================
          // PAY NOW
          // ====================================================
          onPayNow: () async {
            await _openPaymentFlow(invoice);
          },
        );
      },
    );
  }

  // ============================================================
  // PAYMENT FLOW
  // ============================================================

  Future<void> _openPaymentFlow(InvoiceModel invoice) async {
    if (!mounted) {
      return;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SelectPaymentMethodSheet(
          onSelected: (selectedMethod) async {
            // Close payment method sheet
            Navigator.pop(context);

            await Future.delayed(const Duration(milliseconds: 250));

            if (!mounted) {
              return;
            }

            // Open payment details
            await showModalBottomSheet(
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
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    NavigationService.unregisterInvoiceDetailsHandler();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceProvider);

    return Scaffold(
      appBar: CommonAppBar(title: "Invoices"),
      body: SafeArea(child: _buildBody(state)),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody(InvoiceState state) {
    // ==========================================================
    // INITIAL LOADING
    // ==========================================================

    if (state.isLoading && state.invoices.isEmpty) {
      return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 5,
        separatorBuilder: (_, __) {
          return const SizedBox(height: 4);
        },
        itemBuilder: (_, __) {
          return const InvoiceCardSkeleton();
        },
      );
    }

    // ==========================================================
    // ERROR
    // ==========================================================

    if (state.error != null && state.invoices.isEmpty) {
      return Center(child: Text(state.error ?? "Something went wrong"));
    }

    // ==========================================================
    // EMPTY
    // ==========================================================

    if (!state.isLoading && state.invoices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/navigations/invoice.svg',
              width: 80,
              height: 80,
              colorFilter: const ColorFilter.mode(
                AppColors.primary01,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No Invoice',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    // ==========================================================
    // INVOICE LIST
    // ==========================================================

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

            // ==================================================
            // NORMAL VIEW BUTTON
            // ==================================================
            onView: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) {
                  return InvoiceBottomSheet(
                    invoice: invoice,
                    user: currentUser,

                    onPayNow: () async {
                      await _openPaymentFlow(invoice);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
