// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medicine_ai_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MedicineAIState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() analyzingAlternatives,
    required TResult Function(String advice) alternativesSuccess,
    required TResult Function() analyzingGuide,
    required TResult Function(String uses, String timing, String warnings)
        guideSuccess,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? analyzingAlternatives,
    TResult? Function(String advice)? alternativesSuccess,
    TResult? Function()? analyzingGuide,
    TResult? Function(String uses, String timing, String warnings)?
        guideSuccess,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? analyzingAlternatives,
    TResult Function(String advice)? alternativesSuccess,
    TResult Function()? analyzingGuide,
    TResult Function(String uses, String timing, String warnings)? guideSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_AnalyzingAlternatives value)
        analyzingAlternatives,
    required TResult Function(_AlternativesSuccess value) alternativesSuccess,
    required TResult Function(_AnalyzingGuide value) analyzingGuide,
    required TResult Function(_GuideSuccess value) guideSuccess,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_AnalyzingAlternatives value)? analyzingAlternatives,
    TResult? Function(_AlternativesSuccess value)? alternativesSuccess,
    TResult? Function(_AnalyzingGuide value)? analyzingGuide,
    TResult? Function(_GuideSuccess value)? guideSuccess,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_AnalyzingAlternatives value)? analyzingAlternatives,
    TResult Function(_AlternativesSuccess value)? alternativesSuccess,
    TResult Function(_AnalyzingGuide value)? analyzingGuide,
    TResult Function(_GuideSuccess value)? guideSuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicineAIStateCopyWith<$Res> {
  factory $MedicineAIStateCopyWith(
          MedicineAIState value, $Res Function(MedicineAIState) then) =
      _$MedicineAIStateCopyWithImpl<$Res, MedicineAIState>;
}

