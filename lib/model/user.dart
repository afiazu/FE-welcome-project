class UserModel {
  final int userId;
  final String username;
  final String userEmail;
  final String? profileImageUrl;
  final String password;
  final String createdAt;
  final String updatedAt;
  final String? userBio;

  UserModel({
    required this.userId,
    required this.username,
    required this.userEmail,
    this.profileImageUrl,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
    this.userBio,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] ?? json['id'] ?? 0,
      username: json['user_name'] ?? json['username'] ?? '',
      userEmail: json['user_email'] ?? json['email'] ?? '',
      profileImageUrl: json['profile_image_url'] ?? json['profileImageUrl'] ?? '',
      password: json['password'] ?? json['user_password'] ?? '',
      createdAt: json['created_at'] ?? json['createdAt'] ?? '',
      updatedAt: json['updated_at'] ?? json['updatedAt'] ?? '',
      userBio: json['user_bio'],
    );
  }
}
