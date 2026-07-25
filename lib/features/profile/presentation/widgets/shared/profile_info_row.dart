import 'package:flutter/material.dart';

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final String emptyText;

  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.emptyText = "Not Added",
  });

  @override
  Widget build(BuildContext context) {
    final hasValue =
        value != null && value!.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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
            child: Text(
              hasValue ? value! : emptyText,
              style: TextStyle(
                fontSize: 14,
                color: hasValue
                    ? Colors.black87
                    : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}