import '../models/job_model.dart';
import '../models/posted_job_meta.dart';

class PostedJobsResponse {
  final List<JobModel> jobs;
  final PostedJobMeta meta;

  PostedJobsResponse({
    required this.jobs,
    required this.meta,
  });

  factory PostedJobsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return PostedJobsResponse(
      jobs: (data['jobs'] as List)
          .map((e) => JobModel.fromJson(e))
          .toList(),
      meta: PostedJobMeta.fromJson(data['meta']),
    );
  }
}