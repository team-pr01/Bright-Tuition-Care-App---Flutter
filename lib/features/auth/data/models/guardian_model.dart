class GuardianProfileModel {
  final String id;
  final String guardianId;

  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  final String gender;
  final String city;
  final String area;

  final String profileStatus;
  final bool isVerified;
  final bool hasPlatformChargeGiven;
  final bool guardianOfTheMonth;
  final bool hasAppliedForUnlock;
  final bool hasRequestedToVerify;
  final String unlockRequestReason;
  final int profileCompleted;

  final double rating;
  final bool hasPostedAnyJob;

  /// Personal Info
  final String? additionalPhone;
  final String? dateOfBirth;
  final String? address;
  final String? religion;
  final String? nationality;

  /// Social
  final String? facebook;

  /// Emergency
  final String? emergencyName;
  final String? emergencyPhone;
  final String? emergencyAddress;
  final String? emergencyRelation;

  GuardianProfileModel({
    required this.id,
    required this.guardianId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.gender,
    required this.city,
    required this.area,
    required this.profileStatus,
    required this.isVerified,
    required this.hasPlatformChargeGiven,
    required this.guardianOfTheMonth,
    required this.hasAppliedForUnlock,
    required this.unlockRequestReason,
    required this.profileCompleted,
    required this.hasRequestedToVerify,
    required this.rating,
    required this.hasPostedAnyJob,
    this.additionalPhone,
    this.dateOfBirth,
    this.address,
    this.religion,
    this.nationality,
    this.facebook,
    this.emergencyName,
    this.emergencyPhone,
    this.emergencyAddress,
    this.emergencyRelation,
  });

  factory GuardianProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final user = data['userId'] ?? {};
    final personal = data['personalInformation'] ?? {};
    final social = data['socialMediaInformation'] ?? {};
    final emergency = data['emergencyInformation'] ?? {};

    return GuardianProfileModel(
      id: data['_id'] ?? "",
      guardianId: data['guardianId'] ?? "",

      name: user['name'] ?? "",
      email: user['email'] ?? "",
      phoneNumber: user['phoneNumber'] ?? "",
      role: user['role'] ?? "",
      gender: user['gender'] ?? "",
      city: user['city'] ?? "",
      area: user['area'] ?? "",

      profileStatus: data['profileStatus'] ?? "unlocked",
      isVerified: data['isVerified'] ?? false,
      hasPlatformChargeGiven: data['hasPlatformChargeGiven'] ?? false,
      guardianOfTheMonth: data['guardianOfTheMonth'] ?? false,
      hasAppliedForUnlock: data['hasAppliedForUnlock'] ?? false,
      profileCompleted: data['profileCompleted'] ?? 0,
      hasRequestedToVerify: data['hasRequestedToVerify'] ?? 0,
      unlockRequestReason: data['unlockRequestReason'] ?? "",


      rating: (data['rating'] ?? 0).toDouble(),
      hasPostedAnyJob: data['hasPostedAnyJob'] ?? false,

      additionalPhone: personal['additionalPhoneNumber'],
      dateOfBirth: personal['dateOfBirth'],
      address: personal['address'],
      religion: personal['religion'],
      nationality: personal['nationality'],

      facebook: social['facebook'],

      emergencyName: emergency['emergencyContactPersonName'],
      emergencyPhone: emergency['phoneNumber'],
      emergencyAddress: emergency['address'],
      emergencyRelation: emergency['relation'],
    );
  }
}