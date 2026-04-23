import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SuccessBottomSheet extends StatelessWidget {
  final String role;
  final Function(int, {String? status}) changeTab;

  const SuccessBottomSheet({
    super.key,
    required this.role,
    required this.changeTab,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// ✅ ICON
        const Icon(
          Icons.check_circle,
          size: 70,
          color: Colors.green,
        ),

        const SizedBox(height: 16),

        /// ✅ TITLE
        const Text(
          "Submitted Successfully!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        /// ✅ MESSAGE
        if (role == "guardian")
          const Text(
            "Thank you for submitting your tutor request. One of our executives will contact you within 24 hours.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.5,
            ),
          ),

        const SizedBox(height: 20),

        /// ✅ CALL BOX
        if (role == "guardian")
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border.all(color: Colors.blue.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.phone, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      "Need Immediate Assistance?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                const Text(
                  "Having any problem or urgent requirement?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 12),

                ElevatedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse("tel:09617785588");
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                   }
                  },
                  icon: const Icon(Icons.phone, size: 16),
                  label: const Text("Call Us: 09617-785588"),
                ),

                const SizedBox(height: 10),

                /// 🔥 FIXED BUTTON
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);

                    /// 🔥 VERY IMPORTANT (fix navigation issue)
                    Future.microtask(() {
                      changeTab(2); // 👈 dashboard tab
                    });
                  },
                  child: const Text("Go to Dashboard"),
                ),
              ],
            ),
          ),
      ],
    );
  }
}