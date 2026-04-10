import 'package:equatable/equatable.dart';
import 'package:medtrack/core/utils/expiry_risk_engine.dart';

/// Core domain entity for a medicine record
class MedicineEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String category;
  final DateTime expiryDate;
  final DateTime? manufacturingDate;
  final int? shelfLifeMonths;
  final ExpiryStatus status;
  final String? imageUrl;
  final double ocrConfidence;
  final DateTime createdAt;
  final DateTime? lastNotifiedAt;
  final bool notificationEnabled;
  final String? batchNumber;
  final String? notes;

  const MedicineEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.expiryDate,
    this.manufacturingDate,
    this.shelfLifeMonths,
    required this.status,
    this.imageUrl,
    this.ocrConfidence = 0.0,
    required this.createdAt,
    this.lastNotifiedAt,
    this.notificationEnabled = true,
    this.batchNumber,
    this.notes,
  });

  int get daysUntilExpiry => expiryDate.difference(DateTime.now()).inDays;
  bool get isExpired => expiryDate.isBefore(DateTime.now());

  MedicineEntity copyWith({
    String? name,
    String? category,
    DateTime? expiryDate,
    DateTime? manufacturingDate,
    int? shelfLifeMonths,
    ExpiryStatus? status,
    String? imageUrl,
    double? ocrConfidence,
    bool? notificationEnabled,
    String? batchNumber,
    String? notes,
    DateTime? lastNotifiedAt,
  }) {
    return MedicineEntity(
      id: id,
      userId: userId,
      name: name ?? this.name,
      category: category ?? this.category,
      expiryDate: expiryDate ?? this.expiryDate,
      manufacturingDate: manufacturingDate ?? this.manufacturingDate,
      shelfLifeMonths: shelfLifeMonths ?? this.shelfLifeMonths,
      status: status ?? ExpiryRiskEngine.classify(expiryDate ?? this.expiryDate),
      imageUrl: imageUrl ?? this.imageUrl,
      ocrConfidence: ocrConfidence ?? this.ocrConfidence,
      createdAt: createdAt,
      lastNotifiedAt: lastNotifiedAt ?? this.lastNotifiedAt,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      batchNumber: batchNumber ?? this.batchNumber,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, userId, name, expiryDate, status];
}

/// Available medicine categories
class MedicineCategories {
  static const List<String> all = [
    'Tablet / Capsule',
    'Syrup / Liquid',
    'Injection / Vial',
    'Ointment / Cream',
    'Drops (Eye/Ear/Nasal)',
    'Inhaler / Spray',
    'Patch / Gel',
    'Supplement / Vitamin',
    'Vaccine',
    'Other',
  ];
}
