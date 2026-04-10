import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

/// Firestore DTO for user data
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

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      notificationPreferences: data['notificationPreferences'] != null
          ? NotificationPreferences.fromMap(data['notificationPreferences'])
          : const NotificationPreferences(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'email': email,
    'name': name,
    'photoUrl': photoUrl,
    'createdAt': Timestamp.fromDate(createdAt),
    'notificationPreferences': notificationPreferences.toMap(),
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
