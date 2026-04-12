import 'jobs_api.dart';
import 'models/job_model.dart';
import 'models/job_filter.dart';

class JobsRepository {
  final JobsApi api;

  JobsRepository(this.api);

  Future<List<JobModel>> getJobs(JobFilter filter) async {
    final res = await api.getJobs(filter.toQuery());

    /// 🔥 IMPORTANT VALIDATION
    if (res["success"] != true) {
      throw Exception(res["message"] ?? "Failed to fetch jobs");
    }

   final List data = res["data"]["jobs"] ?? [];

    return data.map((e) => JobModel.fromJson(e)).toList();
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
}