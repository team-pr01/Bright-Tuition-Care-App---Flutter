class PromotionModel {
  final String id;
  final String imageUrl;
  final String? title;
  final String? buttonText;
  final String? buttonLink;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PromotionModel({
    required this.id,
    required this.imageUrl,
    this.title,
    this.buttonText,
    this.buttonLink,
    this.createdAt,
    this.updatedAt,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['_id']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      title: json['title']?.toString(),
      buttonText: json['buttonText']?.toString(),
      buttonLink: json['buttonLink']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'imageUrl': imageUrl,
      'title': title,
      'buttonText': buttonText,
      'buttonLink': buttonLink,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}