import 'package:flutter/material.dart';
import '../../config/theme.dart';

enum AppButtonVariant {
  primary,
  secondary,
  outline,
  text,
  gradient,
  outlineGray,
  delete,
}

enum AppButtonIconPosition { left, right }

class AppButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final IconData? icon;
  final double height;
  final double? width;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? textColor;
  final bool iconOnly;
  final AppButtonIconPosition iconPosition;
  final bool showShimmer;
  final Color? borderColor;
  final Color? backgroundColor;
  final double borderRadius;
  final double borderWidth;

  const AppButton({
    super.key,
    this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.icon,
    this.height = 48,
    this.width,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.textColor,
    this.iconOnly = false,
    this.iconPosition = AppButtonIconPosition.left,
    this.showShimmer = false,
    this.borderColor,
    this.backgroundColor,
    this.borderRadius = 999,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : iconOnly
        ? Center(child: Icon(icon, size: 18, color: textColor))
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null &&
                  iconPosition == AppButtonIconPosition.left) ...[
                Icon(icon, size: 18, color: textColor),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color: textColor,
                  ),
                ),
              ),
              if (icon != null &&
                  iconPosition == AppButtonIconPosition.right) ...[
                const SizedBox(width: 8),
                Icon(icon, size: 18, color: textColor),
              ],
            ],
          );

    Widget button;

    /// ✅ GRADIENT BUTTON
    if (variant == AppButtonVariant.gradient) {
      button = Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd,
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),

        child: ElevatedButton(
          style: _style(),
          onPressed: loading ? null : onPressed,
          child: child,
        ),
      );
    }
    /// ✅ OUTLINE GRAY BUTTON
    else if (variant == AppButtonVariant.outlineGray) {
      button = ElevatedButton(
        style: _style(),
        onPressed: loading ? null : onPressed,
        child: child,
      );
    }
    /// ✅ ALL EXISTING BUTTONS REMAIN SAME
    else if (variant == AppButtonVariant.outline) {
      button = OutlinedButton(
        style: _style(),
        onPressed: loading ? null : onPressed,
        child: child,
      );
    } else if (variant == AppButtonVariant.text) {
      button = TextButton(
        style: _style(),
        onPressed: loading ? null : onPressed,
        child: child,
      );
    } else {
      button = ElevatedButton(
        style: _style(),
        onPressed: loading ? null : onPressed,
        child: child,
      );
    }

    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: showShimmer ? _ButtonShimmer(child: button) : button,
    );
  }

  ButtonStyle _style() {
    switch (variant) {
      /// EXISTING PRIMARY
      case AppButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary01,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: iconOnly
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );

      /// EXISTING SECONDARY
      case AppButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary01,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: iconOnly
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        );

      /// EXISTING OUTLINE
      case AppButtonVariant.outline:
        return OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor ?? AppColors.primary01,
          side: BorderSide(
            color: borderColor ?? AppColors.primary01,
            width: borderWidth,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: iconOnly
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 16),
        );

      /// EXISTING TEXT
      case AppButtonVariant.text:
        return TextButton.styleFrom(foregroundColor: AppColors.primary01);

      /// NEW GRADIENT
      case AppButtonVariant.gradient:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: iconOnly
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );

      /// NEW OUTLINE GRAY
      case AppButtonVariant.outlineGray:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.neutrals01,
          foregroundColor: AppColors.primary01,
          elevation: 0,
          side: BorderSide(color: AppColors.neutrals04),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: iconOnly
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 16),
        );
      case AppButtonVariant.delete:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: AppColors.neutrals01,
          elevation: 0,
          padding: iconOnly
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 16),
          side: BorderSide(color: AppColors.neutrals04),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
    }
  }
}

class _ButtonShimmer extends StatefulWidget {
  final Widget child;

  const _ButtonShimmer({required this.child});

  @override
  State<_ButtonShimmer> createState() => _ButtonShimmerState();
}

class _ButtonShimmerState extends State<_ButtonShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            final width = bounds.width;

            final dx = (_controller.value * 2 - 1) * width;

            return LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: const [Colors.white10, Colors.white30, Colors.white10],
              stops: const [0.35, 0.5, 0.65],
              transform: _SlidingGradientTransform(dx),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(slidePercent, 0, 0);
  }
}
