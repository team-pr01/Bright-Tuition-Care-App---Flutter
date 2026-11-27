import 'package:intl/intl.dart';

class DateFormatter {
  static String formatSince(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('MMM yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  static String formatSinceFullDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('MMM d, yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  static String formattedDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  static String formattedFormalDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  static String formatNotificationTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return "-";
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      return DateFormat('dd MMM yyyy • hh:mm a').format(dateTime);
    } catch (_) {
      return isoString; // fallback to raw string if parsing fails
    }
  }
}
