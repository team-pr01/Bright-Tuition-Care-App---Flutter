class SignupRequest {

  final String name;
  final String email;
  final String phoneNumber;
  final String gender;
  final String role;
  final String city;
  final String area;
  final String password;

  const SignupRequest({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.role,
    required this.city,
    required this.area,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "gender": gender,
      "role": role,
      "city": city,
      "area": area,
      "password": password,
    };
  }

}