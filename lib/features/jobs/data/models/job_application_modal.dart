class JobApplicationModel {
  final String id;
  final String tutorCustomId;
  final String status;
  final bool isWithdrawn;

  final String jobTitle;
  final String userName;

  final String appliedOn;
  final String? demoDate;
  final String? resumeViewedOn;

  /// 🔥 NEW STATUS DATES
  final String? shortlistedOn;
  final String? appointedOn;
  final String? confirmedOn;
  final String? rejectedOn;
  final String? withdrawnOn;

  /// 🔥 EXTRA USER INFO
  final String? tutorAddress;
  final String? userPhoneNumber;
  final String? userCity;
  final String? userArea;

  JobApplicationModel({
    required this.id,
    required this.tutorCustomId,
    required this.status,
    required this.isWithdrawn,
    required this.jobTitle,
    required this.userName,
    required this.appliedOn,
    this.demoDate,
    this.resumeViewedOn,

    /// NEW
    this.shortlistedOn,
    this.appointedOn,
    this.confirmedOn,
    this.rejectedOn,
    this.withdrawnOn,

    this.tutorAddress,
    this.userPhoneNumber,
    this.userCity,
    this.userArea,
  });

  factory JobApplicationModel.fromJson(Map<String, dynamic> json) {
    return JobApplicationModel(
      id: json['_id'] ?? "",
      tutorCustomId: json['tutorCustomId'] ?? "",
      status: json['status'] ?? "",
      isWithdrawn: json['isWithdrawn'] ?? false,
      jobTitle: json['jobTitle'] ?? '',
      userName: json['userName'] ?? '',
      appliedOn: json['appliedOn'] ?? '',
      demoDate: json['demoDate'],
      resumeViewedOn: json['resumeViewedOn'],

      /// 🔥 NEW MAPPING
      shortlistedOn: json['shortlistedOn'],
      appointedOn: json['appointedOn'],
      confirmedOn: json['confirmedOn'],
      rejectedOn: json['rejectedOn'],
      withdrawnOn: json['withdrawnOn'],

      tutorAddress: json['tutorAddress'],
      userPhoneNumber: json['userPhoneNumber'],
      userCity: json['userCity'],
      userArea: json['userArea'],
    );
  }
}