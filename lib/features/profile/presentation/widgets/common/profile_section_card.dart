import 'package:flutter/material.dart';
import 'package:btcclient/core/config/theme.dart';

class ProfileSectionCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget child;
  final VoidCallback? onEdit;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;

  const ProfileSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.onEdit,
    this.trailing,
    this.padding = const EdgeInsets.all(20),
    this.backgroundColor,okare
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.neutrals04.withOpacity(.7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              title: title,
              icon: icon,
              onEdit: onEdit,
              trailing: trailing,
            ),

            const SizedBox(height: 18),

            Divider(
              height: 1,
              color: AppColors.neutrals04,
            ),

            const SizedBox(height: 18),

            child,
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onEdit;
  final Widget? trailing;

  const _Header({
    required this.title,
    this.icon,
    this.onEdit,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null)
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary01.withOpacity(.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AppColors.primary01,
              size: 24,
            ),
          ),

        if (icon != null)
          const SizedBox(width: 14),

        Expanded(
          child: Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        if (trailing != null) trailing!,

        if (onEdit != null)
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary01.withOpacity(.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: AppColors.primary01,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Edit",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary01,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}