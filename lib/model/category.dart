class Category {
  final int categoryId;
  final String categoryName;
  final String createdAt;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'created_at': createdAt,
    };
  }
}