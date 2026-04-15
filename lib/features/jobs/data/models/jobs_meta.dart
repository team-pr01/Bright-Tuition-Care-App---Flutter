class JobsMeta {
  final int total;
  final int? filteredTotal;
  final int? liveJobs;
  final int? pendingJobs;
  final int? closedJobs;
  final int? cancelledJobs;
  final int? shortlistedJobs;
  final int? appointedJobs;
  final int skip;
  final int limit;
  final bool hasMore;

  JobsMeta({
    required this.total,
    this.filteredTotal,
    this.liveJobs,
    this.pendingJobs,
    this.closedJobs,
    this.cancelledJobs,
    this.shortlistedJobs,
    this.appointedJobs,
    required this.skip,
    required this.limit,
    required this.hasMore,
  });

  factory JobsMeta.fromJson(Map<String, dynamic> json) {
    return JobsMeta(
      total: json['total'] ?? 0,
      filteredTotal: json['filteredTotal'],
      liveJobs: json['liveJobs'],
      pendingJobs: json['pendingJobs'],
      closedJobs: json['closedJobs'],
      cancelledJobs: json['cancelledJobs'],
      shortlistedJobs: json['shortlistedJobs'],
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 10,
      hasMore: json['hasMore'] ?? false,
    );
  }
}
