import 'package:flutter/material.dart';

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';

import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/profile/presentation/widgets/shared/credential_document_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/shared/full_screen_image_viewer.dart';

class CredentialSectionCard extends StatelessWidget {
  final List identities;

  /// Called when user clicks Add Credentials / Add More.
  final VoidCallback? onAdd;

  /// Called when user clicks Delete on an existing credential.
  final void Function(Identity identity)? onDelete;

  const CredentialSectionCard({
    super.key,
    required this.identities,
    this.onAdd,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================================================
          // HEADER
          // ============================================================
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Credential Information",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              // ========================================================
              // ADD / ADD MORE
              // ========================================================
              if (identities.isEmpty)
                AppButton(
                  onPressed: onAdd,
                  label: identities.isEmpty ? "Add Credentials" : "Add More",
                  icon: Icons.add,
                  variant: AppButtonVariant.outlineGray,
                  height: 36,
                  width: identities.isEmpty ? 150 : 120,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.primary01,
                  borderRadius: 8,
                  borderWidth: 1,
                  backgroundColor: Colors.white,
                ),
            ],
          ),

          const SizedBox(height: 20),

          // ============================================================
          // EMPTY STATE
          // ============================================================
          if (identities.isEmpty)
            _buildEmptyState()
          // ============================================================
          // DOCUMENT LIST
          // ============================================================
          else
            Column(
              children: identities.map<Widget>((identity) {
                return CredentialDocumentCard(
                  title: identity.fileType.isEmpty
                      ? "Untitled Document"
                      : identity.fileType,

                  fileUrl: identity.file,

                  // ----------------------------------------------------
                  // VIEW
                  // ----------------------------------------------------
                  onView: () {
                    if (identity.file.isEmpty) {
                      return;
                    }

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

                  // ----------------------------------------------------
                  // DELETE
                  // ----------------------------------------------------
                  onDelete: onDelete == null
                      ? null
                      : () {
                          onDelete!(identity);
                        },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // ================================================================
  // EMPTY STATE
  // ================================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // ----------------------------------------------------------
          // ICON
          // ----------------------------------------------------------
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xffEDF4FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.description_outlined,
              size: 32,
              color: AppColors.primary01,
            ),
          ),

          const SizedBox(height: 16),

          // ----------------------------------------------------------
          // TITLE
          // ----------------------------------------------------------
          const Text(
            "No documents uploaded yet.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 6),

          // ----------------------------------------------------------
          // DESCRIPTION
          // ----------------------------------------------------------
          const Text(
            "Upload your credential document to complete "
            "your profile.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, height: 1.4, color: Colors.black54),
          ),

          const SizedBox(height: 20),

          // ----------------------------------------------------------
          // ADD CREDENTIAL
          // ----------------------------------------------------------
          AppButton(
            onPressed: onAdd,
            label: "Add Credentials Info",
            icon: Icons.add,
            variant: AppButtonVariant.outlineGray,
            height: 36,
            width: 180,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textColor: AppColors.primary01,
            borderRadius: 8,
            borderWidth: 1,
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
