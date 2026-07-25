import 'package:flutter/material.dart';

class CredentialDocumentCard extends StatelessWidget {
  final String title;
  final String? fileUrl;
  final VoidCallback? onView;
  final VoidCallback? onEdit;

  const CredentialDocumentCard({
    super.key,
    required this.title,
    this.fileUrl,
    this.onView,
    this.onEdit,
  });

  bool get hasDocument =>
      fileUrl != null && fileUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: const Color(0xffEDF4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              hasDocument
                  ? Icons.description_outlined
                  : Icons.upload_file_outlined,
              color: const Color(0xff246BFD),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  hasDocument
                      ? "Document Uploaded"
                      : "Document Not Uploaded",
                  style: TextStyle(
                    color: hasDocument
                        ? Colors.green
                        : Colors.red,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          if (hasDocument)
            OutlinedButton.icon(
              onPressed: onView,
              icon: const Icon(Icons.visibility_outlined),
              label: const Text("View"),
            ),

          if (onEdit != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ],
      ),
    );
  }
}