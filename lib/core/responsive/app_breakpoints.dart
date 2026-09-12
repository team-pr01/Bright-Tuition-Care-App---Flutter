import 'package:flutter/widgets.dart';

/// Responsive breakpoints for the application.
///
/// Primary target devices:
/// - 360 x 800  -> Primary baseline
/// - 393 x 873  -> Common larger phone
/// - 385 x 854  -> Common larger phone
/// - 412 x 915  -> Large phone
/// - 384 x 832  -> Common Android phone
///
/// The responsive system is width-based because width is the
/// main constraint that determines whether UI elements fit.
///
/// IMPORTANT:
/// Do not use these breakpoints to scale the entire UI.
/// Use them to change layouts, spacing and constraints when needed.
class AppBreakpoints {
  AppBreakpoints._();

  // ---------------------------------------------------------------------------
  // PHONE BREAKPOINTS
  // ---------------------------------------------------------------------------

  /// Primary small-phone baseline.
  ///
  /// 360dp is the most important target for this application.
  static const double smallPhone = 360.0;

  /// Standard phone breakpoint.
  ///
  /// 360dp - 599dp
  static const double phone = 600.0;

  /// Tablet breakpoint.
  ///
  /// 600dp - 899dp
  static const double tablet = 900.0;

  /// Large tablet / desktop-style breakpoint.
  ///
  /// 900dp - 1199dp
  static const double large = 1200.0;

  // ---------------------------------------------------------------------------
  // DEVICE CHECKS
  // ---------------------------------------------------------------------------

  /// Returns true for devices narrower than the primary 360dp baseline.
  ///
  /// Typical examples:
  /// - 320dp
  /// - 340dp
  /// - 350dp
  static bool isExtraSmallPhone(BuildContext context) {
    return MediaQuery.sizeOf(context).width < smallPhone;
  }

  /// Returns true for the primary phone range.
  ///
  /// Includes the important 360dp baseline and devices up to 599dp.
  ///
  /// Examples:
  /// - 360 x 800
  /// - 384 x 832
  /// - 385 x 854
  /// - 393 x 873
  /// - 412 x 915
  static bool isPhone(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return width >= smallPhone && width < phone;
  }

  /// Returns true for all phones, including extra-small phones.
  static bool isAnyPhone(BuildContext context) {
    return MediaQuery.sizeOf(context).width < phone;
  }

  /// Returns true for tablet-sized screens.
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return width >= phone && width < tablet;
  }

  /// Returns true for large screens.
  static bool isLarge(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= tablet;
  }

  /// Returns true for extra-large screens.
  static bool isExtraLarge(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= large;
  }

  // ---------------------------------------------------------------------------
  // SCREEN DIMENSIONS
  // ---------------------------------------------------------------------------

  /// Current available screen width.
  static double width(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  /// Current available screen height.
  static double height(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  // ---------------------------------------------------------------------------
  // PAGE PADDING
  // ---------------------------------------------------------------------------

  /// Responsive horizontal page padding.
  ///
  /// The goal is to preserve usable content width on small phones
  /// while giving larger screens more breathing room.
  static double pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 340) {
      return 12.0;
    }

    if (width < 360) {
      return 16.0;
    }

    if (width < 600) {
      return 20.0;
    }

    if (width < 900) {
      return 32.0;
    }

    return 40.0;
  }

  // ---------------------------------------------------------------------------
  // CONTENT MAX WIDTH
  // ---------------------------------------------------------------------------

  /// Maximum width for readable content.
  ///
  /// Prevents UI from becoming unnecessarily stretched on tablets
  /// and large screens.
  static double maxContentWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < phone) {
      return width;
    }

    if (width < tablet) {
      return 700.0;
    }

    if (width < large) {
      return 900.0;
    }

    return 1100.0;
  }

  // ---------------------------------------------------------------------------
  // SPACING
  // ---------------------------------------------------------------------------

  /// Standard responsive spacing.
  static double spacing(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 340) {
      return 8.0;
    }

    if (width < 360) {
      return 10.0;
    }

    if (width < 600) {
      return 12.0;
    }

    if (width < 900) {
      return 16.0;
    }

    return 24.0;
  }

  /// Small spacing.
  static double spacingSmall(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 360) {
      return 6.0;
    }

    if (width < 600) {
      return 8.0;
    }

    return 12.0;
  }

  /// Large spacing.
  static double spacingLarge(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 360) {
      return 16.0;
    }

    if (width < 600) {
      return 20.0;
    }

    if (width < 900) {
      return 28.0;
    }

    return 32.0;
  }

  // ---------------------------------------------------------------------------
  // RESPONSIVE VALUE HELPER
  // ---------------------------------------------------------------------------

  /// Returns different values depending on the available width.
  ///
  /// Example:
  ///
  /// final padding = AppBreakpoints.value(
  ///   context,
  ///   extraSmall: 12,
  ///   small: 16,
  ///   medium: 20,
  ///   large: 32,
  /// );
  static T value<T>(
    BuildContext context, {
    required T extraSmall,
    required T small,
    required T medium,
    required T large,
  }) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 340) {
      return extraSmall;
    }

    if (width < 360) {
      return small;
    }

    if (width < 600) {
      return medium;
    }

    return large;
  }
}