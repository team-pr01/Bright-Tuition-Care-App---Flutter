import 'package:btcclient/features/invoices/presentation/screen/invoice_page.dart';
import 'package:btcclient/features/legal/presentation/important_guidelines_screen.dart';
import 'package:flutter/material.dart';

class NavigationService {
  NavigationService._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  // ============================================================
  // PENDING JOB
  // ============================================================

  static String? _pendingJobId;

  static String? get pendingJobId => _pendingJobId;

  static void setPendingJob(String jobId) {
    debugPrint('📦 NavigationService: storing pending job $jobId');

    _pendingJobId = jobId;
  }

  static String? consumePendingJob() {
    final jobId = _pendingJobId;

    if (jobId != null) {
      debugPrint('📦 NavigationService: consuming pending job $jobId');
    }

    _pendingJobId = null;

    return jobId;
  }

  // ============================================================
  // DASHBOARD JOB HANDLER
  // ============================================================

  static Future<void> Function(String jobId)? onOpenJobDetails;

  // ============================================================
  // NOTIFICATION → DASHBOARD JOB
  // ============================================================

  static void navigateToJobDetails(String jobId) {

    final handler = onOpenJobDetails;

    if (handler != null) {
      handler(jobId);
      return;
    }
    setPendingJob(jobId);
  }

  // ============================================================
  // REGISTER DASHBOARD JOB HANDLER
  // ============================================================

  static void registerJobDetailsHandler(
    Future<void> Function(String jobId) callback,
  ) {
    debugPrint('✅ Registering Dashboard job handler');

    onOpenJobDetails = callback;

    final pendingJob = consumePendingJob();

    if (pendingJob == null) {
      debugPrint('ℹ️ No pending job notification');
      return;
    }

    debugPrint('📦 Pending notification job found: $pendingJob');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (onOpenJobDetails != null) {
        debugPrint('🚀 Sending pending job to Dashboard: $pendingJob');

        onOpenJobDetails!(pendingJob);
      }
    });
  }

  // ============================================================
  // PENDING INVOICE
  // ============================================================

  static String? _pendingInvoiceId;

  static String? get pendingInvoiceId => _pendingInvoiceId;

  static void setPendingInvoice(String invoiceId) {
    _pendingInvoiceId = invoiceId;
    if (_pendingInvoiceId == invoiceId) {
      debugPrint('✅✅ PENDING INVOICE SAVED SUCCESSFULLY');
    } else {
      debugPrint('❌❌ PENDING INVOICE WAS NOT SAVED');
    }
  }

  static String? consumePendingInvoice() {
    final invoiceId = _pendingInvoiceId;

    if (invoiceId != null) {
      debugPrint('📦 NavigationService: consuming pending invoice $invoiceId');
    }

    _pendingInvoiceId = null;

    return invoiceId;
  }

  // ============================================================
  // INVOICE HANDLER
  // ============================================================

  static Future<void> Function(String invoiceId)? onOpenInvoiceDetails;

  // ============================================================
  // NOTIFICATION → INVOICE
  // ============================================================

  // ============================================================
  // NOTIFICATION → INVOICE
  // ============================================================
  static void navigateToInvoiceDetails(String invoiceId) {

    final handler = onOpenInvoiceDetails;

    // InvoiceScreen is already alive
    if (handler != null) {
      handler(invoiceId);
      return;
    }

    setPendingInvoice(invoiceId);

    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      return;
    }
    navigator.push(
      MaterialPageRoute(builder: (_) => const InvoiceScreen(role: "tutor")),
    );
  }

  // ============================================================
  // REGISTER INVOICE HANDLER
  // ============================================================

  static void registerInvoiceDetailsHandler(
    Future<void> Function(String invoiceId) callback,
  ) {

    onOpenInvoiceDetails = callback;


    final pendingInvoice = consumePendingInvoice();

    if (pendingInvoice == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final handler = onOpenInvoiceDetails;

      if (handler != null) {
        handler(pendingInvoice);
      } else {
        debugPrint('❌ Invoice handler disappeared before pending callback');
      }
    });
  } // ============================================================
  // IMPORTANT GUIDELINES
  // ============================================================

  static void navigateToImportantGuidelines(dynamic document) {
    final navigator = navigatorKey.currentState;

    if (navigator == null) {
      debugPrint(
        '⚠️ Navigator is not ready. Cannot open Important Guidelines.',
      );
      return;
    }

    debugPrint('🔔 Navigating to Important Guidelines');

    navigator.push(
      MaterialPageRoute(
        builder: (_) => ImportantGuidelinesScreen(document: document),
      ),
    );
  }

  // ============================================================
  // UNREGISTER JOB HANDLER
  // ============================================================

  static void unregisterJobDetailsHandler() {
    debugPrint('❌ Unregistering Dashboard job handler');

    onOpenJobDetails = null;
  }

  // ============================================================
  // UNREGISTER INVOICE HANDLER
  // ============================================================

  static void unregisterInvoiceDetailsHandler() {
    debugPrint('❌ Unregistering Invoice handler');

    onOpenInvoiceDetails = null;
  }
}
