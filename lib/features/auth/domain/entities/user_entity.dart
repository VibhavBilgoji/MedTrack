import 'package:equatable/equatable.dart';

/// Domain entity representing an authenticated user
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final DateTime createdAt;
  final NotificationPreferences notificationPreferences;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.createdAt,
    this.notificationPreferences = const NotificationPreferences(),
  });

  @override
  List<Object?> get props => [id, email, name, photoUrl];

  UserEntity copyWith({
    String? name,
    String? photoUrl,
    NotificationPreferences? notificationPreferences,
  }) {
    return UserEntity(
      id: id,
      email: email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
    );
  }
}

class NotificationPreferences extends Equatable {
  final bool enabled;
  final bool notify30Days;
  final bool notify7Days;
  final bool notifyOnDay;
  final bool dailySummary;

  const NotificationPreferences({
    this.enabled = true,
    this.notify30Days = true,
    this.notify7Days = true,
    this.notifyOnDay = true,
    this.dailySummary = true,
  });

  @override
  List<Object> get props => [enabled, notify30Days, notify7Days, notifyOnDay, dailySummary];

  Map<String, dynamic> toMap() => {
    'enabled': enabled,
    'notify30Days': notify30Days,
    'notify7Days': notify7Days,
    'notifyOnDay': notifyOnDay,
    'dailySummary': dailySummary,
  };

  factory NotificationPreferences.fromMap(Map<String, dynamic> m) => NotificationPreferences(
    enabled: m['enabled'] ?? true,
    notify30Days: m['notify30Days'] ?? true,
    notify7Days: m['notify7Days'] ?? true,
    notifyOnDay: m['notifyOnDay'] ?? true,
    dailySummary: m['dailySummary'] ?? true,
  );
}
