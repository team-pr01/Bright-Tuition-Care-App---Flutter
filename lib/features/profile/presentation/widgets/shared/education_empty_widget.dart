import 'package:flutter/material.dart';

class EducationEmptyWidget extends StatelessWidget {
  final VoidCallback onAdd;

  const EducationEmptyWidget({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [

          const Icon(
            Icons.school_outlined,
            size: 60,
            color: Color(0xff246BFD),
          ),

          const SizedBox(height: 18),

          const Text(
            "No Educational Information",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Please add your educational details to complete your profile.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 22),

          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text("Add Education"),
          )
        ],
      ),
    );
  }
}