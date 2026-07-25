import 'package:btcclient/features/profile/presentation/widgets/shared/credential_document_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/shared/full_screen_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';

class CredentialSectionCard extends StatelessWidget {
  final List<Identity> identities;
  final void Function(Identity identity)? onEdit;

  const CredentialSectionCard({
    super.key,
    required this.identities,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Credential Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffEDF4FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${identities.length} Document${identities.length == 1 ? "" : "s"}",
                  style: const TextStyle(
                    color: Color(0xff246BFD),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (identities.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: const Color(0xffF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 52,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No documents uploaded yet.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            )
          else
            ...identities.map(
              (identity) => CredentialDocumentCard(
                title: identity.fileType.isEmpty
                    ? "Untitled Document"
                    : identity.fileType,
                fileUrl: identity.file,
                onView: () {
                  if (identity.file.isEmpty) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullScreenImageViewer(
                        imageUrl: identity.file,
                        title: identity.fileType,
                      ),
                    ),
                  );
                },
                onEdit: onEdit == null
                    ? null
                    : () => onEdit!(identity),
              ),
            ),
        ],
      ),
    );
  }
}