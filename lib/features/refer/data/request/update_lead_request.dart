class UpdateLeadRequest {
  final String classes;
  final String guardianPhoneNumber;
  final String address;
  final String details;

  UpdateLeadRequest({
    required this.classes,
    required this.guardianPhoneNumber,
    required this.address,
    required this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      "class": classes,
      "guardianPhoneNumber": guardianPhoneNumber,
      "address": address,
      "details": details,
    };
  }
}