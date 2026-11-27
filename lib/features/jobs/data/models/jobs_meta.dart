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

  // 👈 New fields for Overview Stats
  final int availableJobs;
  final int activeTutors;
  final int happyGuardians;
  final double averageRating;

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
    this.availableJobs = 0,
    this.activeTutors = 0,
    this.happyGuardians = 0,
    this.averageRating = 0.0,
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
      appointedJobs: json['appointedJobs'],
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 10,
      hasMore: json['hasMore'] ?? false,
      // 👈 Parse new fields
      availableJobs: json['availableJobs'] ?? 0,
      activeTutors: json['activeTutors'] ?? 0,
      happyGuardians: json['happyGuardians'] ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}