import 'package:flutter/material.dart';
import '../../config/theme.dart';

enum AppButtonVariant {
  primary,
  secondary,
  outline,
  text,

  gradient, 
  outlineGray, 
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final IconData? icon;
  final double height;
  final double? width;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.icon,
    this.height = 48,
    this.width,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.textColor,
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
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],

              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color: textColor,
                  ),
                ),
              ),
            ],
          );

    Widget button;

    /// ✅ GRADIENT BUTTON
    if (variant == AppButtonVariant.gradient) {
      button = Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF74C5FF), Color(0xFF0D99FF)],
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
      child: button,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );

      /// EXISTING SECONDARY
      case AppButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary01,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        );

      /// EXISTING OUTLINE
      case AppButtonVariant.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary01,
          side: BorderSide(color: AppColors.primary01),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
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
        );
    }
  }
}
