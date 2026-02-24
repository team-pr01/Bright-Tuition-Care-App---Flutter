import 'dart:ffi';

import 'package:btcclient/core/models/testimonial_model.dart';
import 'package:btcclient/core/widgets/start_rating/start_rating.dart';
import 'package:flutter/material.dart';
import '../../../core/config/theme.dart';

class TestimonialCard extends StatefulWidget {
  final TestimonialModel testimonial;

  const TestimonialCard({super.key, required this.testimonial});

  @override
  State<TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<TestimonialCard> {
  bool showReadMore = false;

  @override
  void initState() {
    super.initState();

    /// Detect overflow AFTER layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOverflow();
    });
  }

  void _checkOverflow() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.testimonial.message,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 140);

    if (textPainter.didExceedMaxLines) {
      setState(() {
        showReadMore = true;
      });
    }
  }

  void _openFullTestimonial() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.white, // bottom color
              AppColors.primary02, // top color (change as needed)
            ],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// HEADER WITH FLOATING AVATAR
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  /// MAIN HEADER CONTENT
                  Container(
                    margin: const EdgeInsets.only(top: 40), // space for avatar
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.testimonial.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),

                        Text(
                          widget.testimonial.role,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: AppColors.neutrals03),
                        ),

                        const SizedBox(height: 6),

                        StarRating(rating: 4.8, showValue: true),
                      ],
                    ),
                  ),

                  /// FLOATING AVATAR (-40 FROM TOP)
                  Positioned(
                    top: -70,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: const BoxDecoration(
                        color: AppColors.neutrals04,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(3),
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
                          child: CircleAvatar(
                            radius: 48,
                            backgroundImage: AssetImage(
                              widget.testimonial.image,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Stack(
                children: [
                  /// BIG BACKGROUND QUOTE
                  Positioned(
                    left: 0,
                    top: -5,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        // ..rotateZ(3.14) // rotate 180°
                      ..scale(1.0, 1.0), // mirror horizontally
                      child: Image.asset(
                        'assets/icons/quote.png',
                        width: 46,
                        height: 46,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..rotateZ(3.14), // rotate 180°
                      // ..scale(-1.0, 1.0), // mirror horizontally
                      child: Image.asset(
                        'assets/icons/quote.png',
                        width: 46,
                        height: 46,
                      ),
                    ),
                  ),

                  /// TEXT CONTENT
                  SizedBox(
                      width: double.infinity,
                    child: Padding(
                      
                      padding: const EdgeInsets.only(
                        left: 24,
                        top: 36,
                        bottom: 36,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        widget.testimonial.message,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(height: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openFullTestimonial,
      child: Container(
        height: 148,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.neutrals01,
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(widget.testimonial.image),
            ),

            const SizedBox(width: AppSpacing.sm),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.testimonial.name,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColors.neutrals02,
                    ),
                  ),

                  Text(
                    widget.testimonial.role,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.neutrals03,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// TEXT + READ MORE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.testimonial.message,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(color: AppColors.neutrals03),
                          ),
                        ),

                        if (showReadMore)
                          GestureDetector(
                            onTap: _openFullTestimonial,
                            child: Text(
                              "Read more",
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    color: AppColors.primary01,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
