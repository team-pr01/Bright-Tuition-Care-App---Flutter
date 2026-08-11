import 'package:flutter/material.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';

class GuardianTutorEducationSection extends StatelessWidget {
  final List<Education> educations;

  const GuardianTutorEducationSection({
    super.key,
    required this.educations,
  });

  bool _isSchoolLevel(Education education) {
    return education.level == "Secondary" ||
        education.level == "Higher Secondary" ||
        education.level == "O Level" ||
        education.level == "A Level";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// =========================================================
          /// HEADER
          /// =========================================================
          const Text(
            "Education",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey.shade300,
          ),

          const SizedBox(height: 4),

          /// =========================================================
          /// EMPTY STATE
          /// =========================================================
          if (educations.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                "No Data Found",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            )
          else

            /// =====================================================
            /// EDUCATION LIST
            /// =====================================================
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: educations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final education = educations[index];

                return _EducationItem(
                  education: education,
                  isSchoolLevel: _isSchoolLevel(education),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _EducationItem extends StatelessWidget {
  final Education education;
  final bool isSchoolLevel;

  const _EducationItem({
    required this.education,
    required this.isSchoolLevel,
  });

  String _value(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "N/A";
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// =========================================================
        /// DEGREE / EDUCATION TITLE
        /// =========================================================
        Text(
          "• ${_value(education.degree)}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 14),

        /// =========================================================
        /// INFORMATION
        /// =========================================================
        _EducationInfoRow(
          label: "Institute Name",
          value: _value(education.institute),
        ),

        _EducationInfoRow(
          label: "Degree",
          value: _value(education.degree),
        ),

        /// SCHOOL → GROUP
        /// COLLEGE/UNIVERSITY → DEPARTMENT
        _EducationInfoRow(
          label: isSchoolLevel ? "Group" : "Department",
          value: isSchoolLevel
              ? _value(education.group)
              : _value(education.department),
        ),

        /// SEMESTER ONLY FOR NON-SCHOOL LEVEL
        if (!isSchoolLevel)
          _EducationInfoRow(
            label: "Semester",
            value: _value(education.semester),
          ),

        _EducationInfoRow(
          label: "Curriculum",
          value: _value(education.curriculum),
        ),

        _EducationInfoRow(
          label: "Result",
          value: _value(education.result),
        ),

        _EducationInfoRow(
          label: "Year of Passing",
          value: _value(education.passingYear),
        ),
      ],
    );
  }
}

class _EducationInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _EducationInfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LABEL
          SizedBox(
            width: 145,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),

          /// :
          const SizedBox(
            width: 20,
            child: Text(
              ":",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),

          /// VALUE
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}