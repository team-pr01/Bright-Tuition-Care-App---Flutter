import 'package:btcclient/core/utils/open_document.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:flutter/material.dart';

String getCertificateTitle(String fileType) {
  if (fileType.contains("SSC")) {
    return "SSC Certificate";
  }

  if (fileType.contains("HSC")) {
    return "HSC Certificate";
  }

  if (fileType.contains("NID")) {
    return "Identity Document";
  }

  if (fileType.contains("University")) {
    return "University Document";
  }

  return "Other Document";
}

class CredentialSectionCard extends StatelessWidget {
  final List<Identity> identities;

  const CredentialSectionCard({super.key, required this.identities});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Credentials Information",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),

        CredentialProgressHeader(totalCredentials: identities.length),

        const SizedBox(height: 20),

        ...identities.asMap().entries.map((entry) {
          final index = entry.key;
          final identity = entry.value;

          return CredentialItemCard(
            title: identity.fileType,
            subtitle: identity.fileUrl,
            fileUrl: identity.fileUrl,

            onView: () async {
              await openDocument(identity.fileUrl);
            },

            onDelete: () {
              debugPrint("Delete ${identity.fileType}");
            },
          );
        }),
      ],
    );
  }
}

class CredentialProgressHeader extends StatelessWidget {
  final int totalCredentials;

  const CredentialProgressHeader({super.key, required this.totalCredentials});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        totalCredentials,
        (index) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == totalCredentials - 1 ? 0 : 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Credential ${index + 1}"),

                    const Text(
                      "Completed",
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.indigo],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CredentialItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String fileUrl;

  final VoidCallback onView;
  final VoidCallback onDelete;

  const CredentialItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.fileUrl,
    required this.onView,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Row(
        children: [
          const Icon(Icons.description_outlined, size: 32),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          FilledButton.tonal(onPressed: onView, child: const Text("View")),

          const SizedBox(width: 8),

          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
