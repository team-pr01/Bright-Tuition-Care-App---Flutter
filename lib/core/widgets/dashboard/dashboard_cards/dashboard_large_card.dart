import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class DashboardLargeCard extends StatelessWidget {
  final Widget? icon;
  final String? title;
  final String? subtitle;
  final String description;
  final String actionText;
  final VoidCallback? onTap;

  const DashboardLargeCard({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
    required this.description,
    required this.actionText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary03,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          /// LEFT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title!, style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black,fontWeight:FontWeight.w400,height:1.2)),

                const SizedBox(height: 8),

               if(subtitle != null)Text(
                  subtitle!,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(color: Colors.black),
                ), 
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: AppColors.neutrals03),
                ),

                const SizedBox(height: 14),

                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    actionText,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary01,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 25),

          /// RIGHT ICON
          icon!,
        ],
      ),
    );
  }
}
