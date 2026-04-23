import 'package:btcclient/features/jobs/data/models/job_application_meta.dart';
import 'package:btcclient/features/jobs/data/models/job_application_modal.dart';

class ApplicationResponse {
  final List<JobApplicationModel> applications;
  final JobApplicationMeta meta;

  ApplicationResponse({
    required this.applications,
    required this.meta,
  });

  bool get hasNext => meta.page < meta.totalPages;
  bool get hasPrevious => meta.page > 1;

  factory ApplicationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return ApplicationResponse(
      meta: JobApplicationMeta.fromJson(data['meta']),
      applications: (data['applications'] as List)
          .map((e) => JobApplicationModel.fromJson(e))
          .toList(),
    );
  }
}