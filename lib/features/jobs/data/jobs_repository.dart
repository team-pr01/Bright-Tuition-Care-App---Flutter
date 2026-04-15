import 'package:btcclient/features/jobs/data/responses/application_response.dart';
import 'package:btcclient/features/jobs/data/responses/jobs_response.dart';
import 'package:btcclient/features/jobs/data/responses/posted_jobs_response.dart';

import 'jobs_api.dart';
import 'models/job_filter.dart';

class JobsRepository {
  final JobsApi api;

  JobsRepository(this.api);

Future<JobsResponse> getJobs(JobFilter filter) async {
  final res = await api.getJobs(filter.toQuery());

  if (res["success"] != true) {
    throw Exception(res["message"] ?? "Failed to fetch jobs");
  }

  return JobsResponse.fromJson(res);
}

 

  Future<Map<String, dynamic>> applyJob({
    required String jobId,
    required String userId,
  }) async {

    final res = await api.applyForJob(
      jobId: jobId,
      userId: userId,
    );

    if (res["success"] != true) {
      throw Exception(res["message"] ?? "Apply failed");
    }

    return res["data"];
  }

  Future<void> withdrawApplication({
  required String applicationId,
}) async {

  final res = await api.withdrawApplication(
    applicationId: applicationId,
  );

  if (res["success"] != true) {
    throw Exception(res["message"] ?? "Withdraw failed");
  }
}

Future<ApplicationResponse> getMyApplications({
  required Map<String, dynamic> query,
}) async {
  final res = await api.getMyApplications(query: query);

  /// 🔥 SAME VALIDATION (keep consistency)
  if (res["success"] != true) {
    throw Exception(res["message"] ?? "Failed to fetch applications");
  }

  return ApplicationResponse.fromJson(res);
}

Future<PostedJobsResponse> getMyPostedJobs({
  required Map<String, dynamic> query,
}) async {
  final res = await api.getMyPostedJobs(query: query);

  if (res["success"] != true) {
    throw Exception(res["message"] ?? "Failed to fetch posted jobs");
  }

  return PostedJobsResponse.fromJson(res);
}

}