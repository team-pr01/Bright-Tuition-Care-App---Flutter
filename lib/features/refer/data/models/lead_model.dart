class LeadModel {
  final String id;
  final String leadId;
  final String tutorId;

  final String guardianPhoneNumber;
  final String classes;
  final String address;
  final String details;

  final String status;

  final String? paymentMethod;
  final String? paymentAccountNumber;

  final String createdAt;
  final String updatedAt;

  final LeadUser user;

  const LeadModel({
    required this.id,
    required this.leadId,
    required this.tutorId,
    required this.guardianPhoneNumber,
    required this.classes,
    required this.address,
    required this.details,
    required this.status,
    this.paymentMethod,
    this.paymentAccountNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      id: json["_id"] ?? "",
      leadId: json["leadId"] ?? "",
      tutorId: json["tutorId"] ?? "",

      guardianPhoneNumber: json["guardianPhoneNumber"] ?? "",
      classes: json["class"] ?? "",
      address: json["address"] ?? "",
      details: json["details"] ?? "",

      status: json["status"] ?? "",

      paymentMethod: json["paymentMethod"],
      paymentAccountNumber: json["paymentAccountNumber"],

      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],

      user: LeadUser.fromJson(json["userId"] ?? {}),
    );
  }
}

class LeadUser {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;

  const LeadUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory LeadUser.fromJson(Map<String, dynamic> json) {
    return LeadUser(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
    );
  }
}