// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Patient _$PatientFromJson(Map<String, dynamic> json) {
  return _Patient.fromJson(json);
}

/// @nodoc
mixin _$Patient {
  @_IntToStringConverter()
  String get id => throw _privateConstructorUsedError;
  String get nom => throw _privateConstructorUsedError;
  String get prenom => throw _privateConstructorUsedError;
  DateTime get dateNaissance => throw _privateConstructorUsedError;
  String get numeroSecuriteSociale => throw _privateConstructorUsedError;
  double get coutTotal => throw _privateConstructorUsedError;
  List<String> get soinIds => throw _privateConstructorUsedError;

  /// Serializes this Patient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PatientCopyWith<Patient> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PatientCopyWith<$Res> {
  factory $PatientCopyWith(Patient value, $Res Function(Patient) then) =
      _$PatientCopyWithImpl<$Res, Patient>;
  @useResult
  $Res call({
    @_IntToStringConverter() String id,
    String nom,
    String prenom,
    DateTime dateNaissance,
    String numeroSecuriteSociale,
    double coutTotal,
    List<String> soinIds,
  });
}

/// @nodoc
class _$PatientCopyWithImpl<$Res, $Val extends Patient>
    implements $PatientCopyWith<$Res> {
  _$PatientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nom = null,
    Object? prenom = null,
    Object? dateNaissance = null,
    Object? numeroSecuriteSociale = null,
    Object? coutTotal = null,
    Object? soinIds = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            nom: null == nom
                ? _value.nom
                : nom // ignore: cast_nullable_to_non_nullable
                      as String,
            prenom: null == prenom
                ? _value.prenom
                : prenom // ignore: cast_nullable_to_non_nullable
                      as String,
            dateNaissance: null == dateNaissance
                ? _value.dateNaissance
                : dateNaissance // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            numeroSecuriteSociale: null == numeroSecuriteSociale
                ? _value.numeroSecuriteSociale
                : numeroSecuriteSociale // ignore: cast_nullable_to_non_nullable
                      as String,
            coutTotal: null == coutTotal
                ? _value.coutTotal
                : coutTotal // ignore: cast_nullable_to_non_nullable
                      as double,
            soinIds: null == soinIds
                ? _value.soinIds
                : soinIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PatientImplCopyWith<$Res> implements $PatientCopyWith<$Res> {
  factory _$$PatientImplCopyWith(
    _$PatientImpl value,
    $Res Function(_$PatientImpl) then,
  ) = __$$PatientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @_IntToStringConverter() String id,
    String nom,
    String prenom,
    DateTime dateNaissance,
    String numeroSecuriteSociale,
    double coutTotal,
    List<String> soinIds,
  });
}

/// @nodoc
class __$$PatientImplCopyWithImpl<$Res>
    extends _$PatientCopyWithImpl<$Res, _$PatientImpl>
    implements _$$PatientImplCopyWith<$Res> {
  __$$PatientImplCopyWithImpl(
    _$PatientImpl _value,
    $Res Function(_$PatientImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nom = null,
    Object? prenom = null,
    Object? dateNaissance = null,
    Object? numeroSecuriteSociale = null,
    Object? coutTotal = null,
    Object? soinIds = null,
  }) {
    return _then(
      _$PatientImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        nom: null == nom
            ? _value.nom
            : nom // ignore: cast_nullable_to_non_nullable
                  as String,
        prenom: null == prenom
            ? _value.prenom
            : prenom // ignore: cast_nullable_to_non_nullable
                  as String,
        dateNaissance: null == dateNaissance
            ? _value.dateNaissance
            : dateNaissance // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        numeroSecuriteSociale: null == numeroSecuriteSociale
            ? _value.numeroSecuriteSociale
            : numeroSecuriteSociale // ignore: cast_nullable_to_non_nullable
                  as String,
        coutTotal: null == coutTotal
            ? _value.coutTotal
            : coutTotal // ignore: cast_nullable_to_non_nullable
                  as double,
        soinIds: null == soinIds
            ? _value._soinIds
            : soinIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PatientImpl implements _Patient {
  const _$PatientImpl({
    @_IntToStringConverter() required this.id,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.numeroSecuriteSociale,
    this.coutTotal = 0.0,
    final List<String> soinIds = const [],
  }) : _soinIds = soinIds;

  factory _$PatientImpl.fromJson(Map<String, dynamic> json) =>
      _$$PatientImplFromJson(json);

  @override
  @_IntToStringConverter()
  final String id;
  @override
  final String nom;
  @override
  final String prenom;
  @override
  final DateTime dateNaissance;
  @override
  final String numeroSecuriteSociale;
  @override
  @JsonKey()
  final double coutTotal;
  final List<String> _soinIds;
  @override
  @JsonKey()
  List<String> get soinIds {
    if (_soinIds is EqualUnmodifiableListView) return _soinIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_soinIds);
  }

  @override
  String toString() {
    return 'Patient(id: $id, nom: $nom, prenom: $prenom, dateNaissance: $dateNaissance, numeroSecuriteSociale: $numeroSecuriteSociale, coutTotal: $coutTotal, soinIds: $soinIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.prenom, prenom) || other.prenom == prenom) &&
            (identical(other.dateNaissance, dateNaissance) ||
                other.dateNaissance == dateNaissance) &&
            (identical(other.numeroSecuriteSociale, numeroSecuriteSociale) ||
                other.numeroSecuriteSociale == numeroSecuriteSociale) &&
            (identical(other.coutTotal, coutTotal) ||
                other.coutTotal == coutTotal) &&
            const DeepCollectionEquality().equals(other._soinIds, _soinIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nom,
    prenom,
    dateNaissance,
    numeroSecuriteSociale,
    coutTotal,
    const DeepCollectionEquality().hash(_soinIds),
  );

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PatientImplCopyWith<_$PatientImpl> get copyWith =>
      __$$PatientImplCopyWithImpl<_$PatientImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PatientImplToJson(this);
  }
}

abstract class _Patient implements Patient {
  const factory _Patient({
    @_IntToStringConverter() required final String id,
    required final String nom,
    required final String prenom,
    required final DateTime dateNaissance,
    required final String numeroSecuriteSociale,
    final double coutTotal,
    final List<String> soinIds,
  }) = _$PatientImpl;

  factory _Patient.fromJson(Map<String, dynamic> json) = _$PatientImpl.fromJson;

  @override
  @_IntToStringConverter()
  String get id;
  @override
  String get nom;
  @override
  String get prenom;
  @override
  DateTime get dateNaissance;
  @override
  String get numeroSecuriteSociale;
  @override
  double get coutTotal;
  @override
  List<String> get soinIds;

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PatientImplCopyWith<_$PatientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
