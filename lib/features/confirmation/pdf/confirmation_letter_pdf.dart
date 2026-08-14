import 'package:btcclient/core/pdf/pdf_service.dart';
import 'package:btcclient/core/utils/date_formatter.dart';
import 'package:btcclient/features/confirmation/data/models/confirmation_letter_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ConfirmationLetterPdf {
  ConfirmationLetterPdf._();

  static Future<pw.Widget> build({
    required ConfirmationLetterModel letter,
  }) async {
    final regular = await PdfService.loadFont(
      "assets/fonts/Outfit-Regular.ttf",
    );

    final bold = await PdfService.loadFont("assets/fonts/Outfit-Bold.ttf");

    final signature = await PdfService.loadFont(
      "assets/fonts/AlexBrush-Regular.ttf",
    );

    final logo = await PdfService.loadImage("assets/images/logo.png");

    final labelStyle = pw.TextStyle(font: bold, fontSize: 12);

    final valueStyle = pw.TextStyle(font: regular, fontSize: 12);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        /// LOGO
        pw.Center(child: pw.Image(logo, width: 150, height: 40)),

        pw.SizedBox(height: 20),

        /// TITLE
        pw.Center(
          child: pw.Text(
            "Confirmation Letter",
            style: pw.TextStyle(
              font: bold,
              fontSize: 18,
              decoration: pw.TextDecoration.underline,
            ),
          ),
        ),

        pw.SizedBox(height: 20),

        pw.RichText(
          text: pw.TextSpan(
            style: valueStyle,
            children: [
              const pw.TextSpan(text: "Dear "),
              pw.TextSpan(text: "Tutor", style: labelStyle),
              const pw.TextSpan(text: " & "),
              pw.TextSpan(text: "Guardian", style: labelStyle),
              const pw.TextSpan(text: ","),
            ],
          ),
        ),

        pw.SizedBox(height: 8),

        pw.Text(
          "We are pleased to let you know that Bright Tuition Care has successfully connected both of you for this tuition Job ID: ${letter.job.jobId}.",
          style: valueStyle,
        ),

        pw.SizedBox(height: 6),

        pw.Text(
          "Below is a summary of the key requirements and agreed-upon details for this tuition engagement",
          style: valueStyle,
        ),

        pw.SizedBox(height: 6),

        pw.Text(
          "To ensure clarity and prevent any future misunderstandings, we kindly request both the Tutor and the Guardian/Student to review and sign the confirmation letter.",
          style: valueStyle,
        ),

        pw.SizedBox(height: 16),

        pw.Text(
          "Tuition Details",
          style: pw.TextStyle(font: bold, fontSize: 14),
        ),

        pw.SizedBox(height: 10),

        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey500),
          ),
          child: pw.Column(
            children: [
              _row(
                "Subject",
                letter.job.subjects.join(", "),
                labelStyle,
                valueStyle,
              ),

              _row(
                "Class",
                letter.job.classes.join(", "),
                labelStyle,
                valueStyle,
              ),

              _row(
                "Salary",
                "${letter.job.salary} BDT",
                labelStyle,
                valueStyle,
              ),

              _row(
                "Schedule",
                "${letter.job.tutoringDays}, ${letter.job.tutoringTime}",
                labelStyle,
                valueStyle,
              ),

              _row(
                "Location",
                "${letter.job.cities.join(", ")}, ${letter.job.areas.join(", ")}",
                labelStyle,
                valueStyle,
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 20),

        pw.Text(
          "User Information",
          style: pw.TextStyle(font: bold, fontSize: 14),
        ),

        pw.SizedBox(height: 10),

        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            /// Guardian
            pw.Expanded(
              child: pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey500),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Guardian",
                      style: pw.TextStyle(font: bold, fontSize: 12),
                    ),

                    pw.SizedBox(height: 8),

                    _row(
                      "Name",
                      letter.guardianName.isNotEmpty
                          ? letter.guardianName
                          : "Not available",
                      labelStyle,
                      valueStyle,
                    ),

                    _row(
                      "ID",
                      letter.guardianCustomId.isNotEmpty
                          ? letter.guardianCustomId
                          : "Not available",
                      labelStyle,
                      valueStyle,
                    ),

                    _row(
                      "Email",
                      letter.guardianEmail.isNotEmpty
                          ? letter.guardianEmail
                          : "Not available",
                      labelStyle,
                      valueStyle,
                    ),

                    _row(
                      "Phone",
                      letter.guardianPhone.isNotEmpty
                          ? letter.guardianPhone
                          : "Not available",
                      labelStyle,
                      valueStyle,
                    )
                  ],
                ),
              ),
            ),

            pw.SizedBox(width: 12),

            /// Tutor
            pw.Expanded(
              child: pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey500),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Tutor",
                      style: pw.TextStyle(font: bold, fontSize: 12),
                    ),

                    pw.SizedBox(height: 8),

                    _row("Name", letter.tutor.name, labelStyle, valueStyle),

                    _row("ID", letter.tutorCustomId, labelStyle, valueStyle),

                    _row("Email", letter.tutor.email, labelStyle, valueStyle),

                    _row(
                      "Phone",
                      letter.tutor.phoneNumber,
                      labelStyle,
                      valueStyle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        pw.SizedBox(height: 20),
        pw.SizedBox(height: 35),

        /// ---------------- SIGNATURES ----------------
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            /// Guardian
            pw.Container(
              width: 220,
              child: pw.Column(
                children: [
                  pw.SizedBox(
                    height: 35,
                    child: pw.Center(
                      child: (letter.guardianSignature?.isNotEmpty ?? false)
                          ? pw.Text(
                              letter.guardianSignature!,
                              style: pw.TextStyle(
                                font: signature,
                                fontSize: 24,
                              ),
                            )
                          : pw.SizedBox(),
                    ),
                  ),

                  pw.Divider(),

                  pw.Text("Guardian Signature", style: valueStyle),

                  pw.SizedBox(height: 4),

                  pw.Text(
                    letter.guardianSignedDate != null
                        ? DateFormatter.formattedDate(
                            letter.guardianSignedDate!,
                          )
                        : "(with Date)",
                    style: valueStyle,
                  ),
                ],
              ),
            ),

            /// Tutor
            pw.Container(
              width: 220,
              child: pw.Column(
                children: [
                  pw.SizedBox(
                    height: 35,
                    child: pw.Center(
                      child: (letter.tutorSignature?.isNotEmpty ?? false)
                          ? pw.Text(
                              letter.tutorSignature!,
                              style: pw.TextStyle(
                                font: signature,
                                fontSize: 24,
                              ),
                            )
                          : pw.SizedBox(),
                    ),
                  ),

                  pw.Divider(),

                  pw.Text("Tutor Signature", style: valueStyle),

                  pw.SizedBox(height: 4),

                  pw.Text(
                    letter.tutorSignedDate ?? "(with Date)",
                    style: valueStyle,
                  ),
                ],
              ),
            ),
          ],
        ),

        pw.SizedBox(height: 25),

        pw.Center(
          child: pw.Text(
            "Thank you for staying with Bright Tuition Care.",
            style: labelStyle,
          ),
        ),
      ],
    );
  }

  static pw.Widget _row(
    String title,
    String value,
    pw.TextStyle label,
    pw.TextStyle valueStyle,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(child: pw.Text("$title : ", style: valueStyle)),

          pw.Expanded(
            child: pw.Text(value.isEmpty ? "-" : value, style: valueStyle),
          ),
        ],
      ),
    );
  }
}
