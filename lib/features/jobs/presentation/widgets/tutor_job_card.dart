import 'package:flutter/material.dart';
import '../../data/models/job_model.dart';
import 'job_card_base.dart';

class TutorJobCard extends StatelessWidget {
  final Job job;

  const TutorJobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return JobCardBase(
      job: job,
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(onPressed: () {}, child: const Text("Details")),
          ElevatedButton(onPressed: () {}, child: const Text("Apply")),
        ],
      ),
    );
  }
}