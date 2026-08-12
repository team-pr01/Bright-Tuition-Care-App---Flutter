import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/profile/presentation/screens/tutor_profile_view_screen.dart';
import 'package:btcclient/features/profile/presentation/widgets/profile_ring_painter.dart';
import 'package:btcclient/features/profile/presentation/widgets/progress_dot_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TutorProfileCard extends StatelessWidget {
  final String name;
  final TutorProfileModel profile;
  final String tutorId;
  final String email;
  final String phone;
  final String address;
  final String profileImage;
  final double rating;
  final bool isVerified;
  final int profileCompleted;

  final bool isDownloading;

  final VoidCallback? onDownload;
  final VoidCallback? onEditImage;

  const TutorProfileCard({
    super.key,
    required this.profile,
    required this.name,
    required this.tutorId,
    required this.email,
    required this.phone,
    required this.address,
    required this.profileImage,
    required this.isVerified,
    required this.profileCompleted,
    required this.rating,
    this.isDownloading = false,
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

      child: Column(
        children: [
          const SizedBox(height: 40),

          // Avatar
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // ============================================================
              // PROFILE PROGRESS RING
              // ============================================================
              CustomPaint(
                size: const Size(110, 110),
                painter: ProfileRingPainter(
                  progress: (profileCompleted / 100).clamp(0.0, 1.0),
                ),
              ),

              // ============================================================
              // PROFILE IMAGE
              // ============================================================
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(backgroundImage: provider),
              ),

              // ============================================================
              // PROGRESS DOTS
              //
              // IMPORTANT:
              // This MUST come BEFORE the camera button.
              // Otherwise it can sit above the camera button in the
              // Stack hit-test order.
              // ============================================================
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: ProgressDotPainter(
                      progress: (profileCompleted / 100).clamp(0.0, 1.0),
                    ),
                  ),
                ),
              ),

              // ============================================================
              // CAMERA BUTTON
              //
              // IMPORTANT:
              // Keep this AFTER the full-size painter.
              // ============================================================
              Positioned(
                right: 2,
                bottom: 0,
                child: Material(
                  color: Colors.white,
                  elevation: 3,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      debugPrint('📸 CAMERA BUTTON TAPPED');

                      if (onEditImage == null) {
                        debugPrint('❌ onEditImage is NULL');
                        return;
                      }

                      debugPrint('✅ Calling onEditImage');
                      onEditImage!();
                    },
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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(width: 4),

              if (isVerified)
                const Icon(Icons.verified, color: Colors.white, size: 20),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                5,
                (index) => Icon(
                  rating > index ? Icons.star : Icons.star_border,
                  size: 14,
                  color: const Color(0xffFFC928),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "(${rating.toStringAsFixed(1)})",
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
              ),
            ],
          ),

          const SizedBox(height: 4),

          const SizedBox(height: 4),

          Text(
            "Tutor Id: $tutorId | Since 11 Aug, 2025",
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: "Download CV",
                  variant: AppButtonVariant.outlineGray,
                  icon: Icons.download,
                  iconPosition: AppButtonIconPosition.right,
                  height: 38,
                  fontSize: 12,
                  onPressed: onDownload,
                  loading: isDownloading,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: AppButton(
                  label: "View as Guardian",
                  variant: AppButtonVariant.outline,
                  height: 38,
                  fontSize: 12,
                  icon: Icons.remove_red_eye_outlined,
                  iconPosition: AppButtonIconPosition.right,

                  textColor: Colors.white,
                  borderColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  borderRadius: 6,

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TutorResumeScreen(profile: profile),
                      ),
                    );
                  },
                ),
              ),
            ],
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
