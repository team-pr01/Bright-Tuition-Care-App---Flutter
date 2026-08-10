import 'package:flutter/material.dart';

import 'profile_chip_wrap.dart';

class ProfileChipRow extends StatelessWidget {
  final String label;
  final List<String> items;
  final String emptyText;

  const ProfileChipRow({
    super.key,
    required this.label,
    required this.items,
    this.emptyText = "Not Added",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(
            width: 20,
            child: Center(
              child: Text(
                ":",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          Expanded(
            child: ProfileChipWrap(
              items: items,
              emptyText: emptyText,
            ),
          ),
        ],
      ),
    );
  }
}