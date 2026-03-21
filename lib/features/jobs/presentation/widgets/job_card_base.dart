import 'package:flutter/material.dart';
import '../../data/models/job_model.dart';

class JobCardBase extends StatelessWidget {
  final Job job;
  final Widget? footer;

  const JobCardBase({super.key, required this.job, this.footer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(job.title, style: const TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 6),
          Text("Job ID: ${job.jobId}"),

          const SizedBox(height: 6),
          Text(job.subjects.join(", ")),

          const SizedBox(height: 6),
          Text("${job.address}, ${job.area}, ${job.city}"),

          if (footer != null) ...[
            const SizedBox(height: 10),
            footer!,
          ]
        ],
      ),
    );
  }
}