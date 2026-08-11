import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:flutter/material.dart';

class CredentialDocumentCard extends StatelessWidget {
  final String title;
  final String? fileUrl;

  final VoidCallback? onView;
  final VoidCallback? onDelete;

  const CredentialDocumentCard({
    super.key,
    required this.title,
    this.fileUrl,
    this.onView,
    this.onDelete,
  });

  bool get hasDocument => fileUrl != null && fileUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // =====================================================
          // ICON 
          // =====================================================
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: const Color(0xffEDF4FF),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              hasDocument
                  ? Icons.description_outlined
                  : Icons.upload_file_outlined,
              color: const Color(0xff246BFD),
            ),
          ),

          const SizedBox(width: 16),

          // =====================================================
          // DOCUMENT INFO
          // =====================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),

               
              ],
            ),
          ),

          // =====================================================
          // VIEW
          // =====================================================
          if (hasDocument)
            AppButton(
              iconOnly: true,
              icon: Icons.visibility_outlined,
              variant: AppButtonVariant.outlineGray,
              width: 32,
              height: 32,
              onPressed: onView,
            ),

          const SizedBox(width: 8),

          // =====================================================
          // DELETE
          // =====================================================
          AppButton(
            iconOnly: true,
            icon: Icons.delete_outline,
            variant: AppButtonVariant.outlineGray,
            width: 32,
            height: 32,
            onPressed: onDelete,
            textColor: AppColors.error,
          ),
        ],
      ),
    );
  }
}