/// @nodoc
class _$MedicineAIStateCopyWithImpl<$Res, $Val extends MedicineAIState>
    implements $MedicineAIStateCopyWith<$Res> {
  _$MedicineAIStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicineAIState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$IdleImplCopyWith<$Res> {
  factory _$$IdleImplCopyWith(
          _$IdleImpl value, $Res Function(_$IdleImpl) then) =
      __$$IdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$IdleImplCopyWithImpl<$Res>
    extends _$MedicineAIStateCopyWithImpl<$Res, _$IdleImpl>
    implements _$$IdleImplCopyWith<$Res> {
  __$$IdleImplCopyWithImpl(_$IdleImpl _value, $Res Function(_$IdleImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicineAIState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$IdleImpl implements _Idle {
  const _$IdleImpl();

  @override
  String toString() {
    return 'MedicineAIState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$IdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() analyzingAlternatives,
    required TResult Function(String advice) alternativesSuccess,
    required TResult Function() analyzingGuide,
    required TResult Function(String uses, String timing, String warnings)
        guideSuccess,
    required TResult Function(String message) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? analyzingAlternatives,
    TResult? Function(String advice)? alternativesSuccess,
    TResult? Function()? analyzingGuide,
    TResult? Function(String uses, String timing, String warnings)?
        guideSuccess,
    TResult? Function(String message)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? analyzingAlternatives,
    TResult Function(String advice)? alternativesSuccess,
    TResult Function()? analyzingGuide,
    TResult Function(String uses, String timing, String warnings)? guideSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_AnalyzingAlternatives value)
        analyzingAlternatives,
    required TResult Function(_AlternativesSuccess value) alternativesSuccess,
    required TResult Function(_AnalyzingGuide value) analyzingGuide,
    required TResult Function(_GuideSuccess value) guideSuccess,
    required TResult Function(_Error value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_AnalyzingAlternatives value)? analyzingAlternatives,
    TResult? Function(_AlternativesSuccess value)? alternativesSuccess,
    TResult? Function(_AnalyzingGuide value)? analyzingGuide,
    TResult? Function(_GuideSuccess value)? guideSuccess,
    TResult? Function(_Error value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_AnalyzingAlternatives value)? analyzingAlternatives,
    TResult Function(_AlternativesSuccess value)? alternativesSuccess,
    TResult Function(_AnalyzingGuide value)? analyzingGuide,
    TResult Function(_GuideSuccess value)? guideSuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class _Idle implements MedicineAIState {
  const factory _Idle() = _$IdleImpl;
}

/// @nodoc
abstract class _$$AnalyzingAlternativesImplCopyWith<$Res> {
  factory _$$AnalyzingAlternativesImplCopyWith(
          _$AnalyzingAlternativesImpl value,
          $Res Function(_$AnalyzingAlternativesImpl) then) =
      __$$AnalyzingAlternativesImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AnalyzingAlternativesImplCopyWithImpl<$Res>
    extends _$MedicineAIStateCopyWithImpl<$Res, _$AnalyzingAlternativesImpl>
    implements _$$AnalyzingAlternativesImplCopyWith<$Res> {
  __$$AnalyzingAlternativesImplCopyWithImpl(_$AnalyzingAlternativesImpl _value,
      $Res Function(_$AnalyzingAlternativesImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicineAIState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AnalyzingAlternativesImpl implements _AnalyzingAlternatives {
  const _$AnalyzingAlternativesImpl();

  @override
  String toString() {
    return 'MedicineAIState.analyzingAlternatives()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyzingAlternativesImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() analyzingAlternatives,
    required TResult Function(String advice) alternativesSuccess,
    required TResult Function() analyzingGuide,
    required TResult Function(String uses, String timing, String warnings)
        guideSuccess,
    required TResult Function(String message) error,
  }) {
    return analyzingAlternatives();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? analyzingAlternatives,
    TResult? Function(String advice)? alternativesSuccess,
    TResult? Function()? analyzingGuide,
    TResult? Function(String uses, String timing, String warnings)?
        guideSuccess,
    TResult? Function(String message)? error,
  }) {
    return analyzingAlternatives?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? analyzingAlternatives,
    TResult Function(String advice)? alternativesSuccess,
    TResult Function()? analyzingGuide,
    TResult Function(String uses, String timing, String warnings)? guideSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (analyzingAlternatives != null) {
      return analyzingAlternatives();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_AnalyzingAlternatives value)
        analyzingAlternatives,
    required TResult Function(_AlternativesSuccess value) alternativesSuccess,
    required TResult Function(_AnalyzingGuide value) analyzingGuide,
    required TResult Function(_GuideSuccess value) guideSuccess,
    required TResult Function(_Error value) error,
  }) {
    return analyzingAlternatives(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_AnalyzingAlternatives value)? analyzingAlternatives,
    TResult? Function(_AlternativesSuccess value)? alternativesSuccess,
    TResult? Function(_AnalyzingGuide value)? analyzingGuide,
    TResult? Function(_GuideSuccess value)? guideSuccess,
    TResult? Function(_Error value)? error,
  }) {
    return analyzingAlternatives?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_AnalyzingAlternatives value)? analyzingAlternatives,
    TResult Function(_AlternativesSuccess value)? alternativesSuccess,
    TResult Function(_AnalyzingGuide value)? analyzingGuide,
    TResult Function(_GuideSuccess value)? guideSuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (analyzingAlternatives != null) {
      return analyzingAlternatives(this);
    }
    return orElse();
  }
}

abstract class _AnalyzingAlternatives implements MedicineAIState {
  const factory _AnalyzingAlternatives() = _$AnalyzingAlternativesImpl;
}

/// @nodoc
abstract class _$$AlternativesSuccessImplCopyWith<$Res> {
  factory _$$AlternativesSuccessImplCopyWith(_$AlternativesSuccessImpl value,
          $Res Function(_$AlternativesSuccessImpl) then) =
      __$$AlternativesSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String advice});
}

/// @nodoc
class __$$AlternativesSuccessImplCopyWithImpl<$Res>
    extends _$MedicineAIStateCopyWithImpl<$Res, _$AlternativesSuccessImpl>
    implements _$$AlternativesSuccessImplCopyWith<$Res> {
  __$$AlternativesSuccessImplCopyWithImpl(_$AlternativesSuccessImpl _value,
      $Res Function(_$AlternativesSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicineAIState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? advice = null,
  }) {
    return _then(_$AlternativesSuccessImpl(
      null == advice
          ? _value.advice
          : advice // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AlternativesSuccessImpl implements _AlternativesSuccess {
  const _$AlternativesSuccessImpl(this.advice);

  @override
  final String advice;

  @override
  String toString() {
    return 'MedicineAIState.alternativesSuccess(advice: $advice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlternativesSuccessImpl &&
            (identical(other.advice, advice) || other.advice == advice));
  }

  @override
  int get hashCode => Object.hash(runtimeType, advice);

  /// Create a copy of MedicineAIState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlternativesSuccessImplCopyWith<_$AlternativesSuccessImpl> get copyWith =>
      __$$AlternativesSuccessImplCopyWithImpl<_$AlternativesSuccessImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() analyzingAlternatives,
    required TResult Function(String advice) alternativesSuccess,
    required TResult Function() analyzingGuide,
    required TResult Function(String uses, String timing, String warnings)
        guideSuccess,
    required TResult Function(String message) error,
  }) {
    return alternativesSuccess(advice);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? analyzingAlternatives,
    TResult? Function(String advice)? alternativesSuccess,
    TResult? Function()? analyzingGuide,
    TResult? Function(String uses, String timing, String warnings)?
        guideSuccess,
    TResult? Function(String message)? error,
  }) {
    return alternativesSuccess?.call(advice);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? analyzingAlternatives,
    TResult Function(String advice)? alternativesSuccess,
    TResult Function()? analyzingGuide,
    TResult Function(String uses, String timing, String warnings)? guideSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (alternativesSuccess != null) {
      return alternativesSuccess(advice);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_AnalyzingAlternatives value)
        analyzingAlternatives,
    required TResult Function(_AlternativesSuccess value) alternativesSuccess,
    required TResult Function(_AnalyzingGuide value) analyzingGuide,
    required TResult Function(_GuideSuccess value) guideSuccess,
    required TResult Function(_Error value) error,
  }) {
    return alternativesSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_AnalyzingAlternatives value)? analyzingAlternatives,
    TResult? Function(_AlternativesSuccess value)? alternativesSuccess,
    TResult? Function(_AnalyzingGuide value)? analyzingGuide,
    TResult? Function(_GuideSuccess value)? guideSuccess,
    TResult? Function(_Error value)? error,
  }) {
    return alternativesSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_AnalyzingAlternatives value)? analyzingAlternatives,
    TResult Function(_AlternativesSuccess value)? alternativesSuccess,
    TResult Function(_AnalyzingGuide value)? analyzingGuide,
    TResult Function(_GuideSuccess value)? guideSuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (alternativesSuccess != null) {
      return alternativesSuccess(this);
    }
    return orElse();
  }
}

