import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:flutter/material.dart';

class GuardianProfileCard extends StatelessWidget {
  final String name;
  final String guardianId;
  final String email;
  final String phone;
  final String address;
  final String profileImage;
  final double rating;
  final bool isVerified;

  final bool isDownloading;

  final VoidCallback? onDownload;
  final VoidCallback? onViewAsTutor;
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
    this.isDownloading = false,
    this.onDownload,
    this.onViewAsTutor,
    this.onEditImage,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider provider;

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
      child: Column(
        children: [
          const SizedBox(height: 40),

          // ============================================================
          // PROFILE IMAGE
          // ============================================================

          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage: provider,
                ),
              ),

              // ========================================================
              // CAMERA BUTTON
              // ========================================================

              if (onEditImage != null)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Material(
                    color: Colors.white,
                    elevation: 3,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onEditImage,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary01,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: AppColors.primary01,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          // ============================================================
          // NAME + VERIFIED
          // ============================================================

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  name.isEmpty ? "Guardian" : name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(width: 4),

              if (isVerified)
                const Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 20,
                ),
            ],
          ),

          const SizedBox(height: 4),

          // ============================================================
          // RATING
          // ============================================================

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                5,
                (index) => Icon(
                  rating > index
                      ? Icons.star
                      : Icons.star_border,
                  size: 14,
                  color: const Color(0xffFFC928),
                ),
              ),

              const SizedBox(width: 4),

              Text(
                "(${rating.toStringAsFixed(1)})",
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ============================================================
          // GUARDIAN ID
          // ============================================================

          Text(
            "Guardian Id: $guardianId",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 22),

          // ============================================================
          // ACTION BUTTONS
          // ============================================================

           ],
      ),
    );
  }

  // ================================================================
  // INFORMATION TILE
  // ================================================================

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