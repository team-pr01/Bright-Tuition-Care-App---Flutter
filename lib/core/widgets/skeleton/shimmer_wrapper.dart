import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWrapper extends StatelessWidget {
  final Widget child;

  const ShimmerWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutrals01,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 217, 236, 253),
      highlightColor: AppColors.primary02,
      child: child,
    ),);
  }
}