// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alerte.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Alerte _$AlerteFromJson(Map<String, dynamic> json) {
  return _Alerte.fromJson(json);
}

/// @nodoc
mixin _$Alerte {
  String get id => throw _privateConstructorUsedError;
  TypeAlerte get type => throw _privateConstructorUsedError;
  String? get serviceId => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  NiveauAlerte get niveau => throw _privateConstructorUsedError;
  DateTime get dateCreation => throw _privateConstructorUsedError;
  DateTime? get dateResolution => throw _privateConstructorUsedError;
  bool get resolue => throw _privateConstructorUsedError;

  /// Serializes this Alerte to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Alerte
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlerteCopyWith<Alerte> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlerteCopyWith<$Res> {
  factory $AlerteCopyWith(Alerte value, $Res Function(Alerte) then) =
      _$AlerteCopyWithImpl<$Res, Alerte>;
  @useResult
  $Res call({
    String id,
    TypeAlerte type,
    String? serviceId,
    String message,
    NiveauAlerte niveau,
    DateTime dateCreation,
    DateTime? dateResolution,
    bool resolue,
  });
}

/// @nodoc
class _$AlerteCopyWithImpl<$Res, $Val extends Alerte>
    implements $AlerteCopyWith<$Res> {
  _$AlerteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Alerte
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? serviceId = freezed,
    Object? message = null,
    Object? niveau = null,
    Object? dateCreation = null,
    Object? dateResolution = freezed,
    Object? resolue = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TypeAlerte,
            serviceId: freezed == serviceId
                ? _value.serviceId
                : serviceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            niveau: null == niveau
                ? _value.niveau
                : niveau // ignore: cast_nullable_to_non_nullable
                      as NiveauAlerte,
            dateCreation: null == dateCreation
                ? _value.dateCreation
                : dateCreation // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            dateResolution: freezed == dateResolution
                ? _value.dateResolution
                : dateResolution // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            resolue: null == resolue
                ? _value.resolue
                : resolue // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlerteImplCopyWith<$Res> implements $AlerteCopyWith<$Res> {
  factory _$$AlerteImplCopyWith(
    _$AlerteImpl value,
    $Res Function(_$AlerteImpl) then,
  ) = __$$AlerteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    TypeAlerte type,
    String? serviceId,
    String message,
    NiveauAlerte niveau,
    DateTime dateCreation,
    DateTime? dateResolution,
    bool resolue,
  });
}

/// @nodoc
class __$$AlerteImplCopyWithImpl<$Res>
    extends _$AlerteCopyWithImpl<$Res, _$AlerteImpl>
    implements _$$AlerteImplCopyWith<$Res> {
  __$$AlerteImplCopyWithImpl(
    _$AlerteImpl _value,
    $Res Function(_$AlerteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Alerte
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? serviceId = freezed,
    Object? message = null,
    Object? niveau = null,
    Object? dateCreation = null,
    Object? dateResolution = freezed,
    Object? resolue = null,
  }) {
    return _then(
      _$AlerteImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TypeAlerte,
        serviceId: freezed == serviceId
            ? _value.serviceId
            : serviceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        niveau: null == niveau
            ? _value.niveau
            : niveau // ignore: cast_nullable_to_non_nullable
                  as NiveauAlerte,
        dateCreation: null == dateCreation
            ? _value.dateCreation
            : dateCreation // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dateResolution: freezed == dateResolution
            ? _value.dateResolution
            : dateResolution // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        resolue: null == resolue
            ? _value.resolue
            : resolue // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlerteImpl implements _Alerte {
  const _$AlerteImpl({
    required this.id,
    required this.type,
    this.serviceId,
    required this.message,
    required this.niveau,
    required this.dateCreation,
    this.dateResolution,
    this.resolue = false,
  });

  factory _$AlerteImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlerteImplFromJson(json);

  @override
  final String id;
  @override
  final TypeAlerte type;
  @override
  final String? serviceId;
  @override
  final String message;
  @override
  final NiveauAlerte niveau;
  @override
  final DateTime dateCreation;
  @override
  final DateTime? dateResolution;
  @override
  @JsonKey()
  final bool resolue;

  @override
  String toString() {
    return 'Alerte(id: $id, type: $type, serviceId: $serviceId, message: $message, niveau: $niveau, dateCreation: $dateCreation, dateResolution: $dateResolution, resolue: $resolue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlerteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.niveau, niveau) || other.niveau == niveau) &&
            (identical(other.dateCreation, dateCreation) ||
                other.dateCreation == dateCreation) &&
            (identical(other.dateResolution, dateResolution) ||
                other.dateResolution == dateResolution) &&
            (identical(other.resolue, resolue) || other.resolue == resolue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    serviceId,
    message,
    niveau,
    dateCreation,
    dateResolution,
    resolue,
  );

  /// Create a copy of Alerte
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlerteImplCopyWith<_$AlerteImpl> get copyWith =>
      __$$AlerteImplCopyWithImpl<_$AlerteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlerteImplToJson(this);
  }
}

abstract class _Alerte implements Alerte {
  const factory _Alerte({
    required final String id,
    required final TypeAlerte type,
    final String? serviceId,
    required final String message,
    required final NiveauAlerte niveau,
    required final DateTime dateCreation,
    final DateTime? dateResolution,
    final bool resolue,
  }) = _$AlerteImpl;

  factory _Alerte.fromJson(Map<String, dynamic> json) = _$AlerteImpl.fromJson;

  @override
  String get id;
  @override
  TypeAlerte get type;
  @override
  String? get serviceId;
  @override
  String get message;
  @override
  NiveauAlerte get niveau;
  @override
  DateTime get dateCreation;
  @override
  DateTime? get dateResolution;
  @override
  bool get resolue;

  /// Create a copy of Alerte
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlerteImplCopyWith<_$AlerteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
