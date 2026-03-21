import 'package:btcclient/features/jobs/data/models/job_model.dart';
import 'package:btcclient/features/jobs/data/requests/job_request.dart';

import 'job_api.dart';

class JobRepository {
  final JobApi api;

  JobRepository(this.api);

  Future<List<Job>> getJobs(JobRequest request) async {
    final data = await api.fetchJobs(request);
    return data.map((e) => Job.fromJson(e)).toList();
  }
}