class AddLeadRequest {
  final String guardianPhoneNumber;
  final String address;
  final String details;
  final String classes;

  AddLeadRequest({
    required this.guardianPhoneNumber,
    required this.address,
    required this.details,
    required this.classes
  });

  Map<String, dynamic> toJson() {
    return {
      "guardianPhoneNumber": guardianPhoneNumber,
      "address": address,
      "details": details,
      "class":classes,
    };
  }
}