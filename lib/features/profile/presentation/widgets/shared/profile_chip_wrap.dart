import 'package:flutter/material.dart';

class ProfileChipWrap extends StatelessWidget {
  final List<String> items;
  final String emptyText;

  const ProfileChipWrap({
    super.key,
    required this.items,
    this.emptyText = "Not Added",
  });

  @override
  Widget build(BuildContext context) {
    final values = items
        .where((e) => e.trim().isNotEmpty)
        .toList();

    if (values.isEmpty) {
      return Text(
        emptyText,
        style: const TextStyle(
          color: Colors.red,
        ),
      );
    }

    return Text(
      values.join(', '),
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}