import 'package:btcclient/core/utils/date_formatter.dart';
import 'package:dio/dio.dart';

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

  String get totalExperience {
    return experience.totalExperience ?? "";
  }

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
      profileCompleted: (data['profileCompleted'] as num?)?.toInt() ?? 0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0,

      hasConfirmedAnyJob: data['hasConfirmedAnyJob'] ?? false,
      hasRequestedToVerify: data['hasRequestedToVerify'] ?? false,
      hasAppliedForUnlock: data['hasAppliedForUnlock'] ?? false,
      unlockRequestReason: data['unlockRequestReason'],
      hasPlatformChargeGiven: data['hasPlatformChargeGiven'] ?? false,
      tutorOfTheMonth: data['tutorOfTheMonth'] ?? false,

      imageUrl: (data['imageUrl'] as String?)?.trim().isNotEmpty == true
          ? data['imageUrl']
          : null,

      personalInfo: PersonalInfo.fromJson(data['personalInformation'] ?? {}),
      socialMedia: SocialMedia.fromJson(
        data['socialMediaInformation'] ?? {},
      ), // 🔥
      tuitionPreference: TuitionPreference.fromJson(
        data['tuitionPreference'] ?? {},
      ),
      experience: Experience.fromJson(
        data['experience'] is Map
            ? Map<String, dynamic>.from(data['experience'])
            : {},
      ),
      education: (data['educationalInformation'] as List? ?? [])
          .map((e) => Education.fromJson(e))
          .toList(),

      identity: (data['identityInformation'] as List? ?? [])
          .map((e) => Identity.fromJson(e))
          .toList(),

      emergencyInfo: EmergencyInfo.fromJson(data['emergencyInformation'] ?? {}),
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
  final String? fatherName;
  final String? motherName;
  final String? motherPhoneNumber;
  final String? emergencyContactNumber;

  PersonalInfo({
    this.additionalPhone,
    this.address,
    this.dateOfBirth,
    this.religion,
    this.overview,
    this.fatherPhoneNumber,
    this.fatherName,
    this.motherName,
    this.motherPhoneNumber,
    this.emergencyContactNumber,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      additionalPhone: json['additionalPhoneNumber'],
      address: json['address'],
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateFormatter.formattedFormalDate(json['dateOfBirth']),
      religion: json['religion'],
      overview: json['overview'],
      fatherPhoneNumber: json['fatherPhoneNumber'],
      fatherName: json['fatherName'],
      motherName: json['motherName'],
      motherPhoneNumber: json['motherPhoneNumber'],
      emergencyContactNumber: json['emergencyContactNumber'],
    );
  }
}

class SocialMedia {
  final String? facebook;

  SocialMedia({this.facebook});

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(facebook: json['facebook']);
  }
}

class TuitionPreference {
  String get subjects => preferredSubjects.join(", ");

  String get classes => preferredClasses.join(", ");

  String get cities => preferredCities.join(", ");

  String get locations => preferredLocations.join(", ");

  String get categories => preferredCategories.join(", ");

  String get teachingStyle => tuitionStyle.join(", ");

  String get tutoringPlaces => placeOfTuition.join(", ");

  final String? tutoringMethod;
  final List<String> tuitionStyle;
  // final List<String> availableDays;
  final List<String> preferredSubjects;
  final List<String> preferredCategories;
  final List<String> preferredClasses;
  final List<String> preferredCities;
  final List<String> preferredLocations;
  final List<String> placeOfTuition;
  final String expectedSalary;

  TuitionPreference({
    this.tutoringMethod,
    required this.tuitionStyle,
    // required this.availableDays,
    required this.preferredSubjects,
    required this.preferredCategories,
    required this.preferredClasses,
    required this.preferredCities,
    required this.preferredLocations,
    required this.placeOfTuition,
    required this.expectedSalary,
  });

  factory TuitionPreference.fromJson(Map<String, dynamic> json) {
    return TuitionPreference(
      tutoringMethod: json['tutoringMethod']?.toString(),
      // availableDays: List<String>.from(json['availableDays'] ?? []),
      preferredSubjects: List<String>.from(
        (json['preferredSubjects'] ?? []).whereType<String>(),
      ),
      tuitionStyle: List<String>.from(
        (json['tuitionStyle'] ?? []).whereType<String>(),
      ),

      preferredCategories: List<String>.from(
        (json['preferredCategories'] ?? []).whereType<String>(),
      ),

      preferredClasses: List<String>.from(
        (json['preferredClasses'] ?? []).whereType<String>(),
      ),

      preferredCities: List<String>.from(
        (json['preferredCities'] ?? []).whereType<String>(),
      ),

      preferredLocations: List<String>.from(
        (json['preferredLocations'] ?? []).whereType<String>(),
      ),

      placeOfTuition: List<String>.from(
        (json['placeOfTuition'] ?? []).whereType<String>(),
      ),

      expectedSalary: json['expectedSalary']?.toString() ?? "",
    );
  }
}

class Experience {
  final String? totalExperience;

  Experience({this.totalExperience});

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(totalExperience: json['totalExperience']);
  }
}

class Education {
  final String id; // <-- Add this

  final String level;
  final String degree;
  final String institute;
  final String? board;
  final String? curriculum;
  final String? group;
  final String? department;
  final String? semester;
  final String? result;
  final String? passingYear;
  final bool? isCurrentInstitute;

  Education({
    required this.id, // <-- Add this
    required this.level,
    required this.degree,
    required this.institute,
    this.board,
    this.curriculum,
    this.group,
    this.department,
    this.semester,
    this.result,
    this.passingYear,
    this.isCurrentInstitute,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['_id'] ?? "", // <-- Add this

      level: json['levelOfEducation'] ?? "",
      degree: json['degree'] ?? "",
      institute: json['instituteName'] ?? "",
      board: json['board'] ?? "",
      curriculum: json['curriculum'] ?? "",
      group: json['group'] ?? "",
      department: json['department'] ?? "",
      semester: json['semester']?.toString() ?? "",
      result: json['result'] ?? "",
      passingYear: json['passingYear']?.toString() ?? "",
      isCurrentInstitute: json['isCurrentInstitute'] ?? false,
    );
  }
}

class Identity {
  final String id;
  final String fileType;
  final String file;

  Identity({required this.id, required this.fileType, required this.file});

  factory Identity.fromJson(Map<String, dynamic> json) {
    return Identity(
      id: json['_id']?.toString() ?? "",
      fileType: json['fileType']?.toString() ?? "",
      file: json['file']?.toString() ?? "",
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
