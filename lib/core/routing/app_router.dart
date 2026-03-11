import 'package:flutter/material.dart';

import '../../features/tutor/presentation/tutor_dashboard_screen.dart';
import '../../features/guardian/presentation/guardian_dashboard_screen.dart';

class AppRouter {

  static Widget getDashboardByRole(String? role) {
    switch (role) {

      case "tutor":
        return const TutorDashboardScreen();

      case "guardian":
        return const GuardianDashboardScreen();

      default:
        return const GuardianDashboardScreen();

    }

  }

}