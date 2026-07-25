import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';

class ProfileUtils {
  static Color completionColor(int percentage) {
    if (percentage <= 20) return AppColors.error;
    if (percentage <= 40) return Colors.orange;
    if (percentage <= 60) return Colors.amber;
    if (percentage <= 80) return AppColors.primary01;
    return AppColors.success;
  }
}