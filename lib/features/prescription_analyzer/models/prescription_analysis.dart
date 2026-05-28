import 'package:freezed_annotation/freezed_annotation.dart';

part 'prescription_analysis.freezed.dart';
part 'prescription_analysis.g.dart';

enum DrugCategory {
  tablet,
  capsule,
  syrup,
  injection,
  drops,
  cream,
  inhaler,
  other
}

enum InteractionSeverity { mild, moderate, severe }

@freezed
class ExtractedMedicine with _$ExtractedMedicine {
  const factory ExtractedMedicine({
    required String name,
    String? brandName,
    required String dosageAmount,
    required int timesPerDay,
    int? durationDays,
    required DrugCategory category,
    required double confidence,
    @Default(false) bool isConfirmed,
  }) = _ExtractedMedicine;

  factory ExtractedMedicine.fromJson(Map<String, dynamic> json) =>
      _$ExtractedMedicineFromJson(json);
}

@freezed
class DrugInteraction with _$DrugInteraction {
  const factory DrugInteraction({
    required String medicineA,
    required String medicineB,
    required InteractionSeverity severity,
    required String description,
  }) = _DrugInteraction;

  factory DrugInteraction.fromJson(Map<String, dynamic> json) =>
      _$DrugInteractionFromJson(json);
}

@freezed
class PrescriptionAnalysisResult with _$PrescriptionAnalysisResult {
  const factory PrescriptionAnalysisResult({
    required List<ExtractedMedicine> medicines,
    required List<DrugInteraction> interactions,
    required List<String> warnings,
    String? doctorName,
    DateTime? date,
  }) = _PrescriptionAnalysisResult;

  factory PrescriptionAnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionAnalysisResultFromJson(json);
}
