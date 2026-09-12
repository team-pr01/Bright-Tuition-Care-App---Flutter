import 'package:flutter/material.dart';

import 'app_breakpoints.dart';

/// Responsive extensions used throughout the application.
///
/// This keeps responsive logic out of individual screens and widgets.
///
/// Example:
///
/// ```dart
/// Padding(
///   padding: EdgeInsets.symmetric(
///     horizontal: context.pagePadding,
///   ),
/// )
/// ```
///
/// Instead of repeatedly writing:
///
/// ```dart
/// MediaQuery.sizeOf(context).width
/// ```

extension ResponsiveContext on BuildContext {
  // ---------------------------------------------------------------------------
  // SCREEN SIZE
  // ---------------------------------------------------------------------------

  /// Current screen width.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Current screen height.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // ---------------------------------------------------------------------------
  // DEVICE TYPE
  // ---------------------------------------------------------------------------

  /// True when screen is below 340dp.
  bool get isExtraSmallPhone =>
      AppBreakpoints.isExtraSmallPhone(this);

  /// True when screen is between 340dp and 359dp.
  bool get isSmallPhone =>
      screenWidth >= 340 &&
      screenWidth < AppBreakpoints.smallPhone;

  /// True for the primary phone range: 360–599dp.
  bool get isPhone =>
      AppBreakpoints.isPhone(this);

  /// True for any phone below 600dp.
  bool get isAnyPhone =>
      AppBreakpoints.isAnyPhone(this);

  /// True for 600–899dp.
  bool get isTablet =>
      AppBreakpoints.isTablet(this);

  /// True for 900dp and above.
  bool get isLargeScreen =>
      AppBreakpoints.isLarge(this);

  /// True for 1200dp and above.
  bool get isExtraLargeScreen =>
      AppBreakpoints.isExtraLarge(this);

  // ---------------------------------------------------------------------------
  // PAGE LAYOUT
  // ---------------------------------------------------------------------------

  /// Responsive horizontal page padding.
  double get pagePadding =>
      AppBreakpoints.pagePadding(this);

  /// Maximum readable content width.
  double get maxContentWidth =>
      AppBreakpoints.maxContentWidth(this);

  /// Standard responsive spacing.
  double get responsiveSpacing =>
      AppBreakpoints.spacing(this);

  /// Small responsive spacing.
  double get smallSpacing =>
      AppBreakpoints.spacingSmall(this);

  /// Large responsive spacing.
  double get largeSpacing =>
      AppBreakpoints.spacingLarge(this);

  // ---------------------------------------------------------------------------
  // RESPONSIVE VALUE
  // ---------------------------------------------------------------------------

  /// Returns a value according to the current screen width.
  ///
  /// Example:
  ///
  /// ```dart
  /// final fontSize = context.responsiveValue(
  ///   extraSmall: 14,
  ///   small: 15,
  ///   medium: 16,
  ///   large: 18,
  /// );
  /// ```
  T responsiveValue<T>({
    required T extraSmall,
    required T small,
    required T medium,
    required T large,
  }) {
    return AppBreakpoints.value(
      this,
      extraSmall: extraSmall,
      small: small,
      medium: medium,
      large: large,
    );
  }

  // ---------------------------------------------------------------------------
  // RESPONSIVE FONT SIZE
  // ---------------------------------------------------------------------------

  /// Provides a controlled responsive font size.
  ///
  /// This deliberately does NOT scale continuously with screen width.
  /// It uses controlled values to prevent typography from becoming
  /// too large or too small.
  double responsiveFontSize({
    required double extraSmall,
    required double small,
    required double medium,
    required double large,
  }) {
    return responsiveValue(
      extraSmall: extraSmall,
      small: small,
      medium: medium,
      large: large,
    );
  }

  // ---------------------------------------------------------------------------
  // RESPONSIVE HORIZONTAL PADDING
  // ---------------------------------------------------------------------------

  /// Creates symmetric horizontal padding based on screen width.
  EdgeInsets get horizontalPagePadding =>
      EdgeInsets.symmetric(horizontal: pagePadding);

  // ---------------------------------------------------------------------------
  // RESPONSIVE VERTICAL PADDING
  // ---------------------------------------------------------------------------

  /// Creates standard vertical page padding.
  EdgeInsets get pageVerticalPadding =>
      EdgeInsets.symmetric(
        vertical: responsiveValue(
          extraSmall: 12.0,
          small: 16.0,
          medium: 20.0,
          large: 28.0,
        ),
      );

  // ---------------------------------------------------------------------------
  // SAFE AREA / SYSTEM UI
  // ---------------------------------------------------------------------------

  /// Top safe-area padding.
  double get topSafeArea =>
      MediaQuery.paddingOf(this).top;

  /// Bottom safe-area padding.
  double get bottomSafeArea =>
      MediaQuery.paddingOf(this).bottom;

  // ---------------------------------------------------------------------------
  // KEYBOARD
  // ---------------------------------------------------------------------------

  /// Returns the amount of screen currently covered by the keyboard.
  double get keyboardHeight =>
      MediaQuery.viewInsetsOf(this).bottom;

  /// True when the keyboard is visible.
  bool get isKeyboardVisible =>
      keyboardHeight > 0;
}