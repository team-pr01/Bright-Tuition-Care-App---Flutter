import 'package:flutter/material.dart';
import 'package:btcclient/core/config/theme.dart';

class ReusableModal extends StatelessWidget {
  final Widget child;

  /// Maximum percentage of screen height the modal can occupy.
  final double maxHeightFactor;

  /// Horizontal padding around the modal content.
  final double horizontalPadding;

  /// Bottom padding inside the modal.
  final double bottomPadding;

  /// Whether tapping outside the modal should close it.
  final bool barrierDismissible;

  const ReusableModal({
    super.key,
    required this.child,
    this.maxHeightFactor = 0.90,
    this.horizontalPadding = 20,
    this.bottomPadding = 24,
    this.barrierDismissible = true,
  });

  /// Opens the reusable modal.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double maxHeightFactor = 0.90,
    double horizontalPadding = 20,
    double bottomPadding = 24,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (context) {
        return ReusableModal(
          maxHeightFactor: maxHeightFactor,
          horizontalPadding: horizontalPadding,
          bottomPadding: bottomPadding,
          barrierDismissible: barrierDismissible,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SafeArea(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: screenHeight * maxHeightFactor,
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
            borderRadius: BorderRadius.all(
              Radius.circular(24),
            ),
          ),
          child: Stack(
            children: [
              // ======================================================
              // MAIN CONTENT
              // ======================================================

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TOP SPACING
                  const SizedBox(height: 20),

                  // CONTENT
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        0,
                        horizontalPadding,
                        bottomPadding,
                      ),
                      child: child,
                    ),
                  ),
                ],
              ),

              // ======================================================
              // CLOSE BUTTON
              // ======================================================

              Positioned(
                top: 10,
                right: 12,
                child: Material(
                  color: AppColors.error.withOpacity(0.1),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const SizedBox(
                      width: 34,
                      height: 34,
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}