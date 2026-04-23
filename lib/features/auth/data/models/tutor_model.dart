class TutorProfileModel {
  final String id;
  final String tutorId;

  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  final String gender;
  final String city;
  final String area;

  final String profileStatus;
  final bool isVerified;
  final int profileCompleted;
  final double rating;

  final bool hasConfirmedAnyJob;
  final bool hasRequestedToVerify;
  final bool hasAppliedForUnlock;
  final String? unlockRequestReason;
  final bool hasPlatformChargeGiven;
  final bool tutorOfTheMonth;

  final String? imageUrl;

  final PersonalInfo personalInfo;
  final SocialMedia socialMedia; // 🔥 ADDED
  final TuitionPreference tuitionPreference;
  final Experience experience;
  final List<Education> education;
  final List<Identity> identity;
  final EmergencyInfo emergencyInfo;

  TutorProfileModel({
    required this.id,
    required this.tutorId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.gender,
    required this.city,
    required this.area,
    required this.profileStatus,
    required this.isVerified,
    required this.profileCompleted,
    required this.rating,
    required this.hasConfirmedAnyJob,
    required this.hasRequestedToVerify,
    required this.hasAppliedForUnlock,
    required this.unlockRequestReason,
    required this.hasPlatformChargeGiven,
    required this.tutorOfTheMonth,
    this.imageUrl,
    required this.personalInfo,
    required this.socialMedia,
    required this.tuitionPreference,
    required this.experience,
    required this.education,
    required this.identity,
    required this.emergencyInfo,
  });

  factory TutorProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final user = data['userId'] ?? {};

    return TutorProfileModel(
      id: data['_id'] ?? "",
      tutorId: data['tutorId'] ?? "",

      name: user['name'] ?? "",
      email: user['email'] ?? "",
      phoneNumber: user['phoneNumber'] ?? "",
      role: user['role'] ?? "",
      gender: user['gender'] ?? "",
      city: user['city'] ?? "",
      area: user['area'] ?? "",

      profileStatus: data['profileStatus'] ?? "unlocked",
      isVerified: data['isVerified'] ?? false,
      profileCompleted: data['profileCompleted'] ?? 0,
      rating: (data['rating'] ?? 0).toDouble(),

      hasConfirmedAnyJob: data['hasConfirmedAnyJob'] ?? false,
      hasRequestedToVerify: data['hasRequestedToVerify'] ?? false,
      hasAppliedForUnlock: data['hasAppliedForUnlock'] ?? false,
      unlockRequestReason: data['unlockRequestReason'],
      hasPlatformChargeGiven: data['hasPlatformChargeGiven'] ?? false,
      tutorOfTheMonth: data['tutorOfTheMonth'] ?? false,

      imageUrl: data['imageUrl'],

      personalInfo: PersonalInfo.fromJson(data['personalInformation'] ?? {}),
      socialMedia: SocialMedia.fromJson(data['socialMediaInformation'] ?? {}), // 🔥
      tuitionPreference:
          TuitionPreference.fromJson(data['tuitionPreference'] ?? {}),
      experience: Experience.fromJson(data['experience'] ?? {}),

      education: (data['educationalInformation'] as List? ?? [])
          .map((e) => Education.fromJson(e))
          .toList(),

      identity: (data['identityInformation'] as List? ?? [])
          .map((e) => Identity.fromJson(e))
          .toList(),

      emergencyInfo:
          EmergencyInfo.fromJson(data['emergencyInformation'] ?? {}),
    );
  }
}

class PersonalInfo {
  final String? additionalPhone;
  final String? address;
  final String? dateOfBirth;
  final String? religion;
  final String? overview;
  final String? fatherPhoneNumber;

  PersonalInfo({
    this.additionalPhone,
    this.address,
    this.dateOfBirth,
    this.religion,
    this.overview,
    this.fatherPhoneNumber,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      additionalPhone: json['additionalPhoneNumber'],
      address: json['address'],
      dateOfBirth: json['dateOfBirth'],
      religion: json['religion'],
      overview: json['overview'],
      fatherPhoneNumber: json['fatherPhoneNumber'],
    );
  }
}

class SocialMedia {
  final String? facebook;

  SocialMedia({this.facebook});

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      facebook: json['facebook'],
    );
  }
}

class TuitionPreference {
  final List<String> tuitionStyle;
  final List<String> availableDays;
  final List<String> preferredSubjects;

  TuitionPreference({
    required this.tuitionStyle,
    required this.availableDays,
    required this.preferredSubjects,
  });

  factory TuitionPreference.fromJson(Map<String, dynamic> json) {
    return TuitionPreference(
      tuitionStyle: List<String>.from(json['tuitionStyle'] ?? []),
      availableDays: List<String>.from(json['availableDays'] ?? []),
      preferredSubjects: List<String>.from(json['preferredSubjects'] ?? []),
    );
  }
}

class Experience {
  final String? totalExperience;
  final String? details;

  Experience({this.totalExperience, this.details});

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      totalExperience: json['totalExperience'],
      details: json['experienceDetails'],
    );
  }
}

class Education {
  final String level;
  final String degree;
  final String institute;

  Education({
    required this.level,
    required this.degree,
    required this.institute,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      level: json['levelOfEducation'] ?? "",
      degree: json['degree'] ?? "",
      institute: json['instituteName'] ?? "",
    );
  }
}

class Identity {
  final String fileType;
  final String fileUrl;

  Identity({
    required this.fileType,
    required this.fileUrl,
  });

  factory Identity.fromJson(Map<String, dynamic> json) {
    return Identity(
      fileType: json['fileType'] ?? "",
      fileUrl: json['file'] ?? "",
    );
  }
}

class EmergencyInfo {
  final String? name;
  final String? phone;
  final String? relation;

  EmergencyInfo({this.name, this.phone, this.relation});

  factory EmergencyInfo.fromJson(Map<String, dynamic> json) {
    return EmergencyInfo(
      name: json['emergencyContactPersonName'],
      phone: json['phoneNumber'],
      relation: json['relation'],
    );
  }
}