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
  final VoidCallback? onDownload;
  final VoidCallback? onEditImage;

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
    this.onDownload,
    this.onEditImage,
  });
  Color _getProfileCompletionColor() {
    if (profileCompleted <= 20) {
      return AppColors.error;
    } else if (profileCompleted <= 40) {
      return Colors.orange;
    } else if (profileCompleted <= 60) {
      return Colors.amber;
    } else if (profileCompleted <= 80) {
      return AppColors.success;
    } else {
      return AppColors.success;
    }
  }

  Color _progressCardColor() {
    if (profileCompleted < 30) return Colors.orange.shade50;
    if (profileCompleted < 70) return Colors.blue.shade50;
    if (profileCompleted < 100) return Colors.green.shade50;
    return Colors.green.shade100;
  }

  Color _progressBorderColor() {
    if (profileCompleted < 30) return Colors.orange.shade200;
    if (profileCompleted < 70) return Colors.blue.shade200;
    if (profileCompleted < 100) return Colors.green.shade200;
    return Colors.green.shade400;
  }

  Color _progressIconBackground() {
    if (profileCompleted < 30) return Colors.orange.shade100;
    if (profileCompleted < 70) return Colors.blue.shade100;
    if (profileCompleted < 100) return Colors.green.shade100;
    return Colors.green.shade200;
  }

  IconData _progressIcon() {
    if (profileCompleted < 30) return Icons.flag_outlined;
    if (profileCompleted < 70) return Icons.trending_up;
    if (profileCompleted < 100) return Icons.verified_user_outlined;
    return Icons.workspace_premium;
  }

  String _progressTitle() {
    if (profileCompleted < 30) {
      return "Get Started";
    }

    if (profileCompleted < 70) {
      return "$profileCompleted% Completed";
    }

    if (profileCompleted < 100) {
      return "Almost There";
    }

    return "Profile Complete 🎉";
  }

  String _progressSubtitle() {
    if (profileCompleted < 30) {
      return "Complete your profile to receive tuition requests faster.";
    }

    if (profileCompleted < 70) {
      return "Keep going! A complete profile builds more trust.";
    }

    if (profileCompleted < 100) {
      return "You're close! Complete the remaining details.";
    }

    return "Excellent! Your profile is ready for students.";
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider provider;

    if (profileImage.isNotEmpty && profileImage.startsWith('http')) {
      provider = NetworkImage(profileImage);
    } else {
      provider = const AssetImage('assets/images/dummy-avatar.jpg');
    }
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
                        image: provider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: GestureDetector(
                      onTap: onEditImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary01,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 15,
                          color: Colors.white,
                        ),
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
                        ...List.generate(5, (index) {
                          IconData icon;

                          if (rating >= index + 1) {
                            icon = Icons.star_rounded;
                          } else if (rating >= index + 0.5) {
                            icon = Icons.star_half_rounded;
                          } else {
                            icon = Icons.star_border_rounded;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: Icon(icon, size: 18, color: Colors.amber),
                          );
                        }),
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
              color: _progressCardColor(),
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(color: _progressBorderColor()),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _progressIconBackground(),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _progressIcon(),
                    color: _getProfileCompletionColor(),
                    size: 24,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _progressTitle(),
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        _progressSubtitle(),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.neutrals02,
                        ),
                      ),

                      const SizedBox(height: 12),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: LinearProgressIndicator(
                          value: profileCompleted.clamp(0, 100) / 100,
                          minHeight: 10,
                          backgroundColor: AppColors.neutrals04,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getProfileCompletionColor(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "$profileCompleted% Complete",
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _getProfileCompletionColor(),
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
            onPressed: onDownload,
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
