import 'package:btcclient/core/responsive/responsive.dart';
import 'package:btcclient/core/widgets/testimonial/skeletons/testimonial_section_skeleton.dart';
import 'package:btcclient/core/widgets/testimonial/testimonial_section.dart';
import 'package:btcclient/features/auth/presentation/provider/testimonial_notifier.dart';
import 'package:btcclient/features/auth/presentation/screens/choose_role_screen.dart';
import 'package:btcclient/features/auth/presentation/screens/login_screen.dart';
import 'package:btcclient/features/auth/presentation/screens/register_screen.dart';
import 'package:btcclient/features/auth/presentation/screens/request_tutor_screen.dart';
import 'package:btcclient/features/auth/presentation/widgets/welcome_nav_link.dart';
import 'package:btcclient/features/guest/presentation/guest_dashboard_screen.dart';
import 'package:btcclient/features/guest/presentation/screens/overview_screen.dart';
import 'package:btcclient/features/legal/presentation/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/widgets/button/app_button.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(testimonialProvider).fetchTestimonials();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(testimonialProvider);
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                'assets/images/logo-1.png',
                                width: context.responsiveValue<double>(
                                  extraSmall: 220,
                                  small: 240,
                                  medium: 260,
                                  large: 280,
                                ),
                                height: context.responsiveValue<double>(
                                  extraSmall: 80,
                                  small: 90,
                                  medium: 110,
                                  large: 130,
                                ),
                                fit: BoxFit.contain,
                              ),

                              SizedBox(height: context.responsiveValue<double>(
                                  extraSmall: 18,
                                  small: 22,
                                  medium: 26,
                                  large: 30,
                                ),),

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
                                            fontSize: context.responsiveValue<double>(
                                              extraSmall: 18,
                                              small: 20,
                                              medium: 22,
                                              large: 24,
                                            ),
                                          ),
                                    ),

                                    SizedBox(height: context.responsiveValue<double>(
                                  extraSmall: 2,
                                  small: 3,
                                  medium: 6,
                                  large: 6,
                                ),),

                                    Text(
                                      "Connect with qualified and verified tutors for any subject or class in your area",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: AppColors.neutrals03,
                                            fontSize: context.responsiveValue<double>(
                                              extraSmall: 10,
                                              small: 12,
                                              medium: 12,
                                              large: 12,
                                            ),
                                          ),
                                    ),

                                    SizedBox(height: context.responsiveValue<double>(
                                      extraSmall: 12,
                                      small: 16,
                                      medium: 20,
                                      large: 24,
                                    )),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: AppButton(
                                            fontSize: 12,
                                            label: "Hire a Tutor",
                                            variant: AppButtonVariant.secondary,
                                            height: 35,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const RequestTutorScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                        const SizedBox(width: AppSpacing.md),

                                        Expanded(
                                          child: AppButton(
                                            fontSize: 12,
                                            label: "Become a Tutor",
                                            variant: AppButtonVariant.secondary,
                                            height: 35,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const RegisterScreen(
                                                        role: "tutor",
                                                      ),
                                                ),
                                              );
                                            },
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
                                            builder: (_) =>
                                                const ChooseRoleScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: context.responsiveValue<double>(
                                  extraSmall: 15,
                                  small: 22,
                                  medium: 22,
                                  large: 24,
                                ),),

                              /// IMPORTANT LINKS
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Important Links",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                              ),

                              const SizedBox(height: 16),

                              /// LINKS
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  WelcomeNavLink(
                                    icon: SvgPicture.asset(
                                      "assets/icons/navigations/jobs.svg",
                                      width: 24,
                                      height: 24,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    label: "Job Board",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const GuestDashboardScreen(
                                                initialIndex: 0,
                                              ),
                                        ),
                                      );
                                    },
                                  ),

                                  WelcomeNavLink(
                                    icon: SvgPicture.asset(
                                      "assets/icons/navigations/video-ai.svg",
                                      width: 24,
                                      height: 24,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    label: "Tutorials",
                                    onTap: () async {
                                      final url = Uri.parse(
                                        "https://www.brighttuitioncare.com/tutorial",
                                      );

                                      if (!await launchUrl(
                                        url,
                                        mode: LaunchMode.externalApplication,
                                      )) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Could not open tutorial",
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),

                                  WelcomeNavLink(
                                    icon: SvgPicture.asset(
                                      "assets/icons/navigations/mdi-light_phone.svg",
                                      width: 24,
                                      height: 24,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    label: "Helpline",
                                    onTap: () {
                                      launchUrl(
                                        Uri.parse("tel:+8801616012365"),
                                      );
                                    },
                                  ),

                                  WelcomeNavLink(
                                    icon: SvgPicture.asset(
                                      "assets/icons/navigations/dashboard-square-edit.svg",
                                      width: 24,
                                      height: 24,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    label: "Overview",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const OverviewScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),

                        /// TESTIMONIAL
                        state.isLoading
                            ? const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg,
                                ),
                                child: TestimonialSectionSkeleton(),
                              )
                            : state.testimonials.isEmpty
                            ? const SizedBox()
                            : TestimonialSection(
                                testimonials: state.testimonials,
                              ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
