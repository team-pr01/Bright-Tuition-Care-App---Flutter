import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class DashboardSmallCard extends StatelessWidget {
  final Widget? icon;
  final String? title;
  final String? subtitle;
  final String? description;
  final String? actionText;
  final VoidCallback? onAction;

  const DashboardSmallCard({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
    this.description,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
  return SizedBox(
  height: double.infinity,
  child: Container(
    padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary03,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP SECTION
          if (title != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                if (icon != null) icon!,
              ],
            )
          /// IF TITLE IS MISSING → ICON CENTER
          else if (icon != null)
            Center(child: icon!),

          const SizedBox(height: 10),

          /// SUBTITLE
          if (subtitle != null)
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Colors.black,
                height: 1.7,
              ),
            ),

          /// DESCRIPTION
          if (description != null)
            Text(
              description!,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.neutrals03,
                height: 1.5,
              ),
            ),

          /// ACTION BUTTON
          if (actionText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onAction,
                  child: Text(
                    actionText!,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary01,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ));
  }
}
