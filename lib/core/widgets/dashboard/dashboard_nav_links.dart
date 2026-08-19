import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/number_formatter.dart';
import 'package:flutter/material.dart';

class DashboardNavLinks extends StatelessWidget {
  final Widget icon;
  final String label;
  final int count;
  final VoidCallback? onTap;
  final bool isSelected;

  const DashboardNavLinks({
    super.key,
    required this.icon,
    required this.label,
    this.count = 0,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: AppColors.primary01,
                  shape: BoxShape.circle,
                ),
                child: icon,
              ),

              if (isSelected)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
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