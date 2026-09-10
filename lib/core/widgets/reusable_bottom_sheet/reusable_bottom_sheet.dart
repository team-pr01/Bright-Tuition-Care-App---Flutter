import 'package:flutter/material.dart';
import 'package:btcclient/core/config/theme.dart';

class ReusableBottomSheet extends StatelessWidget {
  final Widget child;
  final double topPadding;
  final double bottomPadding;
  final double rightPadding;
  final double leftPadding;
  final Widget? bottomChild;

  const ReusableBottomSheet({
    super.key,
    required this.child,
    this.topPadding = 24,
    this.bottomPadding = 24,
    this.rightPadding = 20,
    this.leftPadding = 20,
    this.bottomChild,
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
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      leftPadding,
                      topPadding,
                      rightPadding,
                      bottomChild == null ? bottomPadding : 16,
                    ),
                    child: child,
                  ),
                ),
                if (bottomChild != null) bottomChild!,
              ],
            ),
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
