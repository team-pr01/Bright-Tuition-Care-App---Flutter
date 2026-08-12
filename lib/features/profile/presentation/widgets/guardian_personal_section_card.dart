import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/features/auth/data/models/guardian_model.dart';
import 'package:flutter/material.dart';
import 'package:btcclient/features/profile/presentation/widgets/shared/profile_info_row.dart';

class GuardianPersonalSectionCard extends StatelessWidget {
  final GuardianProfileModel profile;
  final VoidCallback? onEdit;

  const GuardianPersonalSectionCard({
    super.key,
    required this.profile,
    this.onEdit,
  });

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
                  "Personal Information",
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

          const SizedBox(height: 10),
          const Divider(),

          ProfileInfoRow(label: "Email", value: profile.email),

          ProfileInfoRow(
            label: "Gender",
            value: profile.gender.isEmpty
                ? null
                : "${profile.gender[0].toUpperCase()}${profile.gender.substring(1)}",
          ),

          ProfileInfoRow(label: "Phone Number", value: profile.phoneNumber),

          ProfileInfoRow(
            label: "Additional Number",
            value: profile.additionalPhone,
          ),

          ProfileInfoRow(label: "City", value: profile.city),

          ProfileInfoRow(label: "Area", value: profile.area),

          ProfileInfoRow(label: "Present Address", value: profile.address),

          ProfileInfoRow(label: "Date Of Birth", value: profile.dateOfBirth),

          ProfileInfoRow(label: "Nationality", value: profile.nationality),

          ProfileInfoRow(label: "Facebook", value: profile.facebook),

          const Divider(height: 32),

          const Text(
            "Emergency Contact",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          ProfileInfoRow(label: "Contact Person", value: profile.emergencyName),

          ProfileInfoRow(label: "Phone Number", value: profile.emergencyPhone),

          ProfileInfoRow(label: "Relation", value: profile.emergencyRelation),

          ProfileInfoRow(label: "Address", value: profile.emergencyAddress),
        ],
      ),
    );
  }
}
