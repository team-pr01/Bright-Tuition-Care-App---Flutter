class EducationRequest {
  final String? levelOfEducation;
  final String? instituteName;
  final String? curriculum;
  final String? degree;

  final String? group;
  final String? board;

  final String? department;
  final String? semester;

  final String? result;
  final String? passingYear;

  final bool? isCurrentInstitute;

  const EducationRequest({
    this.levelOfEducation,
    this.instituteName,
    this.curriculum,
    this.degree,
    this.group,
    this.board,
    this.department,
    this.semester,
    this.result,
    this.passingYear,
    this.isCurrentInstitute,
  });

  Map<String, dynamic> toJson() {
    return {
      "levelOfEducation": levelOfEducation,
      "instituteName": instituteName,
      "curriculum": curriculum,
      "degree": degree,
      "group": group,
      "board": board,
      "department": department,
      "semester": semester,
      "result": result,
      "passingYear": passingYear,
      "isCurrentInstitute": isCurrentInstitute,
    }..removeWhere((key, value) => value == null);
  }

  factory EducationRequest.fromJson(Map<String, dynamic> json) {
    return EducationRequest(
      levelOfEducation: json["levelOfEducation"],
      instituteName: json["instituteName"],
      curriculum: json["curriculum"],
      degree: json["degree"],
      group: json["group"],
      board: json["board"],
      department: json["department"],
      semester: json["semester"]?.toString(),
      result: json["result"],
      passingYear: json["passingYear"]?.toString(),
      isCurrentInstitute: json["isCurrentInstitute"],
    );
  }

  EducationRequest copyWith({
    String? levelOfEducation,
    String? instituteName,
    String? curriculum,
    String? degree,
    String? group,
    String? board,
    String? department,
    String? semester,
    String? result,
    String? passingYear,
    bool? isCurrentInstitute,
  }) {
    return EducationRequest(
      levelOfEducation: levelOfEducation ?? this.levelOfEducation,
      instituteName: instituteName ?? this.instituteName,
      curriculum: curriculum ?? this.curriculum,
      degree: degree ?? this.degree,
      group: group ?? this.group,
      board: board ?? this.board,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      result: result ?? this.result,
      passingYear: passingYear ?? this.passingYear,
      isCurrentInstitute:
          isCurrentInstitute ?? this.isCurrentInstitute,
    );
  }
}