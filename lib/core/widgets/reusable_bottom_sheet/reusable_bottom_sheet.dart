import 'package:flutter/material.dart';
import 'package:btcclient/core/config/theme.dart';

class ReusableBottomSheet extends StatelessWidget {
  final Widget child;

  const ReusableBottomSheet({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.white,
              AppColors.primary02,
            ],
          ),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// DRAG HANDLE
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.primary01,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            /// CONTENT
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}