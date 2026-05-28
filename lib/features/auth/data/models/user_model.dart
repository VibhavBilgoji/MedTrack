import '../../domain/entities/user_entity.dart';

/// DTO for user data (Supabase compatible)
class UserModel {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final DateTime createdAt;
  final NotificationPreferences notificationPreferences;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.createdAt,
    this.notificationPreferences = const NotificationPreferences(),
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photo_url'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
      notificationPreferences: json['notification_preferences'] != null
          ? NotificationPreferences.fromMap(json['notification_preferences'] as Map<String, dynamic>)
          : const NotificationPreferences(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'photo_url': photoUrl,
    'created_at': createdAt.toIso8601String(),
    'notification_preferences': notificationPreferences.toMap(),
  };

  UserEntity toEntity() => UserEntity(
    id: id,
    email: email,
    name: name,
    photoUrl: photoUrl,
    createdAt: createdAt,
    notificationPreferences: notificationPreferences,
  );

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
    id: entity.id,
    email: entity.email,
    name: entity.name,
    photoUrl: entity.photoUrl,
    createdAt: entity.createdAt,
    notificationPreferences: entity.notificationPreferences,
  );
}
