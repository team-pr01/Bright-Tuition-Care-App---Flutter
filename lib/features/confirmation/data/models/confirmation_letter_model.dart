class ConfirmationLetterModel {
  final String id;

  final String guardianCustomId;
  final String tutorCustomId;

  final String? guardianSignature;
  final String? tutorSignature;

  final String? guardianSignedDate;
  final String? tutorSignedDate;

  final DateTime createdAt;

  final JobSummary job;

  final UserSummary tutor;

  final UserSummary guardian;

  ConfirmationLetterModel({
    required this.id,
    required this.guardianCustomId,
    required this.tutorCustomId,
    required this.guardianSignature,
    required this.tutorSignature,
    required this.guardianSignedDate,
    required this.tutorSignedDate,
    required this.createdAt,
    required this.job,
    required this.tutor,
    required this.guardian,
  });

  factory ConfirmationLetterModel.fromJson(Map<String, dynamic> json) {
    return ConfirmationLetterModel(
      id: json["_id"] ?? "",

      guardianCustomId: json["guardianCustomId"] ?? "",
      tutorCustomId: json["tutorCustomId"] ?? "",

      guardianSignature: json["guardianSignature"],
      tutorSignature: json["tutorSignature"],

      guardianSignedDate: json["guardianSinnedDate"],
      tutorSignedDate: json["tutorSinnedDate"],

      createdAt: DateTime.parse(json["createdAt"]),

      job: JobSummary.fromJson(json["jobId"]),

      tutor: UserSummary.fromJson(json["tutorId"]),

      guardian: UserSummary.fromJson(json["guardianId"]),
    );
  }
}

class JobSummary {
  final String id;
  final String jobId;
  final String title;
  final String salary;
  final String guardianName;
  final String guardianPhoneNumber;

  final List<String> classes;
  final List<String> subjects;
  final List<String> cities;
  final List<String> areas;

  final String tutoringTime;
  final String tutoringDays;

  JobSummary({
    required this.id,
    required this.jobId,
    required this.title,
    required this.salary,
    required this.guardianName,
    required this.guardianPhoneNumber,
    required this.classes,
    required this.subjects,
    required this.cities,
    required this.areas,
    required this.tutoringTime,
    required this.tutoringDays,
  });

  factory JobSummary.fromJson(Map<String, dynamic> json) {
    return JobSummary(
      id: json["_id"] ?? "",
      jobId: json["jobId"] ?? "",
      title: json["title"] ?? "",
      salary: json["salary"] ?? "",
      guardianName: json["guardianName"] ?? "",
      guardianPhoneNumber: json["guardianPhoneNumber"] ?? "",

      classes: List<String>.from(json["class"] ?? []),
      subjects: List<String>.from(json["subjects"] ?? []),
      cities: List<String>.from(json["city"] ?? []),
      areas: List<String>.from(json["area"] ?? []),

      tutoringTime: json["tutoringTime"] ?? "",
      tutoringDays: json["tutoringDays"] ?? "",
    );
  }
}

class UserSummary {
  final String id;

  final String name;

  final String email;

  final String phoneNumber;

  UserSummary({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory UserSummary.fromJson(Map<String, dynamic> json) {
    return UserSummary(
      id: json["_id"] ?? "",

      name: json["name"] ?? "",

      email: json["email"] ?? "",

      phoneNumber: json["phoneNumber"] ?? "",
    );
  }
}