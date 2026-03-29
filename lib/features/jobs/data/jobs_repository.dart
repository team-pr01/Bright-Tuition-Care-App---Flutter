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
}