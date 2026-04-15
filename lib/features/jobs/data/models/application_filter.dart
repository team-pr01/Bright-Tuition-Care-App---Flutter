class ApplicationFilter {
  final String? status;
  final int limit;
  final int skip;

  ApplicationFilter({
    this.status,
    this.limit = 20,
    this.skip = 0,
  });

  ApplicationFilter copyWith({
    String? status,
    int? limit,
    int? skip,
  }) {
    return ApplicationFilter(
      status: status ?? this.status,
      limit: limit ?? this.limit,
      skip: skip ?? this.skip,
    );
  }

  Map<String, dynamic> toQuery() {
    return {
      if (status != null) "status": status,
      "limit": limit,
      "skip": skip,
    };
  }
}