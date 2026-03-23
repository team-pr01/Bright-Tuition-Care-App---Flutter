class AddLeadResponse {
  final bool success;
  final String message;

  AddLeadResponse({
    required this.success,
    required this.message,
  });

  factory AddLeadResponse.fromJson(Map<String, dynamic> json) {
    return AddLeadResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}