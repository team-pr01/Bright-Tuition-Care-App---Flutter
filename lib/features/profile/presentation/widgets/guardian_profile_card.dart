import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GuardianProfileCard extends StatelessWidget {
  final String name;
  final String guardianId;
  final String email;
  final String phone;
  final String address;
  final String profileImage;
  final double rating;
  final bool isVerified;
  final VoidCallback? onEditImage;

  const GuardianProfileCard({
    super.key,
    required this.name,
    required this.guardianId,
    required this.email,
    required this.phone,
    required this.address,
    required this.profileImage,
    required this.isVerified,
    required this.rating,
    this.onEditImage,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider provider;

    if (profileImage.isNotEmpty &&
        profileImage.startsWith('http')) {
      provider = NetworkImage(profileImage);
    } else {
      provider = const AssetImage(
        'assets/images/dummy-avatar.jpg',
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: AppColors.neutrals04,
        ),
      ),
      child: Column(
        children: [


          _infoTile(
            icon: Icons.email_outlined,
            title: "Email",
            value: email,
          ),

          const SizedBox(height: 18),

          _infoTile(
            icon: Icons.phone_outlined,
            title: "Phone Number",
            value: phone,
          ),

          const SizedBox(height: 18),

          _infoTile(
            icon: Icons.location_on_outlined,
            title: "Present Address",
            value: address,
          ),
          
        ],
    ),
  
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.primary01,
          size: 24,
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                value.isEmpty ? "-" : value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutrals02,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}