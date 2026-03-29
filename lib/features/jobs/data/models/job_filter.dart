class JobFilter {
  final String? keyword;
  final String? status;
  final String? city;
  final String? area;
  final String? category;
  final String? className;
  final String? curriculum;
  final String? tutoringDays;
  final String? preferredTutorGender;
  final String? studentGender;
  final String? tuitionType;
  final int skip;
  final int limit;

  JobFilter({
    this.keyword,
    this.status,
    this.city,
    this.area,
    this.category,
    this.className,
    this.curriculum,
    this.tutoringDays,
    this.preferredTutorGender,
    this.studentGender,
    this.tuitionType,
    this.skip = 0,
    this.limit = 10,
  });

  Map<String, dynamic> toQuery() {
    return {
      if (keyword != null) "keyword": keyword,
      if (status != null) "status": status,
      if (city != null) "city": city,
      if (area != null) "area": area,
      if (category != null) "category": category,
      if (className != null) "class": className,
      if (curriculum != null) "curriculum": curriculum,
      if (tutoringDays != null) "tutoringDays": tutoringDays,
      if (preferredTutorGender != null)
        "preferredTutorGender": preferredTutorGender,
      if (studentGender != null) "studentGender": studentGender,
      if (tuitionType != null) "tuitionType": tuitionType,
      "skip": skip,
      "limit": limit,
    };
  }

  JobFilter copyWith({
    int? skip,
  }) {
    return JobFilter(
      keyword: keyword,
      status: status,
      city: city,
      area: area,
      category: category,
      className: className,
      curriculum: curriculum,
      tutoringDays: tutoringDays,
      preferredTutorGender: preferredTutorGender,
      studentGender: studentGender,
      tuitionType: tuitionType,
      skip: skip ?? this.skip,
      limit: limit,
    );
  }
}