abstract class _AlternativesSuccess implements MedicineAIState {
  const factory _AlternativesSuccess(final String advice) =
      _$AlternativesSuccessImpl;

  String get advice;

  /// Create a copy of MedicineAIState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlternativesSuccessImplCopyWith<_$AlternativesSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AnalyzingGuideImplCopyWith<$Res> {
  factory _$$AnalyzingGuideImplCopyWith(_$AnalyzingGuideImpl value,
          $Res Function(_$AnalyzingGuideImpl) then) =
      __$$AnalyzingGuideImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AnalyzingGuideImplCopyWithImpl<$Res>
    extends _$MedicineAIStateCopyWithImpl<$Res, _$AnalyzingGuideImpl>
    implements _$$AnalyzingGuideImplCopyWith<$Res> {
  __$$AnalyzingGuideImplCopyWithImpl(
      _$AnalyzingGuideImpl _value, $Res Function(_$AnalyzingGuideImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicineAIState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AnalyzingGuideImpl implements _AnalyzingGuide {
  const _$AnalyzingGuideImpl();

  @override
  String toString() {
    return 'MedicineAIState.analyzingGuide()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AnalyzingGuideImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() analyzingAlternatives,
    required TResult Function(String advice) alternativesSuccess,
    required TResult Function() analyzingGuide,
    required TResult Function(String uses, String timing, String warnings)
        guideSuccess,
    required TResult Function(String message) error,
  }) {
    return analyzingGuide();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? analyzingAlternatives,
    TResult? Function(String advice)? alternativesSuccess,
    TResult? Function()? analyzingGuide,
    TResult? Function(String uses, String timing, String warnings)?
        guideSuccess,
    TResult? Function(String message)? error,
  }) {
    return analyzingGuide?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? analyzingAlternatives,
    TResult Function(String advice)? alternativesSuccess,
    TResult Function()? analyzingGuide,
    TResult Function(String uses, String timing, String warnings)? guideSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (analyzingGuide != null) {
      return analyzingGuide();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_AnalyzingAlternatives value)
        analyzingAlternatives,
    required TResult Function(_AlternativesSuccess value) alternativesSuccess,
    required TResult Function(_AnalyzingGuide value) analyzingGuide,
    required TResult Function(_GuideSuccess value) guideSuccess,
    required TResult Function(_Error value) error,
  }) {
    return analyzingGuide(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_AnalyzingAlternatives value)? analyzingAlternatives,
    TResult? Function(_AlternativesSuccess value)? alternativesSuccess,
    TResult? Function(_AnalyzingGuide value)? analyzingGuide,
    TResult? Function(_GuideSuccess value)? guideSuccess,
    TResult? Function(_Error value)? error,
  }) {
    return analyzingGuide?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_AnalyzingAlternatives value)? analyzingAlternatives,
    TResult Function(_AlternativesSuccess value)? alternativesSuccess,
    TResult Function(_AnalyzingGuide value)? analyzingGuide,
    TResult Function(_GuideSuccess value)? guideSuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (analyzingGuide != null) {
      return analyzingGuide(this);
    }
    return orElse();
  }
}

