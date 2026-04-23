import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';

class StatusDataFormatter {
  static Color getStatusColor(String? status) {
    switch (status) {
      case "applied":
        return Colors.grey;
      case "shortlisted":
        return AppColors.primary01;
      case "appointed":
        return const Color(0xFF9C9700);
      case "confirmed":
      case "ongoing":
        return const Color(0xFF39BA3D);
      case "withdrawn":
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  static Color getStatusColorGuardian(String? status) {
    switch (status) {
      case "pending":
        return Colors.yellow;
      case "closed":
        return Colors.grey;
      case "cancelled":
        return Colors.red;
      default:
         return const Color(0xFF39BA3D);
    }
  }

  static String getStatusLabel(String? status) {
    switch (status) {
      case "applied":
        return "Applied";
      case "shortlisted":
        return "Shortlisted";
      case "appointed":
        return "Appointed";
      case "confirmed":
        return "Confirmed";
      case "ongoing":
        return "Ongoing";
      case "withdrawn":
        return "Withdrawn";
      case "rejected":
        return "Rejected";
      default:
        return "Applied";
    }
  }

  static Color getJobApplicationStatusColor(String status) {
  switch (status) {
    case "applied":
      return Colors.blue;
    case "shortlisted":
      return Colors.orange;
    case "appointed":
    case "confirmed":
      return Colors.green;
    case "rejected":
      return Colors.red;
    default:
      return Colors.grey;
  }
}

}