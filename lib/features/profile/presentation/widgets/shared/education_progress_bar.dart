import 'package:flutter/material.dart';

class EducationProgressBar extends StatelessWidget {
  final String label;
  final bool completed;

  const EducationProgressBar({
    super.key,
    required this.label,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: completed ? 1 : 0,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation(
                completed
                    ? const Color(0xff246BFD)
                    : Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            completed
                ? "Completed"
                : "Incomplete",
            style: TextStyle(
              fontSize: 11,
              color: completed
                  ? Colors.green
                  : Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}