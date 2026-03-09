import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';

class ProfileProgressIcon extends StatelessWidget {
  final double progress; // 0.0 → 1.0

  const ProfileProgressIcon({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        children: [
          /// Base Light Icon
          Icon(
            Icons.person,
            size: 48,
            color: AppColors.primary01.withOpacity(.25),
          ),

          /// Colored Progress Overlay
          ClipRect(
            clipper: _ProgressClipper(progress),
            child: const Icon(
              Icons.person,
              size: 48,
              color: AppColors.primary01,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressClipper extends CustomClipper<Rect> {
  final double progress;

  _ProgressClipper(this.progress);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * progress, size.height);
  }

  @override
  bool shouldReclip(_ProgressClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
