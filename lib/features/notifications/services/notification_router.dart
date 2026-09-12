import 'package:flutter/foundation.dart';

import 'package:btcclient/core/services/navigation_service.dart';
import 'package:btcclient/features/legal/data/tutor_important_guidelines_data.dart';

class NotificationRouter {
  NotificationRouter._();

  /// Handles navigation for every notification in the app.
  ///
  /// The notification `type` determines where the user should be
  /// taken. Each notification type can use different data.
  static void handleNotification(Map<String, dynamic> data) {
    print('🔔 NotificationRouter received: $data');

    final type = data['type']?.toString();

    if (type == null || type.isEmpty) {
      debugPrint('⚠️ Notification has no type');
      return;
    }

    switch (type) {
      // ============================================================
      // REAL NOTIFICATION TYPE
      // ============================================================

      case 'new_job_alert':
        _handleNewJobAlert(data);
        break;

      case 'job_details':
        _handleNewJobAlert(data);
        break;
      case 'invoice_details':
        _handleInvoiceDetails(data);
        break;

      // ============================================================
      // TUTOR IMPORTANT GUIDELINES
      // ============================================================

      case 'tutor_important_guidelines':
        _handleTutorImportantGuidelines();
        break;

      // ============================================================
      // FUTURE NOTIFICATION TYPES
      // ============================================================

      // case 'application_accepted':
      //   _handleApplicationAccepted(data);
      //   break;

      // case 'payment_received':
      //   _handlePaymentReceived(data);
      //   break;

      // case 'chat_message':
      //   _handleChatMessage(data);
      //   break;

      // case 'profile_update':
      //   _handleProfileUpdate(data);
      //   break;

      default:
        debugPrint('⚠️ Unknown notification type: $type');
        break;
    }
  }

  // ================================================================
  // NEW JOB ALERT
  // ================================================================

  static void _handleNewJobAlert(Map<String, dynamic> data) {
    final jobId = data['jobId']?.toString();

    if (jobId == null || jobId.isEmpty) {
      debugPrint('⚠️ new_job_alert notification does not contain jobId');
      return;
    }

    debugPrint('🔔 Opening job from notification: $jobId');

    /*
     * IMPORTANT:
     *
     * Your app does NOT have a separate Job Details page.
     *
     * The job is opened using the Tutor Dashboard's
     * registered callback, which displays the job bottom sheet.
     *
     * NavigationService already handles the case where the
     * dashboard is not ready by storing the pending job ID.
     */

    NavigationService.navigateToJobDetails(jobId);
  }

  static void _handleInvoiceDetails(Map<String, dynamic> data) {
    final invoiceId = data['invoiceId']?.toString();

    if (invoiceId == null || invoiceId.isEmpty) {
      debugPrint('⚠️ invoice_details notification does not contain invoiceId');
      return;
    }

    debugPrint('🔔 Opening invoice from notification: $invoiceId');

    NavigationService.navigateToInvoiceDetails(invoiceId);
  }
  // ================================================================
  // TUTOR IMPORTANT GUIDELINES
  // ================================================================

  static void _handleTutorImportantGuidelines() {
    debugPrint('🔔 Opening Tutor Important Guidelines');

    NavigationService.navigateToImportantGuidelines(
      tutorImportantGuidelinesData,
    );
  }

  // ================================================================
  // FUTURE HANDLERS
  // ================================================================

  // Keep these commented until the backend actually introduces
  // those notification types.

  // static void _handleApplicationReceived(
  //   Map<String, dynamic> data,
  // ) {
  //   final applicationId =
  //       data['applicationId']?.toString();
  //
  //   if (applicationId == null || applicationId.isEmpty) {
  //     return;
  //   }
  //
  //   // NavigationService.navigateToApplication(applicationId);
  // }

  // static void _handleApplicationAccepted(
  //   Map<String, dynamic> data,
  // ) {
  //   // Future implementation
  // }

  // static void _handlePaymentReceived(
  //   Map<String, dynamic> data,
  // ) {
  //   // Future implementation
  // }

  // static void _handleChatMessage(
  //   Map<String, dynamic> data,
  // ) {
  //   // Future implementation
  // }

  // static void _handleProfileUpdate(
  //   Map<String, dynamic> data,
  // ) {
  //   // Future implementation
  // }
}
