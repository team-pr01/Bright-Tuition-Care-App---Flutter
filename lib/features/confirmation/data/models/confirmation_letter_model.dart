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
  final UserSummary? guardian;

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

  factory ConfirmationLetterModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ConfirmationLetterModel(
      id: json["_id"]?.toString() ?? "",

      guardianCustomId:
          json["guardianCustomId"]?.toString() ?? "",

      tutorCustomId:
          json["tutorCustomId"]?.toString() ?? "",

      guardianSignature:
          json["guardianSignature"]?.toString(),

      tutorSignature:
          json["tutorSignature"]?.toString(),

      guardianSignedDate:
          json["guardianSinnedDate"]?.toString(),

      tutorSignedDate:
          json["tutorSinnedDate"]?.toString(),

      createdAt: DateTime.tryParse(
            json["createdAt"]?.toString() ?? "",
          ) ??
          DateTime.now(),

      job: json["jobId"] is Map<String, dynamic>
          ? JobSummary.fromJson(
              Map<String, dynamic>.from(json["jobId"]),
            )
          : JobSummary.empty(),

      tutor: json["tutorId"] is Map<String, dynamic>
          ? UserSummary.fromJson(
              Map<String, dynamic>.from(json["tutorId"]),
            )
          : UserSummary.empty(),

      guardian: json["guardianId"] is Map<String, dynamic>
          ? UserSummary.fromJson(
              Map<String, dynamic>.from(json["guardianId"]),
            )
          : null,
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

  factory JobSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return JobSummary(
      id: json["_id"]?.toString() ?? "",

      jobId: json["jobId"]?.toString() ?? "",

      title: json["title"]?.toString() ?? "",

      salary: json["salary"]?.toString() ?? "",

      guardianName:
          json["guardianName"]?.toString() ?? "",

      guardianPhoneNumber:
          json["guardianPhoneNumber"]?.toString() ?? "",

      classes: _stringList(json["class"]),

      subjects: _stringList(json["subjects"]),

      cities: _stringList(json["city"]),

      areas: _stringList(json["area"]),

      tutoringTime:
          json["tutoringTime"]?.toString() ?? "",

      tutoringDays:
          json["tutoringDays"]?.toString() ?? "",
    );
  }

  factory JobSummary.empty() {
    return JobSummary(
      id: "",
      jobId: "",
      title: "",
      salary: "",
      guardianName: "",
      guardianPhoneNumber: "",
      classes: const [],
      subjects: const [],
      cities: const [],
      areas: const [],
      tutoringTime: "",
      tutoringDays: "",
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .map((e) => e?.toString() ?? "")
        .where((e) => e.isNotEmpty)
        .toList();
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

  factory UserSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserSummary(
      id: json["_id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      email: json["email"]?.toString() ?? "",
      phoneNumber:
          json["phoneNumber"]?.toString() ?? "",
    );
  }

  factory UserSummary.empty() {
    return UserSummary(
      id: "",
      name: "",
      email: "",
      phoneNumber: "",
    );
  }
}