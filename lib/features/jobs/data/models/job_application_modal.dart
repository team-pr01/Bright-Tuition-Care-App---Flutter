class JobApplicationModel {
  // ============================================================
  // APPLICATION
  // ============================================================

  final String id;

  final String status;
  final bool isWithdrawn;

  final String appliedOn;
  final String? resumeViewedOn;
  final String? demoDate;

  final String? shortlistedOn;
  final String? appointedOn;
  final String? confirmedOn;
  final String? rejectedOn;
  final String? withdrawnOn;

  final String? followUpStatus;

  // ============================================================
  // JOB
  // ============================================================

  final String jobMongoId;
  final String jobId;
  final String jobTitle;

  // ============================================================
  // TUTOR
  // ============================================================

  final String tutorId;
  final String tutorCustomId;
  final String? tutorAddress;

  // ============================================================
  // USER
  // ============================================================

  final String userId;
  final String userName;
  final String? userPhoneNumber;
  final String? userCity;
  final String? userArea;

  // ============================================================
  // TIMESTAMPS
  // ============================================================

  final String? createdAt;
  final String? updatedAt;

  JobApplicationModel({
    required this.id,

    required this.status,
    required this.isWithdrawn,

    required this.appliedOn,
    this.resumeViewedOn,
    this.demoDate,

    this.shortlistedOn,
    this.appointedOn,
    this.confirmedOn,
    this.rejectedOn,
    this.withdrawnOn,

    this.followUpStatus,

    required this.jobMongoId,
    required this.jobId,
    required this.jobTitle,

    required this.tutorId,
    required this.tutorCustomId,
    this.tutorAddress,

    required this.userId,
    required this.userName,
    this.userPhoneNumber,
    this.userCity,
    this.userArea,

    this.createdAt,
    this.updatedAt,
  });

  factory JobApplicationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return JobApplicationModel(
      // ==========================================================
      // APPLICATION
      // ==========================================================

      id: json['_id']?.toString() ?? "",

      status: json['status']?.toString() ?? "",

      isWithdrawn: json['isWithdrawn'] == true,

      appliedOn: json['appliedOn']?.toString() ?? "",

      resumeViewedOn: json['resumeViewedOn']?.toString(),

      demoDate: json['demoDate']?.toString(),

      shortlistedOn: json['shortlistedOn']?.toString(),

      appointedOn: json['appointedOn']?.toString(),

      confirmedOn: json['confirmedOn']?.toString(),

      rejectedOn: json['rejectedOn']?.toString(),

      withdrawnOn: json['withdrawnOn']?.toString(),

      followUpStatus: json['followUpStatus']?.toString(),

      // ==========================================================
      // JOB
      // ==========================================================

      jobMongoId: json['jobMongoId']?.toString() ?? "",

      jobId: json['jobId']?.toString() ?? "",

      jobTitle: json['jobTitle']?.toString() ?? "",

      // ==========================================================
      // TUTOR
      // ==========================================================

      tutorId: json['tutorId']?.toString() ?? "",

      tutorCustomId: json['tutorCustomId']?.toString() ?? "",

      tutorAddress: json['tutorAddress']?.toString(),

      // ==========================================================
      // USER
      // ==========================================================

      userId: json['userId']?.toString() ?? "",

      userName: json['userName']?.toString() ?? "",

      userPhoneNumber: json['userPhoneNumber']?.toString(),

      userCity: json['userCity']?.toString(),

      userArea: json['userArea']?.toString(),

      // ==========================================================
      // TIMESTAMPS
      // ==========================================================

      createdAt: json['createdAt']?.toString(),

      updatedAt: json['updatedAt']?.toString(),
    );
  }
}