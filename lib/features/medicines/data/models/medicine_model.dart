import '../../domain/entities/medicine_entity.dart';
import '../../../../core/utils/expiry_risk_engine.dart';

/// DTO for Medicine (Supabase compatible)
class MedicineModel {
  final String id;
  final String userId;
  final String name;
  final String category;
  final DateTime expiryDate;
  final DateTime? manufacturingDate;
  final int? shelfLifeMonths;
  final String? imageUrl;
  final double ocrConfidence;
  final DateTime createdAt;
  final DateTime? lastNotifiedAt;
  final bool notificationEnabled;
  final String? batchNumber;
  final String? notes;
  // ── Dosage / Schedule ─────────────────────────────────────────
  final String? dosageAmount;
  final int timesPerDay;
  final List<String> scheduledTimes;
  final bool reminderEnabled;

  const MedicineModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.expiryDate,
    this.manufacturingDate,
    this.shelfLifeMonths,
    this.imageUrl,
    this.ocrConfidence = 0.0,
    required this.createdAt,
    this.lastNotifiedAt,
    this.notificationEnabled = true,
    this.batchNumber,
    this.notes,
    this.dosageAmount,
    this.timesPerDay = 1,
    this.scheduledTimes = const [],
    this.reminderEnabled = true,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedTimes = [];
    if (json['scheduled_times'] != null) {
      final raw = json['scheduled_times'];
      if (raw is List) {
        parsedTimes = raw.map((e) => e.toString()).toList();
      }
    }

    return MedicineModel(
      id: json['id'] as String,
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? 'Other',
      expiryDate: DateTime.parse(json['expiry_date'] as String),
      manufacturingDate: json['manufacturing_date'] != null
          ? DateTime.parse(json['manufacturing_date'] as String)
          : null,
      shelfLifeMonths: json['shelf_life_months'] as int?,
      imageUrl: json['image_url'] as String?,
      ocrConfidence: (json['ocr_confidence'] ?? 0.0).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      lastNotifiedAt: json['last_notified_at'] != null
          ? DateTime.parse(json['last_notified_at'] as String)
          : null,
      notificationEnabled: json['notification_enabled'] ?? true,
      batchNumber: json['batch_number'] as String?,
      notes: json['notes'] as String?,
      dosageAmount: json['dosage_amount'] as String?,
      timesPerDay: json['times_per_day'] as int? ?? 1,
      scheduledTimes: parsedTimes,
      reminderEnabled: json['reminder_enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'name': name,
    'category': category,
    'expiry_date': expiryDate.toIso8601String(),
    'manufacturing_date': manufacturingDate?.toIso8601String(),
    'shelf_life_months': shelfLifeMonths,
    'status': ExpiryRiskEngine.classify(expiryDate).name,
    'image_url': imageUrl,
    'ocr_confidence': ocrConfidence,
    'created_at': createdAt.toIso8601String(),
    'last_notified_at': lastNotifiedAt?.toIso8601String(),
    'notification_enabled': notificationEnabled,
    'batch_number': batchNumber,
    'notes': notes,
    'dosage_amount': dosageAmount,
    'times_per_day': timesPerDay,
    'scheduled_times': scheduledTimes,
    'reminder_enabled': reminderEnabled,
  };

  MedicineEntity toEntity() => MedicineEntity(
    id: id,
    userId: userId,
    name: name,
    category: category,
    expiryDate: expiryDate,
    manufacturingDate: manufacturingDate,
    shelfLifeMonths: shelfLifeMonths,
    status: ExpiryRiskEngine.classify(expiryDate),
    imageUrl: imageUrl,
    ocrConfidence: ocrConfidence,
    createdAt: createdAt,
    lastNotifiedAt: lastNotifiedAt,
    notificationEnabled: notificationEnabled,
    batchNumber: batchNumber,
    notes: notes,
    dosageAmount: dosageAmount,
    timesPerDay: timesPerDay,
    scheduledTimes: scheduledTimes,
    reminderEnabled: reminderEnabled,
  );

  factory MedicineModel.fromEntity(MedicineEntity entity) => MedicineModel(
    id: entity.id,
    userId: entity.userId,
    name: entity.name,
    category: entity.category,
    expiryDate: entity.expiryDate,
    manufacturingDate: entity.manufacturingDate,
    shelfLifeMonths: entity.shelfLifeMonths,
    imageUrl: entity.imageUrl,
    ocrConfidence: entity.ocrConfidence,
    createdAt: entity.createdAt,
    lastNotifiedAt: entity.lastNotifiedAt,
    notificationEnabled: entity.notificationEnabled,
    batchNumber: entity.batchNumber,
    notes: entity.notes,
    dosageAmount: entity.dosageAmount,
    timesPerDay: entity.timesPerDay,
    scheduledTimes: entity.scheduledTimes,
    reminderEnabled: entity.reminderEnabled,
  );
}
