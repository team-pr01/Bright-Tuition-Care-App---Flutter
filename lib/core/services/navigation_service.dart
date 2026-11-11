import 'package:btcclient/core/storage/local_storage.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/confirmation/presentation/screen/confirmation_letter_screen.dart';
import 'package:btcclient/features/invoices/presentation/screen/invoice_page.dart';
import 'package:btcclient/features/legal/presentation/important_guidelines_screen.dart';
import 'package:btcclient/features/profile/data/profile_api.dart';
import 'package:btcclient/features/profile/presentation/screens/tutor_profile_view_screen.dart';
import 'package:btcclient/features/settings/prersentation/screens/verification_screen.dart';
import 'package:btcclient/features/tutor/presentation/screens/tutor_application_screen.dart';
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
  static void navigateToProfileVerification() {
    final navigator = navigatorKey.currentState;

    if (navigator == null) {
      debugPrint(
        '⚠️ Navigator is not ready. Cannot open Profile Verification.',
      );
      return;
    }

    debugPrint('🔔 Navigating to Important Guidelines');

    navigator.push(MaterialPageRoute(builder: (_) => VerificationScreen()));
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

  // ============================================================
  // PENDING APPLICATION
  // ============================================================

  static Future<void> navigateToTutorProfile(String tutorId) async {
    final navigator = navigatorKey.currentState;

    if (navigator == null) {
      return;
    }

    try {
      final TutorProfileModel tutorProfile = await getTutorProfile(tutorId);

      navigator.push(
        MaterialPageRoute(
          builder: (_) => TutorResumeScreen(
            profile: tutorProfile,
            hideContactDetails: true,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Failed to open tutor profile: $e');
    }
  }

  static Future<void> navigateToConfirmationLetter(
    String confirmationId,
  ) async {
    final navigator = navigatorKey.currentState;

    if (navigator == null) {
      return;
    }

    final role = await LocalStorage.getRole();

    if (role == null || role.isEmpty) {
      return;
    }

    navigator.push(
      MaterialPageRoute(
        builder: (_) =>
            ConfirmationLetterScreen(letterId: confirmationId, role: role),
      ),
    );
  }









  // ============================================================
// PENDING APPLICATION
// ============================================================

static String? _pendingApplicationJobId;
static String? _pendingApplicationApplicationId;
static String? _pendingApplicationStatus;

static String? get pendingApplicationJobId =>
    _pendingApplicationJobId;

static String? get pendingApplicationApplicationId =>
    _pendingApplicationApplicationId;

static String? get pendingApplicationStatus =>
    _pendingApplicationStatus;
static void setPendingApplication(
  String jobId, String applicationId, {
  String? status,
}) {
  debugPrint(
    '📦 Storing pending application: '
    'jobId=$jobId, status=$status',
  );

  _pendingApplicationJobId = jobId;
  _pendingApplicationStatus = status;
  _pendingApplicationApplicationId = applicationId;
}

static Map<String, String?>? consumePendingApplication() {
  final jobId = _pendingApplicationJobId;
  final status = _pendingApplicationStatus;
  final applicationId = _pendingApplicationApplicationId;

  _pendingApplicationJobId = null;
  _pendingApplicationStatus = null;
  _pendingApplicationApplicationId = null;

  if (jobId == null || jobId.isEmpty) {
    return null;
  }


  if (applicationId == null || applicationId.isEmpty) {
    return null;
  }

  debugPrint(
    '📦 Consuming pending application: '
    'jobId=$jobId, applicationId=$applicationId, status=$status',
  );

  return {
    'jobId': jobId,
    'applicationId':applicationId,
    'status': status,
  };
}

// ============================================================
// APPLICATION HANDLER
// ============================================================

static Future<void> Function(
  String jobId,
  String applicationId, {
  String? status,
})? onOpenApplicationDetails;

// ============================================================
// NOTIFICATION → APPLICATION
// ============================================================

static void navigateToApplication(
  String jobId,
  String applicationId, {
  String? status,
}) {
  debugPrint(
    '📋 navigateToApplication: '
    'jobId=$jobId, status=$status',
  );

  final handler = onOpenApplicationDetails;

  // MyApplicationPage is already mounted.
  if (handler != null) {
    debugPrint(
      '🚀 Application page is ready. '
      'Opening application directly.',
    );

    handler(
      jobId,
      applicationId,
      status: status,
    );

    return;
  }

  // Application page isn't mounted yet.
  setPendingApplication(
    jobId,
    applicationId,
    status: status,
  );

  final navigator = navigatorKey.currentState;

  if (navigator == null) {
    debugPrint(
      '⚠️ Navigator is not ready. '
      'Application notification remains pending.',
    );
    return;
  }

  debugPrint(
    '🚀 Opening MyApplicationPage...',
  );

  navigator.push(
    MaterialPageRoute(
      builder: (_) => MyApplicationPage(
        initialStatus: status,
        changeTab: (index, {status}) {},
      ),
    ),
  );
}

// ============================================================
// REGISTER APPLICATION HANDLER
// ============================================================

static void registerApplicationDetailsHandler(
  Future<void> Function(
    String jobId,
    String applicationId, {
    String? status,
  }) callback,
) {
  debugPrint('✅ Registering Application handler');

  onOpenApplicationDetails = callback;

  final pendingApplication = consumePendingApplication();

  if (pendingApplication == null) {
    debugPrint('ℹ️ No pending application notification');
    return;
  }

  final jobId = pendingApplication['jobId'];
  final applicationId = pendingApplication['applicationId'];
  final status = pendingApplication['status'];

  if (jobId == null || jobId.isEmpty) {
    debugPrint('❌ Pending application has no jobId');
    return;
  }

  if (applicationId == null || applicationId.isEmpty) {
    debugPrint('❌ Pending application has no applicationId');
    return;
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final handler = onOpenApplicationDetails;

    if (handler == null) {
      debugPrint('❌ Application handler disappeared');
      return;
    }

    debugPrint(
      '🚀 Sending pending application: '
      'jobId=$jobId, applicationId=$applicationId, status=$status',
    );

    handler(
      jobId,
      applicationId,
      status: status,
    );
  });
}

// ============================================================
// UNREGISTER APPLICATION HANDLER
// ============================================================

static void unregisterApplicationDetailsHandler() {
  debugPrint(
    '❌ Unregistering Application handler',
  );

  onOpenApplicationDetails = null;
}
}
