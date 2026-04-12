import 'package:btcclient/features/jobs/data/models/application_model.dart';

class JobModel {
  final String? id;
  final String? jobId;
  final String? title;
  final String? salary;
  final String? tuitionType;
  final String? category;
  final String? curriculum;

  final List<String>? classes;
  final List<String>? subjects;

  final String? tutoringTime;
  final String? tutoringDays;
  final String? otherRequirements;

  final String? preferredTutorGender;
  final int? numberOfStudents;
  final String? studentGender;

  final List<String>? city;
  final List<String>? area;
  final String? address;
  final String? locationDirection;

  final String? guardianName;
  final String? guardianPhoneNumber;

  final String? status;
  final String? postedBy;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? jobUpdatedAt;

  final List<ApplicationModel>? applications;

  JobModel({
    this.id,
    this.jobId,
    this.title,
    this.salary,
    this.tuitionType,
    this.category,
    this.curriculum,
    this.classes,
    this.subjects,
    this.tutoringTime,
    this.tutoringDays,
    this.otherRequirements,
    this.preferredTutorGender,
    this.numberOfStudents,
    this.studentGender,
    this.city,
    this.area,
    this.address,
    this.locationDirection,
    this.guardianName,
    this.guardianPhoneNumber,
    this.status,
    this.postedBy,
    this.createdAt,
    this.updatedAt,
    this.jobUpdatedAt,
    this.applications,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['_id'],
      jobId: json['jobId'],
      title: json['title'],
      salary: json['salary'],
      tuitionType: json['tuitionType'],
      category: json['category'],
      curriculum: json['curriculum'],

      classes: (json['class'] as List?)?.map((e) => e.toString()).toList(),
      subjects: (json['subjects'] as List?)?.map((e) => e.toString()).toList(),

      tutoringTime: json['tutoringTime'],
      tutoringDays: json['tutoringDays'],
      otherRequirements: json['otherRequirements'],

      preferredTutorGender: json['preferredTutorGender'],
      numberOfStudents: json['numberOfStudents'],
      studentGender: json['studentGender'],

      city: (json['city'] as List?)?.map((e) => e.toString()).toList(),
      area: (json['area'] as List?)?.map((e) => e.toString()).toList(),
      address: json['address'],
      locationDirection: json['locationDirection'],

      guardianName: json['guardianName'],
      guardianPhoneNumber: json['guardianPhoneNumber'],

      status: json['status'],
      postedBy: json['postedBy'],

      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      jobUpdatedAt: json['jobUpdatedAt'] != null
          ? DateTime.parse(json['jobUpdatedAt'])
          : null,

      applications: (json['applications'] as List?)
          ?.map((e) => ApplicationModel.fromJson(e))
          .toList(),
    );
  }
  List<String>? parseList(dynamic value) {
  if (value == null) return null;

  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }

  if (value is String) {
    return [value];
  }

  return null;
}
}