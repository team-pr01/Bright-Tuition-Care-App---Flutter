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
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary01),
          ),
        ),
      );
    }

    final letter = state.selectedLetter;

    if (letter == null) {
      return const ReusableBottomSheet(
        child: SizedBox(
          height: 400,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: AppColors.neutrals04,
                ),
                SizedBox(height: 12),
                Text(
                  "Unable to load confirmation letter.",
                  style: TextStyle(color: AppColors.neutrals03),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ReusableBottomSheet(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ========== HEADER ==========
            _buildHeader(),

            const SizedBox(height: 24),

            /// ========== CONGRATULATIONS MESSAGE ==========
            _buildCongratulationsMessage(letter),

            const SizedBox(height: 28),

            /// ========== TUITION DETAILS ==========
            _buildSectionCard(
              title: " Tuition Details",
              icon: Icons.school_outlined,
              children: [
                _infoRow("Job ID", letter.job.jobId, isHighlighted: true),
                _infoRow("Job Title", letter.job.title),
                _infoRow("Subjects", letter.job.subjects.join(", ")),
                _infoRow("Class", letter.job.classes.join(", ")),
                _infoRow("Salary", "${letter.job.salary} BDT", isMoney: true),
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

            const SizedBox(height: 20),

            /// ========== GUARDIAN INFORMATION ==========
            _buildSectionCard(
              title: " Guardian Information",
              icon: Icons.person_outline_rounded,
              children: [
                _infoRow("Name", letter.guardian?.name ?? "-"),
                _infoRow("Guardian ID", letter.guardianCustomId),
                _infoRow("Email", letter.guardian?.email ?? "-"),
                _infoRow("Phone", letter.guardian?.phoneNumber ?? "-"),
              ],
            ),

            const SizedBox(height: 20),

            /// ========== TUTOR INFORMATION ==========
            _buildSectionCard(
              title: " Tutor Information",
              icon: Icons.person_outline_rounded,
              children: [
                _infoRow("Name", letter.tutor.name),
                _infoRow("Tutor ID", letter.tutorCustomId),
                _infoRow("Email", letter.tutor.email),
                _infoRow("Phone", letter.tutor.phoneNumber),
              ],
            ),

            const SizedBox(height: 28),

            /// ========== DIGITAL SIGNATURES ==========
            Text(
              "Digital Signatures",
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.neutrals02,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "Both parties must sign to confirm the tuition agreement",
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.neutrals03,
              ),
            ),

            const SizedBox(height: 16),

            _buildSignatureCard(
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

            _buildSignatureCard(
              context: context,
              title: "Tutor Signature",
              signature: letter.tutorSignature,
              signedDate: letter.tutorSignedDate,
              canSign: widget.role == "tutor",
              onPressed: () {
                _showSignatureDialog(isTutor: true);
              },
            ),

            const SizedBox(height: 32),

            /// ========== ACTION BUTTONS ==========
            AppButton(
              label: "Download PDF",
              variant: AppButtonVariant.gradient,
              icon: Icons.download_outlined,
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

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary03.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: AppColors.primary01,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "You can sign digitally or manually download the PDF, print it and sign with date.",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutrals02,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// ========== BUILD HEADER ==========
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary01, AppColors.primary01.withOpacity(0.8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_outlined,
              color: AppColors.primary01,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Confirmation Letter",
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tuition Agreement Verification",
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  /// ========== BUILD CONGRATULATIONS MESSAGE ==========
  Widget _buildCongratulationsMessage(letter) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary03.withOpacity(0.2),
            AppColors.primary03.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // borderRadius: BorderRadius.circular(AppRadius.medium),
        // border: Border.all(
        //   color: AppColors.primary01.withOpacity(0.15),
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.celebration_outlined,
                color: AppColors.primary01,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                "Dear Tutor & Guardian,",
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary01,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Congratulations! Bright Tuition Care has successfully connected both of you for this tuition Job ID ${letter.job.jobId}.",
            style: AppTextStyles.bodyMedium.copyWith(
              height: 1.6,
              color: AppColors.neutrals02,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Below is a summary of the agreed tuition details. Please review them carefully before signing the confirmation letter.",
            style: AppTextStyles.bodyMedium.copyWith(
              height: 1.6,
              color: AppColors.neutrals03,
            ),
          ),
        ],
      ),
    );
  }

  /// ========== BUILD SECTION CARD ==========
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.primary01.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: AppColors.primary01),
              const SizedBox(width: 10),
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutrals02,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  /// ========== INFO ROW ==========
  Widget _infoRow(
    String title,
    String value, {
    bool isHighlighted = false,
    bool isMoney = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$title :",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutrals03,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "-" : value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isHighlighted
                    ? AppColors.primary01
                    : isMoney
                    ? AppColors.success
                    : AppColors.neutrals02,
                fontWeight: isHighlighted || isMoney
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ========== BUILD SIGNATURE CARD ==========
  Widget _buildSignatureCard({
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: signed
              ? AppColors.success.withOpacity(0.3)
              : AppColors.primary01.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                signed ? Icons.check_circle_rounded : Icons.draw_outlined,
                size: 22,
                color: signed ? AppColors.success : AppColors.primary01,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutrals02,
                ),
              ),
              const Spacer(),
              if (signed)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Signed ✓",
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          if (signed) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primary03.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary01.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  Text(
                    signature!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "AlexBrush",
                      fontSize: 38,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 180,
                    height: 1.5,
                    color: AppColors.neutrals04,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.neutrals03,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    signedDate != null
                        ? "Signed on ${DateFormatter.formattedDate(signedDate)}"
                        : "-",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.neutrals03,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.neutrals01,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.neutrals04.withOpacity(0.5),
                ),
                // borderSide: const BorderSide(style: BorderStyle.solid),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.draw_outlined,
                    size: 28,
                    color: AppColors.neutrals04,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Awaiting Signature",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.neutrals03,
                    ),
                  ),
                ],
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
                  icon: Icons.draw_outlined,
                  height: 44,
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
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

  /// ========== SHOW SIGNATURE DIALOG ==========
  Future<void> _showSignatureDialog({required bool isTutor}) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          title: Row(
            children: [
              Icon(Icons.draw_outlined, color: AppColors.primary01, size: 24),
              const SizedBox(width: 10),
              Text(
                isTutor ? "Tutor Signature" : "Guardian Signature",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Type your full name as your digital signature:",
                style: TextStyle(color: AppColors.neutrals03),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Type your signature",
                  hintStyle: TextStyle(color: AppColors.neutrals04),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    borderSide: BorderSide(color: AppColors.neutrals04),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    borderSide: BorderSide(color: AppColors.primary01),
                  ),
                ),
                autofocus: true,
                textCapitalization: TextCapitalization.words,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: AppColors.neutrals03),
              ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary01,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
              ),
              child: const Text("Sign"),
            ),
          ],
        );
      },
    );
  }
}
