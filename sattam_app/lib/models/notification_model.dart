class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;
  final String type; // 'document_ready', 'system_alert', 'case_update'

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.type,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['created_at'] as String).toLocal(),
      isRead: json['is_read'] as bool? ?? false,
      type: json['type'] as String? ?? 'system_alert',
    );
  }
}
