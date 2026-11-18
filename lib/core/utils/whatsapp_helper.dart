import 'package:url_launcher/url_launcher.dart';

class WhatsAppHelper {
  static Future<void> openChat({
    required String phoneNumber,
    String? message,
  }) async {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.isEmpty) return;

    final encodedMessage =
        message == null ? '' : '?text=${Uri.encodeComponent(message)}';

    final appUri = Uri.parse('whatsapp://send?phone=$cleaned$encodedMessage');
    final webUri = Uri.parse('https://wa.me/$cleaned$encodedMessage');

    try {
      if (await canLaunchUrl(appUri)) {
        await launchUrl(appUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    try {
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }
}