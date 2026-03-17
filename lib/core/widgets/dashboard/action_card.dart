import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/gestures.dart';

class ActionCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback? onPressed;
  final String? linkText;
  final VoidCallback? onLinkTap;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    this.onPressed,
    this.linkText,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutrals05, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          /// ICON
          SvgPicture.asset(icon, width: 70, height: 70),

          const SizedBox(height: 16),

          /// TITLE
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 6),

          /// DESCRIPTION
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutrals03,
                height: 1.5,
              ),
              children: [
                TextSpan(text: description),
                TextSpan(
                  text: linkText,
                  style: const TextStyle(
                    color: AppColors.primary01,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onLinkTap,
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          /// BUTTON
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              side: const BorderSide(color: AppColors.primary01, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.primary01,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
