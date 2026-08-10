import 'package:flutter/foundation.dart';

import 'package:btcclient/core/services/navigation_service.dart';

class NotificationRouter {
  NotificationRouter._();

  /// Handles navigation for every notification in the app.
  ///
  /// The notification `type` determines where the user should be
  /// taken. Each notification type can use different data.
  static void handleNotification(
    Map<String, dynamic> data,
  ) {
    debugPrint('🔔 NotificationRouter received: $data');

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

      // ============================================================ 
      // FUTURE NOTIFICATION TYPES
      // ====================================== job_details======================
      //
      // Add new backend notification types here.
      //
      // Example:
      //
      // case 'application_received':
      //   _handleApplicationReceived(data);
      //   break;
      //
      // case 'application_accepted':
      //   _handleApplicationAccepted(data);
      //   break;
      //
      // case 'payment_received':
      //   _handlePaymentReceived(data);
      //   break;
      //
      // case 'chat_message':
      //   _handleChatMessage(data);
      //   break;
      //
      // case 'profile_update':
      //   _handleProfileUpdate(data);
      //   break;

      default:
        debugPrint(
          '⚠️ Unknown notification type: $type',
        );
        break;
    }
  }

  // ================================================================
  // NEW JOB ALERT
  // ================================================================

  static void _handleNewJobAlert(
    Map<String, dynamic> data,
  ) {
    final jobId = data['jobId']?.toString();

    if (jobId == null || jobId.isEmpty) {
      debugPrint(
        '⚠️ new_job_alert notification does not contain jobId',
      );
      return;
    }

    debugPrint(
      '🔔 Opening job from notification: $jobId',
    );

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

  // ================================================================
  // FUTURE HANDLERS
  // ================================================================
  //
  // Keep these commented until the backend actually introduces
  // those notification types.
  //
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
  //
  // static void _handleApplicationAccepted(
  //   Map<String, dynamic> data,
  // ) {
  //   // Future implementation
  // }
  //
  // static void _handlePaymentReceived(
  //   Map<String, dynamic> data,
  // ) {
  //   // Future implementation
  // }
  //
  // static void _handleChatMessage(
  //   Map<String, dynamic> data,
  // ) {
  //   // Future implementation
  // }
}