import 'package:btcclient/features/auth/data/models/guardian_model.dart';
import 'package:flutter/material.dart';
import 'package:btcclient/features/profile/presentation/widgets/shared/profile_info_row.dart';

class GuardianEmergencySectionCard extends StatelessWidget {
  final GuardianProfileModel profile;
  final VoidCallback? onEdit;

  const GuardianEmergencySectionCard({
    super.key,
    required this.profile,
    this.onEdit,
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
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Emergency Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (onEdit != null)
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(),

          ProfileInfoRow(
            label: "Emergency Contact Person",
            value: profile.emergencyName,
          ),

          ProfileInfoRow(
            label: "Phone Number",
            value: profile.emergencyPhone,
          ),

          ProfileInfoRow(
            label: "Relation",
            value: profile.emergencyRelation,
          ),

          ProfileInfoRow(
            label: "Address",
            value: profile.emergencyAddress,
          ),
        ],
      ),
    );
  }
}