abstract class _AnalyzingGuide implements MedicineAIState {
  const factory _AnalyzingGuide() = _$AnalyzingGuideImpl;
}

/// @nodoc
abstract class _$$GuideSuccessImplCopyWith<$Res> {
  factory _$$GuideSuccessImplCopyWith(
          _$GuideSuccessImpl value, $Res Function(_$GuideSuccessImpl) then) =
      __$$GuideSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String uses, String timing, String warnings});
}

/// @nodoc
class __$$GuideSuccessImplCopyWithImpl<$Res>
    extends _$MedicineAIStateCopyWithImpl<$Res, _$GuideSuccessImpl>
    implements _$$GuideSuccessImplCopyWith<$Res> {
  __$$GuideSuccessImplCopyWithImpl(
      _$GuideSuccessImpl _value, $Res Function(_$GuideSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicineAIState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uses = null,
    Object? timing = null,
    Object? warnings = null,
  }) {
    return _then(_$GuideSuccessImpl(
      uses: null == uses
          ? _value.uses
          : uses // ignore: cast_nullable_to_non_nullable
              as String,
      timing: null == timing
          ? _value.timing
          : timing // ignore: cast_nullable_to_non_nullable
              as String,
      warnings: null == warnings
          ? _value.warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$GuideSuccessImpl implements _GuideSuccess {
  const _$GuideSuccessImpl(
      {required this.uses, required this.timing, required this.warnings});

  @override
  final String uses;
  @override
  final String timing;
  @override
  final String warnings;

  @override
  String toString() {
    return 'MedicineAIState.guideSuccess(uses: $uses, timing: $timing, warnings: $warnings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuideSuccessImpl &&
            (identical(other.uses, uses) || other.uses == uses) &&
            (identical(other.timing, timing) || other.timing == timing) &&
            (identical(other.warnings, warnings) ||
                other.warnings == warnings));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uses, timing, warnings);

  /// Create a copy of MedicineAIState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GuideSuccessImplCopyWith<_$GuideSuccessImpl> get copyWith =>
      __$$GuideSuccessImplCopyWithImpl<_$GuideSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() analyzingAlternatives,
    required TResult Function(String advice) alternativesSuccess,
    required TResult Function() analyzingGuide,
    required TResult Function(String uses, String timing, String warnings)
        guideSuccess,
    required TResult Function(String message) error,
  }) {
    return guideSuccess(uses, timing, warnings);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? analyzingAlternatives,
    TResult? Function(String advice)? alternativesSuccess,
    TResult? Function()? analyzingGuide,
    TResult? Function(String uses, String timing, String warnings)?
        guideSuccess,
    TResult? Function(String message)? error,
  }) {
    return guideSuccess?.call(uses, timing, warnings);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? analyzingAlternatives,
    TResult Function(String advice)? alternativesSuccess,
    TResult Function()? analyzingGuide,
    TResult Function(String uses, String timing, String warnings)? guideSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (guideSuccess != null) {
      return guideSuccess(uses, timing, warnings);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_AnalyzingAlternatives value)
        analyzingAlternatives,
    required TResult Function(_AlternativesSuccess value) alternativesSuccess,
    required TResult Function(_AnalyzingGuide value) analyzingGuide,
    required TResult Function(_GuideSuccess value) guideSuccess,
    required TResult Function(_Error value) error,
  }) {
    return guideSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_AnalyzingAlternatives value)? analyzingAlternatives,
    TResult? Function(_AlternativesSuccess value)? alternativesSuccess,
    TResult? Function(_AnalyzingGuide value)? analyzingGuide,
    TResult? Function(_GuideSuccess value)? guideSuccess,
    TResult? Function(_Error value)? error,
  }) {
    return guideSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_AnalyzingAlternatives value)? analyzingAlternatives,
    TResult Function(_AlternativesSuccess value)? alternativesSuccess,
    TResult Function(_AnalyzingGuide value)? analyzingGuide,
    TResult Function(_GuideSuccess value)? guideSuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (guideSuccess != null) {
      return guideSuccess(this);
    }
    return orElse();
  }
}

