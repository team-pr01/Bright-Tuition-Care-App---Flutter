import 'package:flutter/material.dart';

import 'responsive.dart';

/// A reusable responsive page wrapper.
///
/// Provides:
/// - SafeArea
/// - Responsive horizontal padding
/// - Maximum content width
/// - Optional scrolling
/// - Keyboard-friendly layouts
///
/// Use this as the outer structure for most app screens.
///
/// Example:
///
/// ```dart
/// return ResponsiveScaffold(
///   child: Column(
///     children: [
///       ...
///     ],
///   ),
/// );
/// ```
class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.useSafeArea = true,
    this.scrollable = false,
    this.keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    this.maxWidth,
    this.resizeToAvoidBottomInset = true,
  });

  /// Main page content.
  final Widget child;

  /// Optional page background color.
  final Color? backgroundColor;

  /// Optional custom padding.
  ///
  /// If null, responsive page padding is used automatically.
  final EdgeInsetsGeometry? padding;

  /// Whether the content should be wrapped in SafeArea.
  final bool useSafeArea;

  /// Whether the page should become scrollable.
  final bool scrollable;

  /// Keyboard dismissal behavior when scrolling.
  final ScrollViewKeyboardDismissBehavior
      keyboardDismissBehavior;

  /// Optional maximum content width.
  ///
  /// If null, the value from [AppBreakpoints.maxContentWidth]
  /// is used.
  final double? maxWidth;

  /// Whether the body should resize when keyboard appears.
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    // -------------------------------------------------------------------------
    // RESPONSIVE PADDING
    // -------------------------------------------------------------------------

    content = Padding(
      padding: padding ?? context.horizontalPagePadding,
      child: content,
    );

    // -------------------------------------------------------------------------
    // MAXIMUM CONTENT WIDTH
    // -------------------------------------------------------------------------

    content = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? context.maxContentWidth,
        ),
        child: content,
      ),
    );

    // -------------------------------------------------------------------------
    // SCROLLING
    // -------------------------------------------------------------------------

    if (scrollable) {
      content = SingleChildScrollView(
        keyboardDismissBehavior: keyboardDismissBehavior,
        child: content,
      );
    }

    // -------------------------------------------------------------------------
    // SAFE AREA
    // -------------------------------------------------------------------------

    if (useSafeArea) {
      content = SafeArea(
        child: content,
      );
    }

    // -------------------------------------------------------------------------
    // SCAFFOLD
    // -------------------------------------------------------------------------

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: content,
    );
  }
}