// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prevision.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Prevision _$PrevisionFromJson(Map<String, dynamic> json) {
  return _Prevision.fromJson(json);
}

/// @nodoc
mixin _$Prevision {
  String get serviceId => throw _privateConstructorUsedError;
  List<PointPrevision> get points => throw _privateConstructorUsedError;
  String get methode => throw _privateConstructorUsedError;
  double get confiance => throw _privateConstructorUsedError;

  /// Serializes this Prevision to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Prevision
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrevisionCopyWith<Prevision> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrevisionCopyWith<$Res> {
  factory $PrevisionCopyWith(Prevision value, $Res Function(Prevision) then) =
      _$PrevisionCopyWithImpl<$Res, Prevision>;
  @useResult
  $Res call({
    String serviceId,
    List<PointPrevision> points,
    String methode,
    double confiance,
  });
}

/// @nodoc
class _$PrevisionCopyWithImpl<$Res, $Val extends Prevision>
    implements $PrevisionCopyWith<$Res> {
  _$PrevisionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Prevision
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceId = null,
    Object? points = null,
    Object? methode = null,
    Object? confiance = null,
  }) {
    return _then(
      _value.copyWith(
            serviceId: null == serviceId
                ? _value.serviceId
                : serviceId // ignore: cast_nullable_to_non_nullable
                      as String,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as List<PointPrevision>,
            methode: null == methode
                ? _value.methode
                : methode // ignore: cast_nullable_to_non_nullable
                      as String,
            confiance: null == confiance
                ? _value.confiance
                : confiance // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PrevisionImplCopyWith<$Res>
    implements $PrevisionCopyWith<$Res> {
  factory _$$PrevisionImplCopyWith(
    _$PrevisionImpl value,
    $Res Function(_$PrevisionImpl) then,
  ) = __$$PrevisionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String serviceId,
    List<PointPrevision> points,
    String methode,
    double confiance,
  });
}

/// @nodoc
class __$$PrevisionImplCopyWithImpl<$Res>
    extends _$PrevisionCopyWithImpl<$Res, _$PrevisionImpl>
    implements _$$PrevisionImplCopyWith<$Res> {
  __$$PrevisionImplCopyWithImpl(
    _$PrevisionImpl _value,
    $Res Function(_$PrevisionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Prevision
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceId = null,
    Object? points = null,
    Object? methode = null,
    Object? confiance = null,
  }) {
    return _then(
      _$PrevisionImpl(
        serviceId: null == serviceId
            ? _value.serviceId
            : serviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        points: null == points
            ? _value._points
            : points // ignore: cast_nullable_to_non_nullable
                  as List<PointPrevision>,
        methode: null == methode
            ? _value.methode
            : methode // ignore: cast_nullable_to_non_nullable
                  as String,
        confiance: null == confiance
            ? _value.confiance
            : confiance // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PrevisionImpl implements _Prevision {
  const _$PrevisionImpl({
    required this.serviceId,
    required final List<PointPrevision> points,
    required this.methode,
    this.confiance = 0.0,
  }) : _points = points;

  factory _$PrevisionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrevisionImplFromJson(json);

  @override
  final String serviceId;
  final List<PointPrevision> _points;
  @override
  List<PointPrevision> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  @override
  final String methode;
  @override
  @JsonKey()
  final double confiance;

  @override
  String toString() {
    return 'Prevision(serviceId: $serviceId, points: $points, methode: $methode, confiance: $confiance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrevisionImpl &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            const DeepCollectionEquality().equals(other._points, _points) &&
            (identical(other.methode, methode) || other.methode == methode) &&
            (identical(other.confiance, confiance) ||
                other.confiance == confiance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    serviceId,
    const DeepCollectionEquality().hash(_points),
    methode,
    confiance,
  );

  /// Create a copy of Prevision
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrevisionImplCopyWith<_$PrevisionImpl> get copyWith =>
      __$$PrevisionImplCopyWithImpl<_$PrevisionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrevisionImplToJson(this);
  }
}

abstract class _Prevision implements Prevision {
  const factory _Prevision({
    required final String serviceId,
    required final List<PointPrevision> points,
    required final String methode,
    final double confiance,
  }) = _$PrevisionImpl;

  factory _Prevision.fromJson(Map<String, dynamic> json) =
      _$PrevisionImpl.fromJson;

  @override
  String get serviceId;
  @override
  List<PointPrevision> get points;
  @override
  String get methode;
  @override
  double get confiance;

  /// Create a copy of Prevision
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrevisionImplCopyWith<_$PrevisionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PointPrevision _$PointPrevisionFromJson(Map<String, dynamic> json) {
  return _PointPrevision.fromJson(json);
}

/// @nodoc
mixin _$PointPrevision {
  DateTime get date => throw _privateConstructorUsedError;
  double get montantPrevu => throw _privateConstructorUsedError;
  double? get montantReel => throw _privateConstructorUsedError;

  /// Serializes this PointPrevision to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PointPrevision
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PointPrevisionCopyWith<PointPrevision> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PointPrevisionCopyWith<$Res> {
  factory $PointPrevisionCopyWith(
    PointPrevision value,
    $Res Function(PointPrevision) then,
  ) = _$PointPrevisionCopyWithImpl<$Res, PointPrevision>;
  @useResult
  $Res call({DateTime date, double montantPrevu, double? montantReel});
}

/// @nodoc
class _$PointPrevisionCopyWithImpl<$Res, $Val extends PointPrevision>
    implements $PointPrevisionCopyWith<$Res> {
  _$PointPrevisionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PointPrevision
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? montantPrevu = null,
    Object? montantReel = freezed,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            montantPrevu: null == montantPrevu
                ? _value.montantPrevu
                : montantPrevu // ignore: cast_nullable_to_non_nullable
                      as double,
            montantReel: freezed == montantReel
                ? _value.montantReel
                : montantReel // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PointPrevisionImplCopyWith<$Res>
    implements $PointPrevisionCopyWith<$Res> {
  factory _$$PointPrevisionImplCopyWith(
    _$PointPrevisionImpl value,
    $Res Function(_$PointPrevisionImpl) then,
  ) = __$$PointPrevisionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, double montantPrevu, double? montantReel});
}

/// @nodoc
class __$$PointPrevisionImplCopyWithImpl<$Res>
    extends _$PointPrevisionCopyWithImpl<$Res, _$PointPrevisionImpl>
    implements _$$PointPrevisionImplCopyWith<$Res> {
  __$$PointPrevisionImplCopyWithImpl(
    _$PointPrevisionImpl _value,
    $Res Function(_$PointPrevisionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PointPrevision
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? montantPrevu = null,
    Object? montantReel = freezed,
  }) {
    return _then(
      _$PointPrevisionImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        montantPrevu: null == montantPrevu
            ? _value.montantPrevu
            : montantPrevu // ignore: cast_nullable_to_non_nullable
                  as double,
        montantReel: freezed == montantReel
            ? _value.montantReel
            : montantReel // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PointPrevisionImpl implements _PointPrevision {
  const _$PointPrevisionImpl({
    required this.date,
    required this.montantPrevu,
    this.montantReel,
  });

  factory _$PointPrevisionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PointPrevisionImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double montantPrevu;
  @override
  final double? montantReel;

  @override
  String toString() {
    return 'PointPrevision(date: $date, montantPrevu: $montantPrevu, montantReel: $montantReel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PointPrevisionImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.montantPrevu, montantPrevu) ||
                other.montantPrevu == montantPrevu) &&
            (identical(other.montantReel, montantReel) ||
                other.montantReel == montantReel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, montantPrevu, montantReel);

  /// Create a copy of PointPrevision
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PointPrevisionImplCopyWith<_$PointPrevisionImpl> get copyWith =>
      __$$PointPrevisionImplCopyWithImpl<_$PointPrevisionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PointPrevisionImplToJson(this);
  }
}

abstract class _PointPrevision implements PointPrevision {
  const factory _PointPrevision({
    required final DateTime date,
    required final double montantPrevu,
    final double? montantReel,
  }) = _$PointPrevisionImpl;

  factory _PointPrevision.fromJson(Map<String, dynamic> json) =
      _$PointPrevisionImpl.fromJson;

  @override
  DateTime get date;
  @override
  double get montantPrevu;
  @override
  double? get montantReel;

  /// Create a copy of PointPrevision
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PointPrevisionImplCopyWith<_$PointPrevisionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
