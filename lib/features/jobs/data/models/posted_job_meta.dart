class PostedJobCounts {
  final int totalJobs;
  final int pendingJobs;
  final int liveJobs;
  final int closedJobs;
  final int cancelledJobs;

  PostedJobCounts({
    required this.totalJobs,
    required this.pendingJobs,
    required this.liveJobs,
    required this.closedJobs,
    required this.cancelledJobs,
  });

  factory PostedJobCounts.fromJson(Map<String, dynamic> json) {
    return PostedJobCounts(
      totalJobs: json['totalJobs'] ?? 0,
      pendingJobs: json['pendingJobs'] ?? 0,
      liveJobs: json['liveJobs'] ?? 0,
      closedJobs: json['closedJobs'] ?? 0,
      cancelledJobs: json['cancelledJobs'] ?? 0,
    );
  }
}

class PostedJobMeta {
  final int total;
  final int skip;
  final int limit;
  final bool hasMore;
  final PostedJobCounts counts;

  PostedJobMeta({
    required this.total,
    required this.skip,
    required this.limit,
    required this.hasMore,
    required this.counts,
  });

  factory PostedJobMeta.fromJson(Map<String, dynamic> json) {
    return PostedJobMeta(
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 10,
      hasMore: json['hasMore'] ?? false,
      counts: PostedJobCounts.fromJson(json['counts'] ?? {}),
    );
  }
}