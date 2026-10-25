class UserCase {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String status;
  final DateTime? nextHearingDate;
  final DateTime createdAt;

  UserCase({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.status,
    this.nextHearingDate,
    required this.createdAt,
  });

  factory UserCase.fromJson(Map<String, dynamic> json) {
    return UserCase(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      nextHearingDate: json['next_hearing_date'] != null 
          ? DateTime.parse(json['next_hearing_date'] as String) 
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'status': status,
      'next_hearing_date': nextHearingDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
