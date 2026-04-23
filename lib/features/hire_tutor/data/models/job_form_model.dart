class JobFormModel {
  /// STEP 1
  String? tuitionType;
  String? category;
  String? curriculum; // ✅ ADD THIS

  List<String> classes = [];
  List<String> subjects = [];

  String? tutoringDays;
  String? tutoringTime;
  String? salary;

  /// STEP 2
  String? studentGender;
  String? preferredTutorGender;
  String? numberOfStudents;
  String? instituteName;
  String? otherRequirements;

  /// STEP 3
  String? city;
  String? area;
  String? address;
  String? locationDirection;

  /// STEP 4
  String? guardianName;
  String? guardianPhone;

  Map<String, dynamic> toApi() {
    return {
      "tuitionType": tuitionType,
      "category": category,

      /// 🔥 IMPORTANT: SEND ONLY IF EXISTS
      if (curriculum != null && curriculum!.isNotEmpty)
        "curriculum": curriculum,

      "class": classes,
      "subjects": subjects,
      "tutoringDays": tutoringDays,
      "tutoringTime": tutoringTime,
      "salary": salary,

      "studentGender": studentGender,
      "preferredTutorGender": preferredTutorGender,
      "numberOfStudents": numberOfStudents,
      "studentsInstituteName": instituteName,
      "otherRequirements": otherRequirements,

      "city": city,
      "area": area,
      "address": address,
      "locationDirection": locationDirection,

      "guardianName": guardianName,
      "guardianPhoneNumber": guardianPhone,
    };
  }
}