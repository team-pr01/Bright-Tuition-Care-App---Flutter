import 'package:btcclient/core/models/testimonial_model.dart';
import 'package:btcclient/core/widgets/testimonial/testimonial_section.dart';
import 'package:btcclient/features/auth/presentation/login_screen.dart';
import 'package:btcclient/features/auth/presentation/register_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/config/theme.dart';
import '../../../core/widgets/button/app_button.dart';

final testimonials = [
  TestimonialModel(
    name: "Ahnof Rahat",
    role: "Tutor",
    message:
        "Bright Tuition Care is the best platform for finding new tutoring opportunities... I found the perfect tutor within 24 hours. Highly recommended!",
    image: "assets/images/user.jpg",
  ),
  TestimonialModel(
    name: "Sarah Khan",
    role: "Student",
    message:
        "I found the perfect tutor within 24 hours. Highly recommended I found the perfect tutor within 24 hours. Highly recommended!!",
    image: "assets/images/user2.jpg",
  ),
  TestimonialModel(
    name: "Sarah Beg",
    role: "Student",
    message:
        "I found the perfect tutor within 24 hours. Highly recommended I found the perfect tutor within 24 hours. Highly recommended!!",
    image: "assets/images/user2.jpg",
  ),
  TestimonialModel(
    name: "Sarah Niyazi",
    role: "Student",
    message: "I found the perfect tutor within 24 hours.",
    image: "assets/images/user2.jpg",
  ),
];

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary02,
      body: Stack(
        children: [
          /// BACKGROUND IMAGE
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "assets/images/bg-elements.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// MAIN CONTENT
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// CONTENT WITH SIDE PADDING
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),

                        /// LOGO
                        Image.asset(
                          'assets/images/logo.png',
                          width: 287,
                          height: 59,
                        ),

                        const SizedBox(height: 50),

                        /// MAIN CARD
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.neutrals01,
                            borderRadius: BorderRadius.circular(
                              AppRadius.large,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Find Your Best Tutor Today",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.neutrals02,
                                    ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "Connect with qualified and verified tutors for any subject or class in your area",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: AppColors.neutrals03,
                                    ),
                              ),

                              const SizedBox(height: 24),

                              Row(
                                children: [
                                  Expanded(
                                    child: AppButton(
                                      fontSize: 12,
                                      label: "Hire a Tutor",
                                      variant: AppButtonVariant.secondary,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const RegisterScreen(role: "tutor"),
                                          ),
                                        );
                                      },
                                      height: 35,
                                    ),
                                  ),

                                  const SizedBox(width: AppSpacing.md),

                                  Expanded(
                                    child: AppButton(
                                        fontSize: 12,
                                      label: "Become a Tutor",
                                      variant: AppButtonVariant.secondary,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                 const RegisterScreen(role: "guardian")
                                          ),
                                        );
                                      },
                                      height: 35,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              AppButton(
                                  fontSize: 12,
                                  
                                label: "Sign In",
                                variant: AppButtonVariant.outline,
                                width: 130,
                                height: 35,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 26),

                        /// IMPORTANT LINKS TITLE
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Important Links",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// LINKS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            LinkItem(icon: Icons.list, label: "Job Board"),
                            LinkItem(
                              icon: Icons.grid_view,
                              label: "Highlights",
                            ),
                            LinkItem(icon: Icons.phone, label: "Helpline"),
                            LinkItem(icon: Icons.video_call, label: "Tutorial"),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  /// TESTIMONIAL FULL WIDTH (NO PADDING)
                  TestimonialSection(testimonials: testimonials),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LinkItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const LinkItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primary01,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white),
        ),

        const SizedBox(height: 6),

        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w300,
            color: AppColors.neutrals03,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
