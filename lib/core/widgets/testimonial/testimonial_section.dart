import 'package:btcclient/features/auth/data/models/testimonial_model.dart';
import 'package:flutter/material.dart';
import '../../../core/config/theme.dart';
import 'testimonial_card.dart';

class TestimonialSection extends StatefulWidget {
  final List<TestimonialModel> testimonials;

  const TestimonialSection({
    super.key,
    required this.testimonials,
  });

  @override
  State<TestimonialSection> createState() =>
      _TestimonialSectionState();
}

class _TestimonialSectionState
    extends State<TestimonialSection> {

  late final PageController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      viewportFraction: 0.92,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    /// 🔥 SAFETY: HANDLE EMPTY STATE
    if (widget.testimonials.isEmpty) {
      return const SizedBox(); // or loader / placeholder
    }

    return Column(
      children: [

        /// SLIDER
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.testimonials.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = widget.testimonials[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: TestimonialCard(
                  testimonial: item,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        /// DOT INDICATOR
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.testimonials.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? AppColors.primary01
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}