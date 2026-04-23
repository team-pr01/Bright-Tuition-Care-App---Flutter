import 'package:flutter/material.dart';

class FormHelpers {
  static Widget field(Widget child, {double width = double.infinity}) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 12),
      child: child,
    );
  }
}