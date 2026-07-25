import 'package:flutter/material.dart';
import '../../config/theme.dart';

class AppFormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  const AppFormSection({
    super.key,
    required this.title,
    required this.children,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.neutrals01,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary01.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.neutrals02,
                        ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),

            const SizedBox(height: 18),

            ...children,
          ],
        ),
      ),
    );
  }
}