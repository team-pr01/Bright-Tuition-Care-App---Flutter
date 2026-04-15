import '../models/job_model.dart';
import '../models/jobs_meta.dart';

class JobsResponse {
  final List<JobModel> jobs;
  final JobsMeta meta;

  JobsResponse({
    required this.jobs,
    required this.meta,
  });

  factory JobsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return JobsResponse(
      jobs: (data['jobs'] as List)
          .map((e) => JobModel.fromJson(e))
          .toList(),
       meta: JobsMeta.fromJson(data['meta']),
    );
  }
}