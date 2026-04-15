import 'package:btcclient/features/jobs/data/models/job_model.dart';

class ApplicationModel {
  final String id;
  final JobModel job;
  final String status;
  final DateTime appliedOn;

  final String userId;
  final String tutorId;

  final DateTime? shortlistedOn;
  final DateTime? appointedOn;
  final DateTime? confirmedOn;
  final DateTime? rejectedOn;
  final DateTime? resumeViewedOn;
  final DateTime? withdrawnOn;
  final DateTime? demoDate;

  final bool isWithdrawn;
  final String? followUpStatus;

  ApplicationModel({
    required this.id,
    required this.job,
    required this.status,
    required this.appliedOn,
    required this.userId,
    required this.tutorId,
    required this.isWithdrawn,
    this.shortlistedOn,
    this.appointedOn,
    this.confirmedOn,
    this.rejectedOn,
    this.resumeViewedOn,
    this.withdrawnOn,
    this.demoDate,
    this.followUpStatus,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String key) {
      return json[key] != null ? DateTime.parse(json[key]) : null;
    }

    /// 🔥 STEP 1: Extract job safely
    final jobJson = Map<String, dynamic>.from(json['job'] ?? {});

    /// 🔥 STEP 2: FIX DATA TYPES (VERY IMPORTANT)

    /// Map → String
    if (jobJson['postedBy'] is Map) {
      jobJson['postedBy'] = jobJson['postedBy']['name'] ?? "";
    }

    // /// List → String (ONLY if your JobModel expects String)
    // if (jobJson['city'] is List) {
    //   jobJson['city'] = (jobJson['city'] as List).join(", ");
    // }

    // if (jobJson['area'] is List) {
    //   jobJson['area'] = (jobJson['area'] as List).join(", ");
    // }

    // if (jobJson['subjects'] is List) {
    //   jobJson['subjects'] = (jobJson['subjects'] as List).join(", ");
    // }

    /// 🔥 STEP 3: RETURN MODEL
    return ApplicationModel(
      id: json['_id'] ?? "",
      job: JobModel.fromJson(jobJson),
      status: json['status'] ?? "",
      appliedOn:DateTime.tryParse(json['appliedOn'] ?? "") ?? DateTime.now(),

      userId: json['userId'] ?? "",
      tutorId: json['tutorId'] ?? "",

      shortlistedOn: parseDate('shortlistedOn'),
      appointedOn: parseDate('appointedOn'),
      confirmedOn: parseDate('confirmedOn'),
      rejectedOn: parseDate('rejectedOn'),
      resumeViewedOn: parseDate('resumeViewedOn'),
      withdrawnOn: parseDate('withdrawnOn'),
      demoDate: parseDate('demoDate'),

      isWithdrawn: json['isWithdrawn'] ?? false,
      followUpStatus: json['followUpStatus'],
    );
  }
}