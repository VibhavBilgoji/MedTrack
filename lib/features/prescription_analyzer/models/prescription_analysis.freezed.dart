// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prescription_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExtractedMedicine _$ExtractedMedicineFromJson(Map<String, dynamic> json) {
  return _ExtractedMedicine.fromJson(json);
}

/// @nodoc
mixin _$ExtractedMedicine {
  String get name => throw _privateConstructorUsedError;
  String? get brandName => throw _privateConstructorUsedError;
  String get dosageAmount => throw _privateConstructorUsedError;
  int get timesPerDay => throw _privateConstructorUsedError;
  int? get durationDays => throw _privateConstructorUsedError;
  DrugCategory get category => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  bool get isConfirmed => throw _privateConstructorUsedError;

  /// Serializes this ExtractedMedicine to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExtractedMedicine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExtractedMedicineCopyWith<ExtractedMedicine> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExtractedMedicineCopyWith<$Res> {
  factory $ExtractedMedicineCopyWith(
          ExtractedMedicine value, $Res Function(ExtractedMedicine) then) =
      _$ExtractedMedicineCopyWithImpl<$Res, ExtractedMedicine>;
  @useResult
  $Res call(
      {String name,
      String? brandName,
      String dosageAmount,
      int timesPerDay,
      int? durationDays,
      DrugCategory category,
      double confidence,
      bool isConfirmed});
}

/// @nodoc
class _$ExtractedMedicineCopyWithImpl<$Res, $Val extends ExtractedMedicine>
    implements $ExtractedMedicineCopyWith<$Res> {
  _$ExtractedMedicineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExtractedMedicine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? brandName = freezed,
    Object? dosageAmount = null,
    Object? timesPerDay = null,
    Object? durationDays = freezed,
    Object? category = null,
    Object? confidence = null,
    Object? isConfirmed = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      brandName: freezed == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String?,
      dosageAmount: null == dosageAmount
          ? _value.dosageAmount
          : dosageAmount // ignore: cast_nullable_to_non_nullable
              as String,
      timesPerDay: null == timesPerDay
          ? _value.timesPerDay
          : timesPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      durationDays: freezed == durationDays
          ? _value.durationDays
          : durationDays // ignore: cast_nullable_to_non_nullable
              as int?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as DrugCategory,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      isConfirmed: null == isConfirmed
          ? _value.isConfirmed
          : isConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExtractedMedicineImplCopyWith<$Res>
    implements $ExtractedMedicineCopyWith<$Res> {
  factory _$$ExtractedMedicineImplCopyWith(_$ExtractedMedicineImpl value,
          $Res Function(_$ExtractedMedicineImpl) then) =
      __$$ExtractedMedicineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String? brandName,
      String dosageAmount,
      int timesPerDay,
      int? durationDays,
      DrugCategory category,
      double confidence,
      bool isConfirmed});
}

/// @nodoc
class __$$ExtractedMedicineImplCopyWithImpl<$Res>
    extends _$ExtractedMedicineCopyWithImpl<$Res, _$ExtractedMedicineImpl>
    implements _$$ExtractedMedicineImplCopyWith<$Res> {
  __$$ExtractedMedicineImplCopyWithImpl(_$ExtractedMedicineImpl _value,
      $Res Function(_$ExtractedMedicineImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExtractedMedicine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? brandName = freezed,
    Object? dosageAmount = null,
    Object? timesPerDay = null,
    Object? durationDays = freezed,
    Object? category = null,
    Object? confidence = null,
    Object? isConfirmed = null,
  }) {
    return _then(_$ExtractedMedicineImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      brandName: freezed == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String?,
      dosageAmount: null == dosageAmount
          ? _value.dosageAmount
          : dosageAmount // ignore: cast_nullable_to_non_nullable
              as String,
      timesPerDay: null == timesPerDay
          ? _value.timesPerDay
          : timesPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      durationDays: freezed == durationDays
          ? _value.durationDays
          : durationDays // ignore: cast_nullable_to_non_nullable
              as int?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as DrugCategory,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      isConfirmed: null == isConfirmed
          ? _value.isConfirmed
          : isConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExtractedMedicineImpl implements _ExtractedMedicine {
  const _$ExtractedMedicineImpl(
      {required this.name,
      this.brandName,
      required this.dosageAmount,
      required this.timesPerDay,
      this.durationDays,
      required this.category,
      required this.confidence,
      this.isConfirmed = false});

  factory _$ExtractedMedicineImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExtractedMedicineImplFromJson(json);

  @override
  final String name;
  @override
  final String? brandName;
  @override
  final String dosageAmount;
  @override
  final int timesPerDay;
  @override
  final int? durationDays;
  @override
  final DrugCategory category;
  @override
  final double confidence;
  @override
  @JsonKey()
  final bool isConfirmed;

  @override
  String toString() {
    return 'ExtractedMedicine(name: $name, brandName: $brandName, dosageAmount: $dosageAmount, timesPerDay: $timesPerDay, durationDays: $durationDays, category: $category, confidence: $confidence, isConfirmed: $isConfirmed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExtractedMedicineImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.brandName, brandName) ||
                other.brandName == brandName) &&
            (identical(other.dosageAmount, dosageAmount) ||
                other.dosageAmount == dosageAmount) &&
            (identical(other.timesPerDay, timesPerDay) ||
                other.timesPerDay == timesPerDay) &&
            (identical(other.durationDays, durationDays) ||
                other.durationDays == durationDays) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.isConfirmed, isConfirmed) ||
                other.isConfirmed == isConfirmed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, brandName, dosageAmount,
      timesPerDay, durationDays, category, confidence, isConfirmed);

  /// Create a copy of ExtractedMedicine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExtractedMedicineImplCopyWith<_$ExtractedMedicineImpl> get copyWith =>
      __$$ExtractedMedicineImplCopyWithImpl<_$ExtractedMedicineImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExtractedMedicineImplToJson(
      this,
    );
  }
}

