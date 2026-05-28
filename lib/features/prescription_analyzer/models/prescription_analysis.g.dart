// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExtractedMedicineImpl _$$ExtractedMedicineImplFromJson(
        Map<String, dynamic> json) =>
    _$ExtractedMedicineImpl(
      name: json['name'] as String,
      brandName: json['brandName'] as String?,
      dosageAmount: json['dosageAmount'] as String,
      timesPerDay: (json['timesPerDay'] as num).toInt(),
      durationDays: (json['durationDays'] as num?)?.toInt(),
      category: $enumDecode(_$DrugCategoryEnumMap, json['category']),
      confidence: (json['confidence'] as num).toDouble(),
      isConfirmed: json['isConfirmed'] as bool? ?? false,
    );

Map<String, dynamic> _$$ExtractedMedicineImplToJson(
        _$ExtractedMedicineImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'brandName': instance.brandName,
      'dosageAmount': instance.dosageAmount,
      'timesPerDay': instance.timesPerDay,
      'durationDays': instance.durationDays,
      'category': _$DrugCategoryEnumMap[instance.category]!,
      'confidence': instance.confidence,
      'isConfirmed': instance.isConfirmed,
    };

const _$DrugCategoryEnumMap = {
  DrugCategory.tablet: 'tablet',
  DrugCategory.capsule: 'capsule',
  DrugCategory.syrup: 'syrup',
  DrugCategory.injection: 'injection',
  DrugCategory.drops: 'drops',
  DrugCategory.cream: 'cream',
  DrugCategory.inhaler: 'inhaler',
  DrugCategory.other: 'other',
};

_$DrugInteractionImpl _$$DrugInteractionImplFromJson(
        Map<String, dynamic> json) =>
    _$DrugInteractionImpl(
      medicineA: json['medicineA'] as String,
      medicineB: json['medicineB'] as String,
      severity: $enumDecode(_$InteractionSeverityEnumMap, json['severity']),
      description: json['description'] as String,
    );

Map<String, dynamic> _$$DrugInteractionImplToJson(
        _$DrugInteractionImpl instance) =>
    <String, dynamic>{
      'medicineA': instance.medicineA,
      'medicineB': instance.medicineB,
      'severity': _$InteractionSeverityEnumMap[instance.severity]!,
      'description': instance.description,
    };

const _$InteractionSeverityEnumMap = {
  InteractionSeverity.mild: 'mild',
  InteractionSeverity.moderate: 'moderate',
  InteractionSeverity.severe: 'severe',
};

_$PrescriptionAnalysisResultImpl _$$PrescriptionAnalysisResultImplFromJson(
        Map<String, dynamic> json) =>
    _$PrescriptionAnalysisResultImpl(
      medicines: (json['medicines'] as List<dynamic>)
          .map((e) => ExtractedMedicine.fromJson(e as Map<String, dynamic>))
          .toList(),
      interactions: (json['interactions'] as List<dynamic>)
          .map((e) => DrugInteraction.fromJson(e as Map<String, dynamic>))
          .toList(),
      warnings:
          (json['warnings'] as List<dynamic>).map((e) => e as String).toList(),
      doctorName: json['doctorName'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$PrescriptionAnalysisResultImplToJson(
        _$PrescriptionAnalysisResultImpl instance) =>
    <String, dynamic>{
      'medicines': instance.medicines,
      'interactions': instance.interactions,
      'warnings': instance.warnings,
      'doctorName': instance.doctorName,
      'date': instance.date?.toIso8601String(),
    };
