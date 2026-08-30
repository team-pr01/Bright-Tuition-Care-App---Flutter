import 'package:flutter/material.dart';
import 'package:btcclient/core/config/theme.dart';

class HireTutorBar extends StatefulWidget {
  final VoidCallback onTap;

  const HireTutorBar({
    super.key,
    required this.onTap,
  });

  @override
  State<HireTutorBar> createState() => _HireTutorBarState();
}

class _HireTutorBarState extends State<HireTutorBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _arrowAnimation = Tween<double>(
      begin: 0,
      end: 5,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 41,
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 8,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.primary01.withOpacity(0.15),
              offset: const Offset(0, 2),
              blurRadius: 2,
            ),
          ],
          color: AppColors.primary03,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                "Hire a Tutor",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColors.neutrals03,
                      height: 1.5,
                    ),
              ),
            ),

            // Animated arrow
            AnimatedBuilder(
              animation: _arrowAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_arrowAnimation.value, 0),
                  child: child,
                );
              },
              child: Icon(
                Icons.arrow_forward,
                size: 16,
                color: AppColors.primary01,
              ),
            ),
          ],
        ),
      ),
    );
  }
}