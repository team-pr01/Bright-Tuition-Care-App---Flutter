 import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';

Widget cardWrapper({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.neutrals04),
      ),
      child: child,
    );
  }