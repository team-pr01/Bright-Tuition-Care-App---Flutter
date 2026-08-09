import 'package:flutter/material.dart';

class NavigationService {
  NavigationService._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get context =>
      navigatorKey.currentContext;

  // ============================================================
  // PENDING JOB
  // ============================================================

  static String? _pendingJobId;

  static String? get pendingJobId => _pendingJobId;

  static void setPendingJob(String jobId) {
    debugPrint(
      '📦 NavigationService: storing pending job $jobId',
    );

    _pendingJobId = jobId;
  }

  static String? consumePendingJob() {
    final jobId = _pendingJobId;

    if (jobId != null) {
      debugPrint(
        '📦 NavigationService: consuming pending job $jobId',
      );
    }

    _pendingJobId = null;

    return jobId;
  }

  // ============================================================
  // DASHBOARD HANDLER
  // ============================================================

  static Future<void> Function(String jobId)?
      onOpenJobDetails;

  // ============================================================
  // NOTIFICATION → DASHBOARD
  // ============================================================

  static void navigateToJobDetails(String jobId) {
    debugPrint(
      '🔔 NavigationService.navigateToJobDetails: $jobId',
    );

    final handler = onOpenJobDetails;

    if (handler != null) {
      debugPrint(
        '✅ Dashboard handler available',
      );

      handler(jobId);
      return;
    }

    debugPrint(
      '⏳ Dashboard not ready → storing pending job',
    );

    setPendingJob(jobId);
  }

  // ============================================================
  // REGISTER DASHBOARD HANDLER
  // ============================================================

  static void registerJobDetailsHandler(
    Future<void> Function(String jobId) callback,
  ) {
    debugPrint(
      '✅ Registering Dashboard job handler',
    );

    onOpenJobDetails = callback;

    final pendingJob = consumePendingJob();

    if (pendingJob == null) {
      debugPrint(
        'ℹ️ No pending job notification',
      );
      return;
    }

    debugPrint(
      '📦 Pending notification job found: $pendingJob',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (onOpenJobDetails != null) {
        debugPrint(
          '🚀 Sending pending job to Dashboard: $pendingJob',
        );

        onOpenJobDetails!(pendingJob);
      }
    });
  }

  // ============================================================
  // UNREGISTER
  // ============================================================

  static void unregisterJobDetailsHandler() {
    debugPrint(
      '❌ Unregistering Dashboard job handler',
    );

    onOpenJobDetails = null;
  }
}