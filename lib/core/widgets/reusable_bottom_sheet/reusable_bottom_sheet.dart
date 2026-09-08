import 'package:flutter/material.dart';
import 'package:btcclient/core/config/theme.dart';

class ReusableBottomSheet extends StatelessWidget {
  final Widget child;
  final double topPadding;
  final double bottomPadding;

  /// Bottom padding inside the modal.
  final double rightPadding;
  final double leftPadding;
  const ReusableBottomSheet({
    super.key,
    required this.child,
    this.topPadding = 0,
    this.bottomPadding = 24,
    this.rightPadding = 20,
    this.leftPadding = 20,
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
            colors: [Colors.white, AppColors.primary02],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Stack(
          children: [
            // ======================================================
            // MAIN CONTENT
            // ======================================================
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // DRAG HANDLE

                // CONTENT
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      leftPadding,
                      topPadding,
                      rightPadding,
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
                    child: Icon(Icons.close, size: 20, color: AppColors.error),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(219, 223, 223, 223),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
