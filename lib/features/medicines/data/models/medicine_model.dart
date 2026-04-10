import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/medicine_entity.dart';
import '../../../../core/utils/expiry_risk_engine.dart';

/// Firestore DTO for Medicine
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
  });

  factory MedicineModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MedicineModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      category: data['category'] ?? 'Other',
      expiryDate: (data['expiryDate'] as Timestamp).toDate(),
      manufacturingDate: data['manufacturingDate'] != null
          ? (data['manufacturingDate'] as Timestamp).toDate()
          : null,
      shelfLifeMonths: data['shelfLifeMonths'],
      imageUrl: data['imageUrl'],
      ocrConfidence: (data['ocrConfidence'] ?? 0.0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastNotifiedAt: data['lastNotifiedAt'] != null
          ? (data['lastNotifiedAt'] as Timestamp).toDate()
          : null,
      notificationEnabled: data['notificationEnabled'] ?? true,
      batchNumber: data['batchNumber'],
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toFirestore() => {
    'userId': userId,
    'name': name,
    'category': category,
    'expiryDate': Timestamp.fromDate(expiryDate),
    'manufacturingDate': manufacturingDate != null
        ? Timestamp.fromDate(manufacturingDate!)
        : null,
    'shelfLifeMonths': shelfLifeMonths,
    'status': ExpiryRiskEngine.classify(expiryDate).name,
    'imageUrl': imageUrl,
    'ocrConfidence': ocrConfidence,
    'createdAt': Timestamp.fromDate(createdAt),
    'lastNotifiedAt': lastNotifiedAt != null
        ? Timestamp.fromDate(lastNotifiedAt!)
        : null,
    'notificationEnabled': notificationEnabled,
    'batchNumber': batchNumber,
    'notes': notes,
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
  );
}
