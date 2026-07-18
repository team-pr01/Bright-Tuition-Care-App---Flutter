import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';

class ReusableDialog extends StatelessWidget {
  final Widget child;

  const ReusableDialog({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary02,
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: child,
      ),
    );
  }
}