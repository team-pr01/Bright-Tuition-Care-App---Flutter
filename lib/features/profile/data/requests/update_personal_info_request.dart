import 'dart:io';

class UpdatePersonalInfoRequest {
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final String? city;
  final String? area;
  final File? profileImage;

  final PersonalInformationRequest? personalInformation;

  final SocialMediaInformationRequest? socialMediaInformation;
  final EmergencyInformationRequest? emergencyInformation;

  UpdatePersonalInfoRequest({
    this.name,
    this.email,
    this.phoneNumber,
    this.gender,
    this.city,
    this.area,
    this.personalInformation,
    this.socialMediaInformation,
    this.emergencyInformation,
    this.profileImage,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "gender": gender,
      "city": city,
      "area": area,
      "personalInformation": personalInformation?.toJson(),
      "socialMediaInformation": socialMediaInformation?.toJson(),
      "emergencyInformation": emergencyInformation?.toJson(),
    };
  }
}

class PersonalInformationRequest {
  final String? additionalPhoneNumber;
  final String? dateOfBirth;
  final String? address;
  final String? religion;
  final String? nationality;
  final String? fatherName;
  final String? fatherPhoneNumber;
  final String? motherName;
  final String? motherPhoneNumber;
  final String? overview;
  final String? emergencyContactNumber;
   final String? homeDistrict;
  final String? bloodGroup;

  PersonalInformationRequest({
    this.additionalPhoneNumber,
    this.dateOfBirth,
    this.address,
    this.religion,
    this.nationality,
    this.fatherName,
    this.fatherPhoneNumber,
    this.motherName,
    this.motherPhoneNumber,
    this.overview,
    this.emergencyContactNumber,
    this.homeDistrict,
    this.bloodGroup,
  });

  Map<String, dynamic> toJson() {
    return {
      "additionalPhoneNumber": additionalPhoneNumber,
      "dateOfBirth": dateOfBirth,
      "address": address,
      "religion": religion,
      "nationality": nationality,
      "fatherName": fatherName,
      "fatherPhoneNumber": fatherPhoneNumber,
      "motherName": motherName,
      "motherPhoneNumber": motherPhoneNumber,
      "overview": overview,
      "emergencyContactNumber": emergencyContactNumber,
      "homeDistrict": homeDistrict,
      "bloodGroup": bloodGroup,
    };
  }
}

class SocialMediaInformationRequest {
  final String? facebook;

  const SocialMediaInformationRequest({this.facebook});

  Map<String, dynamic> toJson() {
    return {"facebook": facebook};
  }
}


class EmergencyInformationRequest {
  final String? emergencyContactPersonName;
  final String? phoneNumber;
  final String? relation;
  final String? address;

  const EmergencyInformationRequest({
    this.emergencyContactPersonName,
    this.phoneNumber,
    this.relation,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      "emergencyContactPersonName": emergencyContactPersonName,
      "phoneNumber": phoneNumber,
      "relation": relation,
      "address": address,
    };
  }
}