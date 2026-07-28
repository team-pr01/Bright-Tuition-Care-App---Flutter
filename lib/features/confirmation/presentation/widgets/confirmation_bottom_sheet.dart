import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/pdf/pdf_service.dart';
import 'package:btcclient/core/utils/date_formatter.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/reusable_bottom_sheet/reusable_bottom_sheet.dart';
import 'package:btcclient/features/confirmation/pdf/confirmation_letter_pdf.dart';
import 'package:btcclient/features/confirmation/presentation/provider/confirmation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmationBottomSheet extends ConsumerStatefulWidget {
  final String letterId;
  final String role;

  const ConfirmationBottomSheet({
    super.key,
    required this.letterId,
    required this.role,
  });

  @override
  ConsumerState<ConfirmationBottomSheet> createState() =>
      _ConfirmationBottomSheetState();
}

class _ConfirmationBottomSheetState
    extends ConsumerState<ConfirmationBottomSheet> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(confirmationProvider.notifier)
          .fetchSingleLetter(widget.letterId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(confirmationProvider);

    if (state.isLoading) {
      return const ReusableBottomSheet(
        child: SizedBox(
          height: 450,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final letter = state.selectedLetter;

    if (letter == null) {
      return const ReusableBottomSheet(
        child: SizedBox(
          height: 400,
          child: Center(child: Text("Unable to load confirmation letter.")),
        ),
      );
    }

    return ReusableBottomSheet(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Confirmation Letter",
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary01,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Dear Tutor & Guardian,",
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "Congratulations! Bright Tuition Care has successfully connected both of you for this tuition Job ID ${letter.job.jobId}.",
              style: AppTextStyles.bodyMedium,
            ),

            const SizedBox(height: 12),

            Text(
              "Below is a summary of the agreed tuition details. Please review them carefully before signing the confirmation letter.",
              style: AppTextStyles.bodyMedium,
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.neutrals01,
                borderRadius: BorderRadius.circular(AppRadius.large),
                border: Border.all(color: AppColors.primary01.withOpacity(.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tuition Details",
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _infoRow("Job ID", letter.job.jobId),

                  _infoRow("Job Title", letter.job.title),

                  _infoRow("Subjects", letter.job.subjects.join(", ")),

                  _infoRow("Class", letter.job.classes.join(", ")),

                  _infoRow("Salary", "${letter.job.salary} BDT"),

                  _infoRow(
                    "Schedule",
                    "${letter.job.tutoringDays}, ${letter.job.tutoringTime}",
                  ),

                  _infoRow(
                    "Location",
                    "${letter.job.cities.join(", ")}, ${letter.job.areas.join(", ")}",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ================= GUARDIAN =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.neutrals01,
                borderRadius: BorderRadius.circular(AppRadius.large),
                border: Border.all(color: AppColors.primary01.withOpacity(.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Guardian Information",
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _infoRow("Name", letter.guardian.name),

                  _infoRow("Guardian ID", letter.guardianCustomId),

                  _infoRow("Email", letter.guardian.email),

                  _infoRow("Phone", letter.guardian.phoneNumber),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ================= TUTOR =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.neutrals01,
                borderRadius: BorderRadius.circular(AppRadius.large),
                border: Border.all(color: AppColors.primary01.withOpacity(.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tutor Information",
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _infoRow("Name", letter.tutor.name),

                  _infoRow("Tutor ID", letter.tutorCustomId),

                  _infoRow("Email", letter.tutor.email),

                  _infoRow("Phone", letter.tutor.phoneNumber),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ================= SIGNATURES =================
            Text(
              "Digital Signatures",
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _signatureCard(
              context: context,
              title: "Guardian Signature",
              signature: letter.guardianSignature,
              signedDate: letter.guardianSignedDate,
              canSign: widget.role == "guardian",
              onPressed: () {
                _showSignatureDialog(isTutor: false);
              },
            ),

            const SizedBox(height: 16),

            _signatureCard(
              context: context,
              title: "Tutor Signature",
              signature: letter.tutorSignature,
              signedDate: letter.tutorSignedDate,
              canSign: widget.role == "tutor",
              onPressed: () {
                _showSignatureDialog(isTutor: true);
              },
            ),

            const SizedBox(height: 28),

            AppButton(
              label: "Download PDF",
              variant: AppButtonVariant.outline,
              icon: Icons.download,
              onPressed: () async {
                final pdfWidget = await ConfirmationLetterPdf.build(
                  letter: letter,
                );

                await PdfService.download(
                  fileName: "Confirmation_Letter_${letter.job.jobId}.pdf",
                  child: pdfWidget,
                );
              },
            ),

            const SizedBox(height: 14),

            Center(
              child: Text(
                "You can sign digitally or manually download the PDF, print it and sign with date.",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.neutrals03,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// ================= INFO ROW =================

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              "$title :",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutrals03,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value.isEmpty ? "-" : value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutrals02,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSignatureDialog({required bool isTutor}) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(isTutor ? "Tutor Signature" : "Guardian Signature"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Type Your Signature"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final signature = controller.text.trim();

                if (signature.isEmpty) return;

                final notifier = ref.read(confirmationProvider.notifier);

                bool success;

                if (isTutor) {
                  success = await notifier.signTutor(
                    id: widget.letterId,
                    signature: signature,
                  );
                } else {
                  success = await notifier.signGuardian(
                    id: widget.letterId,
                    signature: signature,
                  );
                }

                if (success) {
                  await notifier.fetchSingleLetter(widget.letterId);

                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text("Sign"),
            ),
          ],
        );
      },
    );
  }

  /// ================= SIGNATURE CARD =================

  Widget _signatureCard({
    required BuildContext context,
    required String title,
    required String? signature,
    required String? signedDate,
    required bool canSign,
    required VoidCallback onPressed,
  }) {
    final signed = signature != null && signature.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutrals01,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.primary01.withOpacity(.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          if (signed) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary01.withOpacity(.15)),
              ),
              child: Column(
                children: [
                  Text(
                    signature!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "AlexBrush", // Add this font in pubspec.yaml
                      fontSize: 38,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(width: 180, height: 1.2, color: Colors.black45),

                  const SizedBox(height: 8),

                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Signed on ${signedDate != null ? DateFormatter.formattedDate(signedDate) : "-"}",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.neutrals03,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              alignment: Alignment.center,
              child: Text(
                "No Signature Yet",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutrals03,
                ),
              ),
            ),

            const SizedBox(height: 16),

            if (canSign)
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: "Sign Now",
                  onPressed: onPressed,
                  variant: AppButtonVariant.gradient,
                  icon: Icons.draw,
                ),
              )
            else
              Center(
                child: Text(
                  "Only the ${title.replaceAll(" Signature", "")} can sign.",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.neutrals03,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
