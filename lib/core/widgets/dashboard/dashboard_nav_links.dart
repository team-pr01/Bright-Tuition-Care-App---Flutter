import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/number_formatter.dart';
import 'package:flutter/material.dart';

class DashboardNavLinks extends StatelessWidget {
  final Widget icon;
  final String label;
  final int count;
  final VoidCallback? onTap; // ✅ ADD THIS

  const DashboardNavLinks({
    super.key,
    required this.icon,
    required this.label,
    this.count = 0,
    this.onTap, // ✅ ADD THIS
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // ✅ CLICK HANDLER
      borderRadius: BorderRadius.circular(12), // nice UX
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.primaryGradientStart,
                  AppColors.primaryGradientEnd
                ],
                stops: [0.0082, 1],
              ),
              shape: BoxShape.circle,
            ),
            child: icon,
          ),

          const SizedBox(height: 6),

          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w300,
              color: AppColors.neutrals02,
            ),
          ),

          Text(
            formatNumber(count),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w300,
              color: AppColors.neutrals02,
            ),
          ),
        ],
      ),
    );
  }
}