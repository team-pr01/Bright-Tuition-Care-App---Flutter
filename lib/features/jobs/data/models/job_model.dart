class JobModel {
  final String id;
  final String jobId;
  final String title;
  final String? category;
  final List<String>? subjects;
  final String? salary;
  final String? city;
  final String? area;
  final String? address;
  final String? preferredTutorGender;
  final String? tutoringDays;
  final String? tuitionType;
  final DateTime? createdAt;

  JobModel({
    required this.id,
    required this.jobId,
    required this.title,
    this.category,
    this.subjects,
    this.salary,
    this.city,
    this.area,
    this.address,
    this.preferredTutorGender,
    this.tutoringDays,
      this.tuitionType, 
    this.createdAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
  return JobModel(
    id: json["_id"] ?? "",
    jobId: json["jobId"] ?? "",
    title: json["title"] ?? "",
    category: json["category"],

    /// ✅ FIXED LIST → STRING
    subjects: (json["subjects"] as List?)
        ?.map((e) => e.toString())
        .toList(),

    salary: json["salary"]?.toString(),

    /// 🔥 MAIN FIX HERE
    city: (json["city"] as List?)?.join(", "),
    area: (json["area"] as List?)?.join(", "),
    address: json["address"],

    preferredTutorGender: json["preferredTutorGender"],
    tutoringDays: json["tutoringDays"]?.toString(),
    tuitionType: json["tuitionType"]?.toString(),

    createdAt: json["createdAt"] != null
        ? DateTime.tryParse(json["createdAt"])
        : null,
  );
}
}