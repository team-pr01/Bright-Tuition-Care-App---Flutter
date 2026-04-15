class ApplicationCounts {
  final int applied;
  final int withdrawn;
  final int shortlisted;
  final int appointed;
  final int confirmed;
  final int rejected;

  ApplicationCounts({
    required this.applied,
    required this.withdrawn,
    required this.shortlisted,
    required this.appointed,
    required this.confirmed,
    required this.rejected,
  });

  factory ApplicationCounts.fromJson(Map<String, dynamic> json) {
    return ApplicationCounts(
      applied: json['applied'] ?? 0,
      withdrawn: json['withdrawn'] ?? 0,
      shortlisted: json['shortlisted'] ?? 0,
      appointed: json['appointed'] ?? 0,
      confirmed: json['confirmed'] ?? 0,
      rejected: json['rejected'] ?? 0,
    );
  }
}

class ApplicationMeta {
  final int total;
  final int skip;
  final int limit;
  final bool hasMore;
  final ApplicationCounts counts;

  ApplicationMeta({
    required this.total,
    required this.skip,
    required this.limit,
    required this.hasMore,
    required this.counts,
  });

  factory ApplicationMeta.fromJson(Map<String, dynamic> json) {
    return ApplicationMeta(
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 10,
      hasMore: json['hasMore'] ?? false,
      counts: ApplicationCounts.fromJson(json['counts'] ?? {}),
    );
  }
}