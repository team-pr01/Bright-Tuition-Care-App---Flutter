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

}