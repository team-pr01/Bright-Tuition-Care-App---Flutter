class TestimonialModel {
  final String id;
  final String name;
  final String image;
  final String designation;
  final int rating;
  final String role;
  final String review;

  TestimonialModel({
    required this.id,
    required this.name,
    required this.image,
    required this.designation,
    required this.rating,
    required this.role,
    required this.review,
  });

  factory TestimonialModel.fromJson(Map<String, dynamic> json) {
    return TestimonialModel(
      id: json["_id"],
      name: json["name"] ?? "",
      image: json["imageUrl"] ?? "",
      designation: json["designation"] ?? "",
      rating: json["rating"] ?? 0,
      role: json["role"] ?? "",
      review: json["review"] ?? "",
    );
  }
}