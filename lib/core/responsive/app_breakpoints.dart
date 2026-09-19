import 'package:flutter/material.dart';

class AppBreakpoints {
  AppBreakpoints._();

  // ---------------------------------------------------------------------------
  // BREAKPOINTS
  // ---------------------------------------------------------------------------

  /// Very small phones: < 340dp
  static const double extraSmallPhone = 340.0;

  /// Small phones: 340–359dp
  static const double smallPhone = 360.0;

  /// Phones: 360–599dp
  static const double phone = 600.0;

  /// Tablets: 600–899dp
  static const double tablet = 900.0;

  /// Large screens: 900–1199dp
  static const double large = 1200.0;

  // ---------------------------------------------------------------------------
  // DEVICE CHECKS
  // ---------------------------------------------------------------------------

  static bool isExtraSmallPhone(BuildContext context) {
    return MediaQuery.sizeOf(context).width < extraSmallPhone;
  }

  static bool isSmallPhone(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return width >= extraSmallPhone && width < smallPhone;
  }

  static bool isPhone(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return width >= smallPhone && width < phone;
  }

  static bool isAnyPhone(BuildContext context) {
    return MediaQuery.sizeOf(context).width < phone;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return width >= phone && width < tablet;
  }

  static bool isLarge(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= tablet;
  }

  static bool isExtraLarge(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= large;
  }

  // ---------------------------------------------------------------------------
  // SCREEN DIMENSIONS
  // ---------------------------------------------------------------------------

  static double width(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double height(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  // ---------------------------------------------------------------------------
  // PAGE PADDING
  // ---------------------------------------------------------------------------

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
  // RESPONSIVE VALUE
  // ---------------------------------------------------------------------------

  static T value<T>(
    BuildContext context, {
    required T extraSmall,
    required T small,
    required T medium,
    required T large,
  }) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < extraSmallPhone) {
      return extraSmall;
    }

    if (width < smallPhone) {
      return small;
    }

    if (width < phone) {
      return medium;
    }

    return large;
  }
}