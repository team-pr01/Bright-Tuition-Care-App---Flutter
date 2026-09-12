import 'package:btcclient/core/widgets/start_rating/start_rating.dart';
import 'package:btcclient/features/auth/data/models/testimonial_model.dart';
import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';
import '../../../core/responsive/responsive.dart';

class TestimonialCard extends StatefulWidget {
  final TestimonialModel testimonial;

  const TestimonialCard({
    super.key,
    required this.testimonial,
  });

  @override
  State<TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<TestimonialCard> {
  bool showReadMore = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOverflow();
    });
  }

  void _checkOverflow() {
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.testimonial.review,
        style: textStyle,
      ),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    );

    final horizontalSpace = context.responsiveValue<double>(
      extraSmall: 110,
      small: 120,
      medium: 130,
      large: 140,
    );

    textPainter.layout(
      maxWidth: context.screenWidth - horizontalSpace,
    );

    if (textPainter.didExceedMaxLines && mounted) {
      setState(() {
        showReadMore = true;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // RESPONSIVE VALUES
  // ---------------------------------------------------------------------------

  double get cardHeight {
    return context.responsiveValue<double>(
      extraSmall: 135,
      small: 140,
      medium: 148,
      large: 155,
    );
  }

  double get cardPadding {
    return context.responsiveValue<double>(
      extraSmall: 10,
      small: 12,
      medium: 16,
      large: 20,
    );
  }

  double get cardAvatarRadius {
    return context.responsiveValue<double>(
      extraSmall: 30,
      small: 32,
      medium: 38,
      large: 42,
    );
  }

  double get cardAvatarGap {
    return context.responsiveValue<double>(
      extraSmall: 6,
      small: 7,
      medium: 8,
      large: 10,
    );
  }

  double get bottomSheetAvatarRadius {
    return context.responsiveValue<double>(
      extraSmall: 38,
      small: 42,
      medium: 48,
      large: 54,
    );
  }

  double get quoteSize {
    return context.responsiveValue<double>(
      extraSmall: 34,
      small: 38,
      medium: 46,
      large: 52,
    );
  }

  double get quoteHorizontalPadding {
    return context.responsiveValue<double>(
      extraSmall: 28,
      small: 32,
      medium: 40,
      large: 48,
    );
  }

  double get quoteVerticalPadding {
    return context.responsiveValue<double>(
      extraSmall: 24,
      small: 28,
      medium: 36,
      large: 40,
    );
  }

  // ---------------------------------------------------------------------------
  // FULL TESTIMONIAL
  // ---------------------------------------------------------------------------

  void _openFullTestimonial() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.all(
          context.responsiveValue<double>(
            extraSmall: 6,
            small: 8,
            medium: 8,
            large: 12,
          ),
        ),
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.white,
              AppColors.primary02,
            ],
          ),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.large),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // -----------------------------------------------------------------
              // HEADER + FLOATING AVATAR
              // -----------------------------------------------------------------

              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: context.responsiveValue<double>(
                        extraSmall: 32,
                        small: 36,
                        medium: 40,
                        large: 44,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.testimonial.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),

                        Text(
                          widget.testimonial.role,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: AppColors.neutrals03,
                              ),
                        ),

                        SizedBox(
                          height: context.responsiveValue<double>(
                            extraSmall: 4,
                            small: 5,
                            medium: 6,
                            large: 8,
                          ),
                        ),

                        StarRating(
                          rating: 4.8,
                          showValue: true,
                        ),
                      ],
                    ),
                  ),

                  // -----------------------------------------------------------------
                  // RESPONSIVE AVATAR
                  // -----------------------------------------------------------------

                  Positioned(
                    top: -bottomSheetAvatarRadius - 22,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: const BoxDecoration(
                        color: AppColors.neutrals04,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        
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
                            radius: bottomSheetAvatarRadius,
                            backgroundImage:
                                widget.testimonial.image.isNotEmpty
                                    ? NetworkImage(
                                        widget.testimonial.image,
                                      )
                                    : const AssetImage(
                                        "assets/images/user.jpg",
                                      ) as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: context.responsiveValue<double>(
                  extraSmall: 16,
                  small: 18,
                  medium: 20,
                  large: 24,
                ),
              ),

              // -----------------------------------------------------------------
              // REVIEW
              // -----------------------------------------------------------------

              Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: -5,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..scale(1.0, 1.0),
                      child: Image.asset(
                        'assets/icons/quote.png',
                        width: quoteSize,
                        height: quoteSize,
                      ),
                    ),
                  ),

                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..rotateZ(3.14),
                      child: Image.asset(
                        'assets/icons/quote.png',
                        width: quoteSize,
                        height: quoteSize,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: quoteHorizontalPadding,
                        vertical: quoteVerticalPadding,
                      ),
                      child: Text(
                        widget.testimonial.review,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                              height: 1.5,
                            ),
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

  // ---------------------------------------------------------------------------
  // CARD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openFullTestimonial,
      child: Container(
        height: cardHeight,
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: AppColors.neutrals01,
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -----------------------------------------------------------------
            // CARD AVATAR
            // -----------------------------------------------------------------

            CircleAvatar(
              radius: cardAvatarRadius,
              backgroundImage: widget.testimonial.image.isNotEmpty
                  ? NetworkImage(widget.testimonial.image)
                  : const AssetImage(
                      "assets/images/user.jpg",
                    ) as ImageProvider,
            ),

            SizedBox(width: cardAvatarGap),

            // -----------------------------------------------------------------
            // CONTENT
            // -----------------------------------------------------------------

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.testimonial.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.neutrals02,
                          fontSize: context.responsiveFontSize(
                            extraSmall: 16,
                            small: 17,
                            medium: 18,
                            large: 19,
                          ),
                        ),
                  ),

                  Text(
                    widget.testimonial.role == "tutor"
                        ? "Tutor"
                        : "Guardian",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                          color: AppColors.neutrals03,
                          fontWeight: FontWeight.w300,
                          fontSize: context.responsiveFontSize(
                            extraSmall: 11,
                            small: 11,
                            medium: 12,
                            large: 13,
                          ),
                        ),
                  ),

                  SizedBox(
                    height: context.responsiveValue<double>(
                      extraSmall: 4,
                      small: 5,
                      medium: 6,
                      large: 7,
                    ),
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.testimonial.review,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: AppColors.neutrals03,
                                  fontSize: context.responsiveFontSize(
                                    extraSmall: 10,
                                    small: 10,
                                    medium: 11,
                                    large: 14,
                                  ),
                                ),
                          ),
                        ),

                        if (showReadMore)
                          GestureDetector(
                            onTap: _openFullTestimonial,
                            child: Text(
                              "Read more",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                    color: AppColors.primary01,
                                    fontWeight: FontWeight.w500,
                                    fontSize: context.responsiveFontSize(
                                      extraSmall: 9,
                                      small: 10,
                                      medium: 11,
                                      large: 12,
                                    ),
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