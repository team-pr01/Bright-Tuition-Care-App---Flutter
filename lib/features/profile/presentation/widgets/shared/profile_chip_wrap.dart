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

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          // decoration: BoxDecoration(
          //   color: Colors.blue.shade50,
          //   borderRadius: BorderRadius.circular(20),
          //   border: Border.all(
          //     color: Colors.blue.shade100,
          //   ),
          // ),
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}