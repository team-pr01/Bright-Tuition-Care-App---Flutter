import 'package:btcclient/core/pdf/pdf_service.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class TutorResumePdf {
  TutorResumePdf._();

  static Future<pw.Widget> build({required TutorProfileModel profile}) async {
       final dummyImage = await PdfService.loadImage(
      'assets/images/dummy-avatar.jpg',
    );
    pw.ImageProvider image = dummyImage;

    if (profile.imageUrl != null && profile.imageUrl!.isNotEmpty) {
      try {
        image = await PdfService.loadNetworkImage(profile.imageUrl!);
      } catch (_) {
        image = dummyImage;
      }
    }

    final regular = await PdfService.loadFont(
      "assets/fonts/Outfit-Regular.ttf",
    );

    final semiBold = await PdfService.loadFont("assets/fonts/Outfit-SemiBold.ttf");

    final logo = await PdfService.loadImage("assets/images/logo.png");

    pw.MemoryImage? profileImage;

    if (profile.imageUrl != null &&
        profile.imageUrl!.isNotEmpty &&
        profile.imageUrl!.startsWith("http")) {
      try {
        profileImage = await PdfService.loadNetworkImage(profile.imageUrl!);
      } catch (_) {}
    }

    final titleStyle = pw.TextStyle(
      font: semiBold,
      fontSize: 17,
      color: PdfColors.black,
    );

    final sectionStyle = pw.TextStyle(
      font: semiBold,
      fontSize: 13,
      color: PdfColors.black,
    );

    final labelStyle = pw.TextStyle(font: semiBold, fontSize: 11);

    final valueStyle = pw.TextStyle(font: regular, fontSize: 10);




    if (profile.imageUrl != null &&
        profile.imageUrl!.isNotEmpty &&
        profile.imageUrl!.startsWith("http")) {
      try {
        profileImage = await PdfService.loadNetworkImage(profile.imageUrl!);
      } catch (_) {
        profileImage = dummyImage;
      }
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        /// LOGO
        pw.Center(child: pw.Image(logo, width: 145)),

        pw.SizedBox(height: 15),

        /// PROFILE HEADER
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            /// IMAGE
            pw.Image(image, width: 90, height: 90, fit: pw.BoxFit.cover),
            pw.SizedBox(width: 16),

            /// DETAILS
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(profile.name, style: titleStyle),

                  pw.SizedBox(height: 4),

                  pw.Row(
                    children: [
                      pw.Text("Tutor ID : ", style: labelStyle),

                      pw.Text(profile.tutorId, style: valueStyle),

                      pw.SizedBox(width: 12),

                      pw.Text("Rating : ", style: labelStyle),

                      pw.Text(profile.rating.toString(), style: valueStyle),
                    ],
                  ),

                  pw.SizedBox(height: 4),

                  pw.Text("Phone : ${profile.phoneNumber}", style: valueStyle),

                  pw.SizedBox(height: 4),

                  pw.Text("Email : ${profile.email}", style: valueStyle),

                  pw.SizedBox(height: 8),

                  pw.Text(
                    profile.personalInfo.overview?.isNotEmpty == true
                        ? profile.personalInfo.overview!
                        : "No overview available.",
                    style: valueStyle,
                  ),
                ],
              ),
            ),
          ],
        ),

        pw.SizedBox(height: 18),

        /// ================= EDUCATION =================
        pw.Text("Education", style: sectionStyle),

        pw.Divider(),

        pw.Wrap(
          spacing: 10,
          runSpacing: 10,
          children: profile.education.map((edu) {
            return pw.Container(
              width: 240,
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                // border: pw.Border.all(color: PdfColors.grey400),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(edu.degree ?? "Education", style: labelStyle),

                  pw.SizedBox(height: 6),

                  _row(
                    "Institute",
                    edu.institute ?? "-",
                    labelStyle,
                    valueStyle,
                  ),

                  _row(
                    "Department",
                    edu.department ?? edu.group ?? "-",
                    labelStyle,
                    valueStyle,
                  ),
                  if (edu.level != "Secondary" &&
                      edu.level != "Higher Secondary")
                    _row(
                      "Semester",
                      edu.semester ?? "-",
                      labelStyle,
                      valueStyle,
                    ),

                  _row(
                    "Curriculum",
                    edu.curriculum ?? "-",
                    labelStyle,
                    valueStyle,
                  ),

                  _row("Result", edu.result ?? "-", labelStyle, valueStyle),

                  _row(
                    "Passing Year",
                    edu.passingYear?.toString() ?? "-",
                    labelStyle,
                    valueStyle,
                  ),
                ],
              ),
            );
          }).toList(),
        ),

        pw.SizedBox(height: 18),

        /// ================= TUITION PREFERENCE =================
        pw.Text("Tuition Related Information", style: sectionStyle),

        pw.Divider(),

        _row(
          "Preferred Location",
          profile.tuitionPreference.preferredLocations.join(", "),
          labelStyle,
          valueStyle,
        ),

        _row(
          "Preferred Cities",
          profile.tuitionPreference.preferredCities.join(", "),
          labelStyle,
          valueStyle,
        ),

        _row(
          "Preferred Categories",
          profile.tuitionPreference.preferredCategories.join(", "),
          labelStyle,
          valueStyle,
        ),

        _row(
          "Preferred Classes",
          profile.tuitionPreference.preferredClasses.join(", "),
          labelStyle,
          valueStyle,
        ),

        _row(
          "Preferred Subjects",
          profile.tuitionPreference.preferredSubjects.join(", "),
          labelStyle,
          valueStyle,
        ),

        _row(
          "Tutoring Method",
          profile.tuitionPreference.tutoringMethod ?? "-",
          labelStyle,
          valueStyle,
        ),

        _row(
          "Tuition Style",
          profile.tuitionPreference.tuitionStyle.join(", "),
          labelStyle,
          valueStyle,
        ),

        _row(
          "Place of Tuition",
          profile.tuitionPreference.tutoringPlaces,
          labelStyle,
          valueStyle,
        ),

        _row(
          "Expected Salary",
          "${profile.tuitionPreference.expectedSalary} BDT",
          labelStyle,
          valueStyle,
        ),

        pw.SizedBox(height: 18),

        /// ================= PERSONAL INFORMATION =================
        pw.Text("Personal Information", style: sectionStyle),

        pw.Divider(),
        if (profile.gender != null && profile.gender!.isNotEmpty)
          _row("Gender", profile.gender!, labelStyle, valueStyle),

        if (profile.personalInfo.religion != null &&
            profile.personalInfo.religion!.isNotEmpty)
          _row(
            "Religion",
            profile.personalInfo.religion!,
            labelStyle,
            valueStyle,
          ),

        // if (profile.personalInfo.nationality != null &&
        //     profile.personalInfo.nationality!.isNotEmpty)
        //   _row(
        //     "Nationality",
        //     profile.personalInfo.nationality!,
        //     labelStyle,
        //     valueStyle,
        //   ),
        if (profile.personalInfo.dateOfBirth != null)
          _row(
            "Date of Birth",
            profile.personalInfo.dateOfBirth!,
            labelStyle,
            valueStyle,
          ),

        if (profile.personalInfo.fatherName != null &&
            profile.personalInfo.fatherName!.isNotEmpty)
          _row(
            "Father's Name",
            profile.personalInfo.fatherName!,
            labelStyle,
            valueStyle,
          ),

        if (profile.personalInfo.fatherPhoneNumber != null &&
            profile.personalInfo.fatherPhoneNumber!.isNotEmpty)
          _row(
            "Father's Phone",
            profile.personalInfo.fatherPhoneNumber!,
            labelStyle,
            valueStyle,
          ),

        if (profile.personalInfo.motherName != null &&
            profile.personalInfo.motherName!.isNotEmpty)
          _row(
            "Mother's Name",
            profile.personalInfo.motherName!,
            labelStyle,
            valueStyle,
          ),

        if (profile.personalInfo.motherPhoneNumber != null &&
            profile.personalInfo.motherPhoneNumber!.isNotEmpty)
          _row(
            "Mother's Phone",
            profile.personalInfo.motherPhoneNumber!,
            labelStyle,
            valueStyle,
          ),

        if (profile.personalInfo.additionalPhone != null &&
            profile.personalInfo.additionalPhone!.isNotEmpty)
          _row(
            "Additional Phone",
            profile.personalInfo.additionalPhone!,
            labelStyle,
            valueStyle,
          ),

        if (profile.personalInfo.emergencyContactNumber != null &&
            profile.personalInfo.emergencyContactNumber!.isNotEmpty)
          _row(
            "Emergency Contact",
            profile.personalInfo.emergencyContactNumber!,
            labelStyle,
            valueStyle,
          ),

        if (profile.personalInfo.address != null &&
            profile.personalInfo.address!.isNotEmpty)
          _row(
            "Address",
            profile.personalInfo.address!,
            labelStyle,
            valueStyle,
          ),

        pw.SizedBox(height: 20),

        pw.Center(
          child: pw.Text(
            "Thanks for staying with Bright Tuition Care",
            style: valueStyle.copyWith(font: semiBold, fontSize: 11),
          ),
        ),
      ],
    );
  }

  static pw.Widget _row(
  String title,
  String? value,
  pw.TextStyle label,
  pw.TextStyle valueStyle,
) {
  if (value == null || value.trim().isEmpty) {
    return pw.SizedBox();
  }

  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 4),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 120,
          child: pw.Text("$title :", style: label),
        ),
        pw.Expanded(
          child: pw.Text(value, style: valueStyle),
        ),
      ],
    ),
  );
}
}
