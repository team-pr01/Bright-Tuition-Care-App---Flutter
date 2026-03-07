import 'package:btcclient/core/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import '../../../core/config/theme.dart';

class ProfileSection extends StatelessWidget {
  final String name;
  final String role;
  final String roleBasedId;
  final String createdAt;
  final bool isVerified;
  final String? profilePicture;
  final String? extraLine1;
  final String? extraLine2;

  const ProfileSection({
    super.key,
    required this.name,
    required this.role,
    required this.roleBasedId,
    required this.createdAt,
    required this.isVerified,
    this.profilePicture,
    this.extraLine1,
    this.extraLine2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          /// PROFILE IMAGE + VERIFIED BADGE
          Stack(
            clipBehavior: Clip.none,
            children: [
              /// PROFILE AVATAR WITH BORDER
              Container(
                padding: const EdgeInsets.all(1),
                decoration: const BoxDecoration(
                  color: AppColors.neutrals04,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: const BoxDecoration(
                    color: AppColors.primary01,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),

                    /// AVATAR
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white,

                      /// IMAGE IF EXISTS
                      backgroundImage:
                          (profilePicture != null && profilePicture!.isNotEmpty)
                          ? NetworkImage(profilePicture!)
                          : null,

                      /// FALLBACK ICON
                      child: (profilePicture == null || profilePicture!.isEmpty)
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: AppColors.primary01,
                            )
                          : null,
                    ),
                  ),
                ),
              ),

              /// VERIFIED BADGE
              if (isVerified)
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified,
                      size: 24,
                      color: AppColors.success,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          /// NAME
          Text(
            name,
            style: const TextStyle(
              color: AppColors.neutrals01,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          /// EMAIL
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                role == "tutor"
                    ? "Tutor ID: $roleBasedId"
                    : "Guardian ID: $roleBasedId",
                style: const TextStyle(
                  color: AppColors.neutrals01,
                  fontSize: 13,
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 1,
                height: 14,
                color: AppColors.neutrals01,
              ),

              Text(
                "Since ${DateFormatter.formatSince(createdAt)}",
                style: const TextStyle(
                  color: AppColors.neutrals01,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
