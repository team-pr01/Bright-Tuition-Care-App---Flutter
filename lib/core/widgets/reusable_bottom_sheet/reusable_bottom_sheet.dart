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
      top: false,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
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
            // ======================================================
            // DRAG HANDLE
            // ======================================================

            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(
                top: 12,
                bottom: 18,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // ======================================================
            // CONTENT
            // ======================================================

            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  24,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}