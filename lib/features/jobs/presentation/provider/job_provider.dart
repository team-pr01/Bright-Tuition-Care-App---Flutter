import 'package:btcclient/features/jobs/data/requests/job_request.dart';
import 'package:flutter/material.dart';
import '../../data/job_repository.dart';
import '../../data/models/job_model.dart';

class JobProvider extends ChangeNotifier {
  final JobRepository repo;

  JobProvider(this.repo);

  List<Job> jobs = [];
  bool isLoading = false;
  bool hasMore = true;

  int skip = 0;
  final int limit = 10;

  Future<void> fetchJobs({bool refresh = false}) async {
    if (isLoading) return;

    if (refresh) {
      jobs.clear();
      skip = 0;
      hasMore = true;
    }

    if (!hasMore) return;

    isLoading = true;
    notifyListeners();

    final request = JobRequest(
      skip: skip,
      limit: limit,
    );

    final newJobs = await repo.getJobs(request);

    if (newJobs.length < limit) {
      hasMore = false;
    }

    jobs.addAll(newJobs);
    skip += limit;

    isLoading = false;
    notifyListeners();
  }
}