abstract class _GuideSuccess implements MedicineAIState {
  const factory _GuideSuccess(
      {required final String uses,
      required final String timing,
      required final String warnings}) = _$GuideSuccessImpl;

  String get uses;
  String get timing;
  String get warnings;

  /// Create a copy of MedicineAIState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GuideSuccessImplCopyWith<_$GuideSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$MedicineAIStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicineAIState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'MedicineAIState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of MedicineAIState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() analyzingAlternatives,
    required TResult Function(String advice) alternativesSuccess,
    required TResult Function() analyzingGuide,
    required TResult Function(String uses, String timing, String warnings)
        guideSuccess,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? analyzingAlternatives,
    TResult? Function(String advice)? alternativesSuccess,
    TResult? Function()? analyzingGuide,
    TResult? Function(String uses, String timing, String warnings)?
        guideSuccess,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? analyzingAlternatives,
    TResult Function(String advice)? alternativesSuccess,
    TResult Function()? analyzingGuide,
    TResult Function(String uses, String timing, String warnings)? guideSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_AnalyzingAlternatives value)
        analyzingAlternatives,
    required TResult Function(_AlternativesSuccess value) alternativesSuccess,
    required TResult Function(_AnalyzingGuide value) analyzingGuide,
    required TResult Function(_GuideSuccess value) guideSuccess,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_AnalyzingAlternatives value)? analyzingAlternatives,
    TResult? Function(_AlternativesSuccess value)? alternativesSuccess,
    TResult? Function(_AnalyzingGuide value)? analyzingGuide,
    TResult? Function(_GuideSuccess value)? guideSuccess,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_AnalyzingAlternatives value)? analyzingAlternatives,
    TResult Function(_AlternativesSuccess value)? alternativesSuccess,
    TResult Function(_AnalyzingGuide value)? analyzingGuide,
    TResult Function(_GuideSuccess value)? guideSuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements MedicineAIState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of MedicineAIState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
