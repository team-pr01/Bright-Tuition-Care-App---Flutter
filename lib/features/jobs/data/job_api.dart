import 'package:btcclient/features/jobs/data/requests/job_request.dart';
import 'package:dio/dio.dart';

class JobApi {
  final Dio dio;

  JobApi(this.dio);

  Future<List<dynamic>> fetchJobs(JobRequest request) async {
    final res = await dio.get(
      "/jobs",
      queryParameters: request.toQuery(),
    );

    return res.data;
  }
}