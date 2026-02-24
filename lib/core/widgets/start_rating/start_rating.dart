import 'package:flutter/material.dart';
import '../../config/theme.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final bool showValue;
  final TextStyle? valueStyle;

  const StarRating({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.size = 16,
    this.activeColor = const Color(0xFFFFC107),
    this.inactiveColor = const Color(0xFFE0E0E0),
    this.showValue = false,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        /// Stars
        Row(
          children: List.generate(maxStars, (index) {

            final starValue = index + 1;

            if (rating >= starValue) {
              /// Full star
              return Icon(
                Icons.star,
                size: size,
                color: activeColor,
              );
            }

            else if (rating >= starValue - 0.5) {
              /// Half star
              return Icon(
                Icons.star_half,
                size: size,
                color: activeColor,
              );
            }

            else {
              /// Empty star
              return Icon(
                Icons.star_border,
                size: size,
                color: inactiveColor,
              );
            }

          }),
        ),

        /// Rating value (optional)
        
      ],
    );
  }
}
