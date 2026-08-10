import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/features/profile/presentation/widgets/shared/profile_info_row.dart';
import 'package:flutter/material.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';

class PersonalSectionCard extends StatelessWidget {
  final TutorProfileModel profile;
  final VoidCallback? onEdit;

  const PersonalSectionCard({super.key, required this.profile, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Overview",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              if (onEdit != null)
                AppButton(
                  iconOnly: true,
                  icon: Icons.edit_outlined,
                  variant: AppButtonVariant.outlineGray,
                  width: 32,
                  height: 32,
                  onPressed: onEdit,
                ),
            ],
          ),

          const SizedBox(height: 2),

          if ((profile.personalInfo.overview ?? "").trim().isNotEmpty) ...[
            Text(
              profile.personalInfo.overview!,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),
          ],
          Divider(),

          ProfileInfoRow(label: "Email", value: profile.email),

          ProfileInfoRow(label: "Phone Number", value: profile.phoneNumber),

          ProfileInfoRow(
            label: "Additional Number",
            value: profile.personalInfo.additionalPhone,
          ),

          ProfileInfoRow(label: "Area", value: profile.area),

          ProfileInfoRow(label: "City", value: profile.city),

          ProfileInfoRow(
            label: "Present Address",
            value: profile.personalInfo.address,
          ),

          ProfileInfoRow(
            label: "Religion",
            value: profile.personalInfo.religion,
          ),

          ProfileInfoRow(
            label: "Facebook",
            value: profile.socialMedia.facebook,
          ),

          ProfileInfoRow(
            label: "Gender",
            value: profile.gender.isEmpty
                ? null
                : "${profile.gender[0].toUpperCase()}${profile.gender.substring(1)}",
          ),

          ProfileInfoRow(
            label: "Date Of Birth",
            value: profile.personalInfo.dateOfBirth,
          ),

          const Divider(height: 32),

          const Text(
            "Emergency Contact",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          ProfileInfoRow(
            label: "Contact Person",
            value: profile.emergencyInfo.name,
          ),

          ProfileInfoRow(
            label: "Phone Number",
            value: profile.emergencyInfo.phone,
          ),
          ProfileInfoRow(
            label: "Father's Name",
            value: profile.personalInfo.fatherName,
          ),

          ProfileInfoRow(
            label: "Father's Phone Number",
            value: profile.personalInfo.fatherPhoneNumber,
          ),

          ProfileInfoRow(
            label: "Mother's Name",
            value: profile.personalInfo.motherName,
          ),

          ProfileInfoRow(
            label: "Mother's Phone Number",
            value: profile.personalInfo.motherPhoneNumber,
          ),
        ],
      ),
    );
  }
}
