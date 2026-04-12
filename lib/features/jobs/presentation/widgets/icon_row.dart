import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:btcclient/core/config/theme.dart';

class IconRow extends StatelessWidget {
  final String icon;
  final String title;
  final String? value;

  const IconRow({
    super.key,
    required this.icon,
    required this.title,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(icon, height: 18, color: AppColors.primary01),
        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: AppColors.neutrals03),
              ),
              const SizedBox(height: 2),
              Text(
                value ?? "-",
                softWrap: true,
                overflow: TextOverflow.visible,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.neutrals02,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