abstract class _ExtractedMedicine implements ExtractedMedicine {
  const factory _ExtractedMedicine(
      {required final String name,
      final String? brandName,
      required final String dosageAmount,
      required final int timesPerDay,
      final int? durationDays,
      required final DrugCategory category,
      required final double confidence,
      final bool isConfirmed}) = _$ExtractedMedicineImpl;

  factory _ExtractedMedicine.fromJson(Map<String, dynamic> json) =
      _$ExtractedMedicineImpl.fromJson;

  @override
  String get name;
  @override
  String? get brandName;
  @override
  String get dosageAmount;
  @override
  int get timesPerDay;
  @override
  int? get durationDays;
  @override
  DrugCategory get category;
  @override
  double get confidence;
  @override
  bool get isConfirmed;

  /// Create a copy of ExtractedMedicine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExtractedMedicineImplCopyWith<_$ExtractedMedicineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DrugInteraction _$DrugInteractionFromJson(Map<String, dynamic> json) {
  return _DrugInteraction.fromJson(json);
}

/// @nodoc
mixin _$DrugInteraction {
  String get medicineA => throw _privateConstructorUsedError;
  String get medicineB => throw _privateConstructorUsedError;
  InteractionSeverity get severity => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this DrugInteraction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DrugInteraction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DrugInteractionCopyWith<DrugInteraction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DrugInteractionCopyWith<$Res> {
  factory $DrugInteractionCopyWith(
          DrugInteraction value, $Res Function(DrugInteraction) then) =
      _$DrugInteractionCopyWithImpl<$Res, DrugInteraction>;
  @useResult
  $Res call(
      {String medicineA,
      String medicineB,
      InteractionSeverity severity,
      String description});
}

/// @nodoc
class _$DrugInteractionCopyWithImpl<$Res, $Val extends DrugInteraction>
    implements $DrugInteractionCopyWith<$Res> {
  _$DrugInteractionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DrugInteraction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medicineA = null,
    Object? medicineB = null,
    Object? severity = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      medicineA: null == medicineA
          ? _value.medicineA
          : medicineA // ignore: cast_nullable_to_non_nullable
              as String,
      medicineB: null == medicineB
          ? _value.medicineB
          : medicineB // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as InteractionSeverity,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DrugInteractionImplCopyWith<$Res>
    implements $DrugInteractionCopyWith<$Res> {
  factory _$$DrugInteractionImplCopyWith(_$DrugInteractionImpl value,
          $Res Function(_$DrugInteractionImpl) then) =
      __$$DrugInteractionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String medicineA,
      String medicineB,
      InteractionSeverity severity,
      String description});
}

