class ActivityModel {
  final String activityId;
  final String userId;
  final String activityType;
  final String createdAt;

  ActivityModel({
    required this.activityId,
    required this.userId,
    required this.activityType,
    required this.createdAt,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      activityId: (json['activity_id'] ?? json['id'] ?? '').toString(),
      userId: (json['user_id'] ?? '').toString(),
      activityType: (json['activity_type'] ?? '').toString(),
      createdAt: (json['created_at'] ?? '').toString(),
    );
  }
}