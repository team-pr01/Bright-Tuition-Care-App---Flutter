class JobFilter {
  final String? keyword;
  final String? status;

  final List<String>? city;
  final List<String>? area;
  final List<String>? category;
  final List<String>? className;
  final List<String>? curriculum;
  final List<String>? tutoringDays;
  final List<String>? preferredTutorGender;
  final List<String>? studentGender;
  final List<String>? tuitionType;
  final List<String>? subjects;

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
    this.subjects,
    this.skip = 0,
    this.limit = 10,
  });

  Map<String, dynamic> toQuery() {
    return {
      if (keyword != null) "keyword": keyword,
      if (status != null) "status": status,

      if (city != null && city!.isNotEmpty)
        "city": city!.join(","),

      if (area != null && area!.isNotEmpty)
        "area": area!.join(","),

      if (category != null && category!.isNotEmpty)
        "category": category!.join(","),

      if (className != null && className!.isNotEmpty)
        "class": className!.join(","),

      if (curriculum != null && curriculum!.isNotEmpty)
        "curriculum": curriculum!.join(","),

      if (tutoringDays != null && tutoringDays!.isNotEmpty)
        "tutoringDays": tutoringDays!.join(","),

      if (preferredTutorGender != null &&
          preferredTutorGender!.isNotEmpty)
        "preferredTutorGender":
            preferredTutorGender!.join(","),

      if (studentGender != null && studentGender!.isNotEmpty)
        "studentGender": studentGender!.join(","),

      if (tuitionType != null && tuitionType!.isNotEmpty)
        "tuitionType": tuitionType!.join(","),

      if (subjects != null && subjects!.isNotEmpty)
        "subjects": subjects!.join(","),

      "skip": skip,
      "limit": limit,
    };
  }

  JobFilter copyWith({
    String? keyword,
    String? status,
    List<String>? city,
    List<String>? area,
    List<String>? category,
    List<String>? className,
    List<String>? curriculum,
    List<String>? tutoringDays,
    List<String>? preferredTutorGender,
    List<String>? studentGender,
    List<String>? tuitionType,
    List<String>? subjects,
    int? skip,
    int? limit,
  }) {
    return JobFilter(
      keyword: keyword ?? this.keyword,
      status: status ?? this.status,
      city: city ?? this.city,
      area: area ?? this.area,
      category: category ?? this.category,
      className: className ?? this.className,
      curriculum: curriculum ?? this.curriculum,
      tutoringDays: tutoringDays ?? this.tutoringDays,
      preferredTutorGender:
          preferredTutorGender ?? this.preferredTutorGender,
      studentGender: studentGender ?? this.studentGender,
      tuitionType: tuitionType ?? this.tuitionType,
      subjects: subjects ?? this.subjects,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
    );
  }
}