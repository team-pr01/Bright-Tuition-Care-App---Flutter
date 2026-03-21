class JobRequest {
  final String? keyword;
  final String? city;
  final int? skip;
  final int? limit;

  JobRequest({
    this.keyword,
    this.city,
    this.skip,
    this.limit,
  });

  Map<String, dynamic> toQuery() {
    return {
      if (keyword != null) "keyword": keyword,
      if (city != null) "city": city,
      if (skip != null) "skip": skip,
      if (limit != null) "limit": limit,
    };
  }

  JobRequest copyWith({
    int? skip,
  }) {
    return JobRequest(
      keyword: keyword,
      city: city,
      skip: skip ?? this.skip,
      limit: limit,
    );
  }
}