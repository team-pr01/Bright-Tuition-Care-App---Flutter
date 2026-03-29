

import 'package:btcclient/features/jobs/data/models/job_filter.dart';

class JobRequest {
  final JobFilter filter;

  JobRequest(this.filter);

  Map<String, dynamic> toQuery() {
    return filter.toQuery();
  }
}