/// @nodoc
class __$$DrugInteractionImplCopyWithImpl<$Res>
    extends _$DrugInteractionCopyWithImpl<$Res, _$DrugInteractionImpl>
    implements _$$DrugInteractionImplCopyWith<$Res> {
  __$$DrugInteractionImplCopyWithImpl(
      _$DrugInteractionImpl _value, $Res Function(_$DrugInteractionImpl) _then)
      : super(_value, _then);

  /// Create a copy of DrugInteraction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medicineA = null,
    Object? medicineB = null,
    Object? severity = null,
    Object? description = null,
  }) {
    return _then(_$DrugInteractionImpl(
      medicineA: null == medicineA
          ? _value.medicineA
          : medicineA // ignore: cast_nullable_to_non_nullable
              as String,
      medicineB: null == medicineB
          ? _value.medicineB
          : medicineB // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as InteractionSeverity,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DrugInteractionImpl implements _DrugInteraction {
  const _$DrugInteractionImpl(
      {required this.medicineA,
      required this.medicineB,
      required this.severity,
      required this.description});

  factory _$DrugInteractionImpl.fromJson(Map<String, dynamic> json) =>
      _$$DrugInteractionImplFromJson(json);

  @override
  final String medicineA;
  @override
  final String medicineB;
  @override
  final InteractionSeverity severity;
  @override
  final String description;

  @override
  String toString() {
    return 'DrugInteraction(medicineA: $medicineA, medicineB: $medicineB, severity: $severity, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DrugInteractionImpl &&
            (identical(other.medicineA, medicineA) ||
                other.medicineA == medicineA) &&
            (identical(other.medicineB, medicineB) ||
                other.medicineB == medicineB) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, medicineA, medicineB, severity, description);

  /// Create a copy of DrugInteraction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DrugInteractionImplCopyWith<_$DrugInteractionImpl> get copyWith =>
      __$$DrugInteractionImplCopyWithImpl<_$DrugInteractionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DrugInteractionImplToJson(
      this,
    );
  }
}

abstract class _DrugInteraction implements DrugInteraction {
  const factory _DrugInteraction(
      {required final String medicineA,
      required final String medicineB,
      required final InteractionSeverity severity,
      required final String description}) = _$DrugInteractionImpl;

  factory _DrugInteraction.fromJson(Map<String, dynamic> json) =
      _$DrugInteractionImpl.fromJson;

  @override
  String get medicineA;
  @override
  String get medicineB;
  @override
  InteractionSeverity get severity;
  @override
  String get description;

  /// Create a copy of DrugInteraction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DrugInteractionImplCopyWith<_$DrugInteractionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PrescriptionAnalysisResult _$PrescriptionAnalysisResultFromJson(
    Map<String, dynamic> json) {
  return _PrescriptionAnalysisResult.fromJson(json);
}

/// @nodoc
mixin _$PrescriptionAnalysisResult {
  List<ExtractedMedicine> get medicines => throw _privateConstructorUsedError;
  List<DrugInteraction> get interactions => throw _privateConstructorUsedError;
  List<String> get warnings => throw _privateConstructorUsedError;
  String? get doctorName => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;

  /// Serializes this PrescriptionAnalysisResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrescriptionAnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrescriptionAnalysisResultCopyWith<PrescriptionAnalysisResult>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrescriptionAnalysisResultCopyWith<$Res> {
  factory $PrescriptionAnalysisResultCopyWith(PrescriptionAnalysisResult value,
          $Res Function(PrescriptionAnalysisResult) then) =
      _$PrescriptionAnalysisResultCopyWithImpl<$Res,
          PrescriptionAnalysisResult>;
  @useResult
  $Res call(
      {List<ExtractedMedicine> medicines,
      List<DrugInteraction> interactions,
      List<String> warnings,
      String? doctorName,
      DateTime? date});
}

/// @nodoc
class _$PrescriptionAnalysisResultCopyWithImpl<$Res,
        $Val extends PrescriptionAnalysisResult>
    implements $PrescriptionAnalysisResultCopyWith<$Res> {
  _$PrescriptionAnalysisResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrescriptionAnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medicines = null,
    Object? interactions = null,
    Object? warnings = null,
    Object? doctorName = freezed,
    Object? date = freezed,
  }) {
    return _then(_value.copyWith(
      medicines: null == medicines
          ? _value.medicines
          : medicines // ignore: cast_nullable_to_non_nullable
              as List<ExtractedMedicine>,
      interactions: null == interactions
          ? _value.interactions
          : interactions // ignore: cast_nullable_to_non_nullable
              as List<DrugInteraction>,
      warnings: null == warnings
          ? _value.warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      doctorName: freezed == doctorName
          ? _value.doctorName
          : doctorName // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrescriptionAnalysisResultImplCopyWith<$Res>
    implements $PrescriptionAnalysisResultCopyWith<$Res> {
  factory _$$PrescriptionAnalysisResultImplCopyWith(
          _$PrescriptionAnalysisResultImpl value,
          $Res Function(_$PrescriptionAnalysisResultImpl) then) =
      __$$PrescriptionAnalysisResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ExtractedMedicine> medicines,
      List<DrugInteraction> interactions,
      List<String> warnings,
      String? doctorName,
      DateTime? date});
}

/// @nodoc
class __$$PrescriptionAnalysisResultImplCopyWithImpl<$Res>
    extends _$PrescriptionAnalysisResultCopyWithImpl<$Res,
        _$PrescriptionAnalysisResultImpl>
    implements _$$PrescriptionAnalysisResultImplCopyWith<$Res> {
  __$$PrescriptionAnalysisResultImplCopyWithImpl(
      _$PrescriptionAnalysisResultImpl _value,
      $Res Function(_$PrescriptionAnalysisResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrescriptionAnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medicines = null,
    Object? interactions = null,
    Object? warnings = null,
    Object? doctorName = freezed,
    Object? date = freezed,
  }) {
    return _then(_$PrescriptionAnalysisResultImpl(
      medicines: null == medicines
          ? _value._medicines
          : medicines // ignore: cast_nullable_to_non_nullable
              as List<ExtractedMedicine>,
      interactions: null == interactions
          ? _value._interactions
          : interactions // ignore: cast_nullable_to_non_nullable
              as List<DrugInteraction>,
      warnings: null == warnings
          ? _value._warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      doctorName: freezed == doctorName
          ? _value.doctorName
          : doctorName // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrescriptionAnalysisResultImpl implements _PrescriptionAnalysisResult {
  const _$PrescriptionAnalysisResultImpl(
      {required final List<ExtractedMedicine> medicines,
      required final List<DrugInteraction> interactions,
      required final List<String> warnings,
      this.doctorName,
      this.date})
      : _medicines = medicines,
        _interactions = interactions,
        _warnings = warnings;

  factory _$PrescriptionAnalysisResultImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$PrescriptionAnalysisResultImplFromJson(json);

  final List<ExtractedMedicine> _medicines;
  @override
  List<ExtractedMedicine> get medicines {
    if (_medicines is EqualUnmodifiableListView) return _medicines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medicines);
  }

  final List<DrugInteraction> _interactions;
  @override
  List<DrugInteraction> get interactions {
    if (_interactions is EqualUnmodifiableListView) return _interactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interactions);
  }

  final List<String> _warnings;
  @override
  List<String> get warnings {
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warnings);
  }

  @override
  final String? doctorName;
  @override
  final DateTime? date;

  @override
  String toString() {
    return 'PrescriptionAnalysisResult(medicines: $medicines, interactions: $interactions, warnings: $warnings, doctorName: $doctorName, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrescriptionAnalysisResultImpl &&
            const DeepCollectionEquality()
                .equals(other._medicines, _medicines) &&
            const DeepCollectionEquality()
                .equals(other._interactions, _interactions) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings) &&
            (identical(other.doctorName, doctorName) ||
                other.doctorName == doctorName) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_medicines),
      const DeepCollectionEquality().hash(_interactions),
      const DeepCollectionEquality().hash(_warnings),
      doctorName,
      date);

  /// Create a copy of PrescriptionAnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrescriptionAnalysisResultImplCopyWith<_$PrescriptionAnalysisResultImpl>
      get copyWith => __$$PrescriptionAnalysisResultImplCopyWithImpl<
          _$PrescriptionAnalysisResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrescriptionAnalysisResultImplToJson(
      this,
    );
  }
}

abstract class _PrescriptionAnalysisResult
    implements PrescriptionAnalysisResult {
  const factory _PrescriptionAnalysisResult(
      {required final List<ExtractedMedicine> medicines,
      required final List<DrugInteraction> interactions,
      required final List<String> warnings,
      final String? doctorName,
      final DateTime? date}) = _$PrescriptionAnalysisResultImpl;

  factory _PrescriptionAnalysisResult.fromJson(Map<String, dynamic> json) =
      _$PrescriptionAnalysisResultImpl.fromJson;

  @override
  List<ExtractedMedicine> get medicines;
  @override
  List<DrugInteraction> get interactions;
  @override
  List<String> get warnings;
  @override
  String? get doctorName;
  @override
  DateTime? get date;

  /// Create a copy of PrescriptionAnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrescriptionAnalysisResultImplCopyWith<_$PrescriptionAnalysisResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}
