class UserModel {

  final String id;
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  final String? profilePicture;
  final String createdAt;
  final String roleBasedId;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.profilePicture,
    required this.createdAt,
    required this.roleBasedId,
    required this.isVerified,
  });

  // FROM JSON (API → App)
  factory UserModel.fromJson(Map<String, dynamic> json) {

    return UserModel(
      id: json["_id"] ?? "",
      userId: json["userId"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      role: json["role"] ?? "",
      profilePicture: json["profilePicture"],
      createdAt: json["createdAt"] ?? "",
      roleBasedId: json["roleBasedId"] ?? "",
      isVerified: json["isVerified"] ?? false,
    );

  }

  // TO JSON (App → Storage)
  Map<String, dynamic> toJson() {

    return {
      "_id": id,
      "userId": userId,
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "role": role,
      "profilePicture": profilePicture,
      "createdAt": createdAt,
      "roleBasedId": roleBasedId,
      "isVerified": isVerified,
    };

  }

}