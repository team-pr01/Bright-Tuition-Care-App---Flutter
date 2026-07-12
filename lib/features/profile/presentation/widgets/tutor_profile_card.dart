import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TutorProfileCard extends StatelessWidget {
  final String name;
  final String tutorId;
  final String email;
  final String phone;
  final String address;
  final String profileImage;
  final double rating;
  final bool isVerified;
  final int profileCompleted;

  const TutorProfileCard({
    super.key,
    required this.name,
    required this.tutorId,
    required this.email,
    required this.phone,
    required this.address,
    required this.profileImage,
    required this.isVerified,
    required this.profileCompleted,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(AppSpacing.lg),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(AppRadius.large),

        border: Border.all(color: AppColors.neutrals04),
      ),

      child: Column(
        children: [
          /// ================= HEADER =================
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              /// PROFILE IMAGE
              Stack(
                clipBehavior: Clip.none,

                children: [
                  Container(
                    width: 92,
                    height: 92,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      border: Border.all(
                        color: AppColors.primary01.withOpacity(0.15),
                        width: 2,
                      ),

                      image: DecorationImage(
                        image: NetworkImage(profileImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Positioned(
                    right: 2,
                    bottom: 2,

                    child: Container(
                      padding: const EdgeInsets.all(6),

                      decoration: BoxDecoration(
                        color: AppColors.primary01,
                        shape: BoxShape.circle,

                        border: Border.all(color: Colors.white, width: 2),
                      ),

                      child: const Icon(
                        Icons.edit,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              /// RIGHT SIDE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// NAME
                    Row(
                      children: [
                        Text(
                          name,

                          maxLines: 2,

                          overflow: TextOverflow.ellipsis,

                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(width: 6),

                        if (isVerified == true)
                          const Icon(
                            Icons.verified,
                            size: 20,
                            color: AppColors.primary01,
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    /// TUTOR ID
                    Text(
                      "Tutor ID : $tutorId",

                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutrals03,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// RATING
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => const Padding(
                            padding: EdgeInsets.only(right: 1),

                            child: Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.amber,
                            ),
                          ),
                        ),

                        const SizedBox(width: 6),

                        Text(
                          "$rating",

                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary01,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          /// ================= PROGRESS CARD =================
          Container(
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.06),

              borderRadius: BorderRadius.circular(AppRadius.medium),

              border: Border.all(color: Colors.green.withOpacity(0.15)),
            ),

            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,

                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),

                  child: const Center(
                    child: Text("👏", style: TextStyle(fontSize: 20)),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Profile Completion",

                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 8),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),

                        child: LinearProgressIndicator(
                          value: profileCompleted / 100,

                          minHeight: 10,

                          backgroundColor: AppColors.neutrals04,

                          valueColor: const AlwaysStoppedAnimation(
                            Colors.green,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "$profileCompleted% Complete",

                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.neutrals03,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// ================= INFO SECTION =================
          _infoTile(icon: Icons.email_outlined, title: "Email", value: email),

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

          const SizedBox(height: 26),

          /// ================= BUTTONS =================
          AppButton(
            label: "Download CV",
            variant: AppButtonVariant.gradient,
            height: 50,
            fontWeight: FontWeight.w600,
            icon: Icons.download_rounded,
            onPressed: () {},
          ),

          const SizedBox(height: 10),

          AppButton(
            label: "View as Guardian or Student",
            variant: AppButtonVariant.outlineGray,
            height: 50,
            fontWeight: FontWeight.w600,
            icon: Icons.remove_red_eye_outlined,
            onPressed: () {},
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
        Icon(icon, color: AppColors.primary01, size: 24),

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
                value,

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
