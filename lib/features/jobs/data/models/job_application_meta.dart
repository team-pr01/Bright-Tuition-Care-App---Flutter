class JobApplicationMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  JobApplicationMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory JobApplicationMeta.fromJson(Map<String, dynamic> json) {
    return JobApplicationMeta(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }
}