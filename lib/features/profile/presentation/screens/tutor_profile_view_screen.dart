import 'package:flutter/material.dart';

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';

import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/profile/presentation/widgets/shared/credential_document_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/shared/full_screen_image_viewer.dart';

class TutorResumeScreen extends StatelessWidget {
  final TutorProfileModel profile;

  /// Hide sensitive information when required.
  final bool hideContactDetails;

  /// Optional CV download callback.
  final VoidCallback? onDownloadResume;

  const TutorResumeScreen({
    super.key,
    required this.profile,
    this.hideContactDetails = false,
    this.onDownloadResume,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutrals01,

      appBar: AppBar(
        backgroundColor: AppColors.primary01,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Tutor Profile",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 20),

              _buildEducationSection(),

              const SizedBox(height: 20),

              _buildTuitionSection(),

              const SizedBox(height: 20),

              _buildPersonalSection(),

              if (!hideContactDetails) ...[
                const SizedBox(height: 20),
                _buildCredentialSection(context),
              ],

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // HEADER
  // ================================================================

  Widget _buildHeader() {
    ImageProvider imageProvider;

    if (profile.imageUrl != null &&
        profile.imageUrl!.trim().isNotEmpty &&
        profile.imageUrl!.startsWith("http")) {
      imageProvider = NetworkImage(profile.imageUrl!);
    } else {
      imageProvider = const AssetImage(
        "assets/images/dummy-avatar.jpg",
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.neutrals04,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------------------------------------------------
          // IMAGE
          // ----------------------------------------------------------

          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image(
                    image: imageProvider,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),

                if (profile.isVerified)
                  Positioned(
                    right: -8,
                    bottom: -8,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.primary01,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ----------------------------------------------------------
          // NAME
          // ----------------------------------------------------------

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    profile.name.isEmpty
                        ? "Tutor"
                        : profile.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                if (profile.isVerified) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.verified,
                    color: AppColors.primary01,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ----------------------------------------------------------
          // TUTOR ID + RATING
          // ----------------------------------------------------------

          Center(
            child: Text(
              "Tutor Id: ${profile.tutorId}  |  "
              "Rating: ${profile.rating.toStringAsFixed(1)}/5",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.neutrals02,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ----------------------------------------------------------
          // PHONE
          // ----------------------------------------------------------

          if (!hideContactDetails)
            _InfoRow(
              label: "Phone Number",
              value: profile.phoneNumber,
            ),

          // ----------------------------------------------------------
          // ADDRESS
          // ----------------------------------------------------------

          _InfoRow(
            label: "Address",
            value: _address,
          ),

          // ----------------------------------------------------------
          // FACEBOOK
          // ----------------------------------------------------------

          if (!hideContactDetails &&
              (profile.socialMedia.facebook ?? "")
                  .trim()
                  .isNotEmpty)
            _InfoRow(
              label: "Facebook",
              value: profile.socialMedia.facebook!,
            ),

          // ----------------------------------------------------------
          // OVERVIEW
          // ----------------------------------------------------------

          if ((profile.personalInfo.overview ?? "")
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 16),

            Divider(
              color: AppColors.neutrals04,
            ),

            const SizedBox(height: 14),

            const Text(
              "Overview",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              profile.personalInfo.overview!.trim(),
              style: TextStyle(
                color: AppColors.neutrals02,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],

          // ----------------------------------------------------------
          // DOWNLOAD CV
          // ----------------------------------------------------------

          if (onDownloadResume != null) ...[
            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: "Download CV",
                icon: Icons.download_outlined,
                iconPosition: AppButtonIconPosition.right,
                variant: AppButtonVariant.outlineGray,
                height: 42,
                fontSize: 13,
                textColor: AppColors.primary01,
                borderRadius: 8,
                onPressed: onDownloadResume,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ================================================================
  // EDUCATION
  // ================================================================

  Widget _buildEducationSection() {
    final List<Education> educationList = profile.education;

    return _ResumeSection(
      title: "Education",
      child: educationList.isEmpty
          ? _noData()
          : Column(
              children: educationList
                  .map(
                    (education) =>
                        _buildEducationItem(education),
                  )
                  .toList(),
            ),
    );
  }

  Widget _buildEducationItem(
    Education education,
  ) {
    final bool isSchoolLevel =
        education.level == "Secondary" ||
        education.level == "Higher Secondary" ||
        education.level == "O Level" ||
        education.level == "A Level";

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ${education.degree.isNotEmpty ? education.degree : "Education"}",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          _ResumeGrid(
            items: [
              _ResumeItem(
                "Institute Name",
                education.institute,
              ),

              _ResumeItem(
                "Degree",
                education.degree,
              ),

              if (isSchoolLevel)
                _ResumeItem(
                  "Group",
                  education.group ?? "",
                )
              else
                _ResumeItem(
                  "Department",
                  education.department ?? "",
                ),

              if (!isSchoolLevel)
                _ResumeItem(
                  "Semester",
                  education.semester ?? "",
                ),

              _ResumeItem(
                "Curriculum",
                education.curriculum ?? "",
              ),

              _ResumeItem(
                "Result",
                education.result ?? "",
              ),

              if (education.isCurrentInstitute != true)
                _ResumeItem(
                  "Year of Passing",
                  education.passingYear ?? "",
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ================================================================
  // TUITION INFORMATION
  // ================================================================

  Widget _buildTuitionSection() {
    final tuition = profile.tuitionPreference;

    return _ResumeSection(
      title: "Tuition Related Information",
      child: _ResumeGrid(
        items: [
          _ResumeItem(
            "Preferred Cities",
            tuition.cities,
          ),

          _ResumeItem(
            "Preferred Location",
            tuition.locations,
          ),

          _ResumeItem(
            "Preferred Categories",
            tuition.categories,
          ),

          _ResumeItem(
            "Preferred Classes",
            tuition.classes,
          ),

          _ResumeItem(
            "Preferred Subjects",
            tuition.subjects,
          ),

          _ResumeItem(
            "Tutoring Method",
            tuition.tutoringMethod ?? "",
          ),

          _ResumeItem(
            "Tuition Style",
            tuition.teachingStyle,
          ),

          _ResumeItem(
            "Place of Tutoring",
            tuition.tutoringPlaces,
          ),

          // IMPORTANT:
          // experience is an OBJECT.
          _ResumeItem(
            "Total Experience",
            profile.totalExperience,
          ),

          _ResumeItem(
            "Expected Salary",
            tuition.expectedSalary.trim().isEmpty
                ? ""
                : "${tuition.expectedSalary} BDT",
          ),
        ],
      ),
    );
  }

  // ================================================================
  // PERSONAL INFORMATION
  // ================================================================

  Widget _buildPersonalSection() {
    final personal = profile.personalInfo;

    return _ResumeSection(
      title: "Personal Information",
      child: _ResumeGrid(
        items: [
          _ResumeItem(
            "Gender",
            profile.gender,
          ),

          _ResumeItem(
            "Religion",
            personal.religion ?? "",
          ),

          _ResumeItem(
            "Date of Birth",
            personal.dateOfBirth ?? "",
          ),

          _ResumeItem(
            "Father's Name",
            personal.fatherName ?? "",
          ),

          if (!hideContactDetails)
            _ResumeItem(
              "Father's Phone",
              personal.fatherPhoneNumber ?? "",
            ),

          _ResumeItem(
            "Mother's Name",
            personal.motherName ?? "",
          ),

          if (!hideContactDetails)
            _ResumeItem(
              "Mother's Phone",
              personal.motherPhoneNumber ?? "",
            ),

          if (!hideContactDetails)
            _ResumeItem(
              "Additional Phone",
              personal.additionalPhone ?? "",
            ),

          if (!hideContactDetails)
            _ResumeItem(
              "Emergency Contact",
              personal.emergencyContactNumber ?? "",
            ),

          _ResumeItem(
            "Address",
            personal.address ?? "",
          ),
        ],
      ),
    );
  }

  // ================================================================
  // CREDENTIALS
  // ================================================================

  Widget _buildCredentialSection(
    BuildContext context,
  ) {
    final List<Identity> identities = profile.identity;

    return _ResumeSection(
      title: "Credentials Information",
      child: identities.isEmpty
          ? _noData()
          : Column(
              children: identities.map<Widget>(
                (Identity identity) {
                  return CredentialDocumentCard(
                    title: identity.fileType.isEmpty
                        ? "Credential"
                        : identity.fileType,

                    fileUrl: identity.file,

                    // VIEW ONLY
                    onView: () {
                      if (identity.file.trim().isEmpty) {
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              FullScreenImageViewer(
                            imageUrl: identity.file,
                            title: identity.fileType,
                          ),
                        ),
                      );
                    },

                  );
                },
              ).toList(),
            ),
    );
  }

  // ================================================================
  // ADDRESS
  // ================================================================

  String get _address {
    final address =
        profile.personalInfo.address?.trim() ?? "";

    if (address.isNotEmpty) {
      return address;
    }

    final List<String> parts = [];

    if (profile.area.trim().isNotEmpty) {
      parts.add(profile.area.trim());
    }

    if (profile.city.trim().isNotEmpty) {
      parts.add(profile.city.trim());
    }

    return parts.join(", ");
  }

  // ================================================================
  // NO DATA
  // ================================================================

  Widget _noData() {
    return const Text(
      "No Data Found",
      style: TextStyle(
        color: Colors.red,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

// ======================================================================
// SECTION CARD
// ======================================================================

class _ResumeSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _ResumeSection({
    required this.title,
    required this.child,
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
          color: AppColors.neutrals04,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Divider(
            height: 1,
            color: AppColors.neutrals04,
          ),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }
}

// ======================================================================
// GRID
// ======================================================================

class _ResumeGrid extends StatelessWidget {
  final List<_ResumeItem> items;

  const _ResumeGrid({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final validItems = items
        .where(
          (item) => item.value.trim().isNotEmpty,
        )
        .toList();

    if (validItems.isEmpty) {
      return const Text(
        "No Data Found",
        style: TextStyle(
          color: Colors.red,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Column(
      children: validItems.map(
        (item) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 145,
                  child: Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                const Text(
                  ":",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    item.value,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: AppColors.neutrals02,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}

// ======================================================================
// ITEM
// ======================================================================

class _ResumeItem {
  final String label;
  final String value;

  const _ResumeItem(
    this.label,
    this.value,
  );
}

// ======================================================================
// SIMPLE INFO ROW
// ======================================================================

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 10),

          const Text(
            ":",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.neutrals02,
              ),
            ),
          ),
        ],
      ),
    );
  }
}