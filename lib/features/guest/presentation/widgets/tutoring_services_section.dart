import 'package:flutter/material.dart';

import 'package:btcclient/core/config/theme.dart';

class TutoringServicesSection extends StatefulWidget {
  const TutoringServicesSection({
    super.key,
  });

  @override
  State<TutoringServicesSection> createState() =>
      _TutoringServicesSectionState();
}

class _TutoringServicesSectionState
    extends State<TutoringServicesSection> {
  static const List<ServiceCategory> _categories = [
    ServiceCategory(
      title: 'Admission Test',
      imagePath:
          'assets/images/service_catagories/admission_test.png',
    ),
    ServiceCategory(
      title: 'Madrasa Medium',
      imagePath:
          'assets/images/service_catagories/arbi.png',
    ),
    ServiceCategory(
      title: 'Bangla Medium',
      imagePath:
          'assets/images/service_catagories/bangla_medium.png',
    ),
    ServiceCategory(
      title: 'Drawing & Art',
      imagePath:
          'assets/images/service_catagories/drawing.png',
    ),
    ServiceCategory(
      title: 'English Medium',
      imagePath:
          'assets/images/service_catagories/english_medium.png',
    ),
    ServiceCategory(
      title: 'English Version',
      imagePath:
          'assets/images/service_catagories/english_version.png',
    ),
    ServiceCategory(
      title: 'Language Learning',
      imagePath:
          'assets/images/service_catagories/language_learning.png',
    ),
    ServiceCategory(
      title: 'Professional Skills',
      imagePath:
          'assets/images/service_catagories/professional_skills.png',
    ),
    ServiceCategory(
      title: 'Special Child Education',
      imagePath:
          'assets/images/service_catagories/special_child.png',
    ),
    ServiceCategory(
      title: 'Special Skills',
      imagePath:
          'assets/images/service_catagories/special_skills.png',
    ),
    ServiceCategory(
      title: 'Test Preparation',
      imagePath:
          'assets/images/service_catagories/test_prep.png',
    ),
    ServiceCategory(
      title: 'University Help',
      imagePath:
          'assets/images/service_catagories/uni_help.png',
    ),
  ];

  late final PageController _controller;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      viewportFraction: 0.90,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int pageCount =
        (_categories.length / 2).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Our Tutoring Services',
                style:
                    AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.primary04,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'Connecting students with expert tutors across all education categories.',
                style:
                    AppTextStyles.bodySmall.copyWith(
                  color: AppColors.neutrals03,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(
          height: AppSpacing.md,
        ),

        SizedBox(
          width: double.infinity,
          height: 220,
          child: PageView.builder(
            controller: _controller,
            itemCount: pageCount,
            physics:
                const BouncingScrollPhysics(),
            onPageChanged: (index) {
              if (!mounted) return;

              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder:
                (context, pageIndex) {
              final int firstIndex =
                  pageIndex * 2;

              final int secondIndex =
                  firstIndex + 1;

              return Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(
                        right: 4,
                      ),
                      child: _buildServiceCard(
                        _categories[firstIndex],
                      ),
                    ),
                  ),

                  if (secondIndex <
                      _categories.length)
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(
                          left: 4,
                          right: 8,
                        ),
                        child: _buildServiceCard(
                          _categories[
                              secondIndex],
                        ),
                      ),
                    )
                  else
                    const Expanded(
                      child: SizedBox(),
                    ),
                ],
              );
            },
          ),
        ),

        const SizedBox(
          height: AppSpacing.md,
        ),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: List.generate(
            pageCount,
            (index) {
              final bool isSelected =
                  _currentPage == index;

              return AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 250,
                ),
                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 3,
                ),
                width:
                    isSelected ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary01
                      : Colors.grey[300],
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(
    ServiceCategory category,
  ) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior:
          Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              category.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  decoration:
                      const BoxDecoration(
                    gradient:
                        LinearGradient(
                      colors: [
                        Color(0xFF3B82F6),
                        Color(0xFF1D4ED8),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient:
                    LinearGradient(
                  begin:
                      Alignment.topCenter,
                  end:
                      Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(
                      alpha: 0.78,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Text(
              category.title,
              maxLines: 2,
              overflow:
                  TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight:
                    FontWeight.w700,
                fontSize: 15,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceCategory {
  final String title;
  final String imagePath;

  const ServiceCategory({
    required this.title,
    required this.imagePath,
  });
}