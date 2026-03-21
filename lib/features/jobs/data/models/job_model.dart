import 'application_model.dart';

class Job {
  final String id;
  final String jobId;
  final String title;
  final String salary;
  final String tuitionType;
  final String category;
  final List<String> subjects;
  final String tutoringDays;
  final String preferredTutorGender;
  final String address;
  final String city;
  final String area;
  final String createdAt;
  final List<Application> applications;

  Job({
    required this.id,
    required this.jobId,
    required this.title,
    required this.salary,
    required this.tuitionType,
    required this.category,
    required this.subjects,
    required this.tutoringDays,
    required this.preferredTutorGender,
    required this.address,
    required this.city,
    required this.area,
    required this.createdAt,
    required this.applications,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id'] ?? "",
      jobId: json['jobId'] ?? "",
      title: json['title'] ?? "",
      salary: json['salary'] ?? "",
      tuitionType: json['tuitionType'] ?? "",
      category: json['category'] ?? "",
      subjects: List<String>.from(json['subjects'] ?? []),
      tutoringDays: json['tutoringDays'] ?? "",
      preferredTutorGender: json['preferredTutorGender'] ?? "",
      address: json['address'] ?? "",
      city: (json['city'] as List?)?.join(", ") ?? "",
      area: (json['area'] as List?)?.join(", ") ?? "",
      createdAt: json['createdAt'] ?? "",
      applications: (json['applications'] as List? ?? [])
          .map((e) => Application.fromJson(e))
          .toList(),
    );
  }
}