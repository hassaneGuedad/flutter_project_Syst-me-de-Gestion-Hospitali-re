// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'historique_depense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HistoriqueDepense _$HistoriqueDepenseFromJson(Map<String, dynamic> json) {
  return _HistoriqueDepense.fromJson(json);
}

/// @nodoc
mixin _$HistoriqueDepense {
  String get id => throw _privateConstructorUsedError;
  String get serviceId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  double get montant => throw _privateConstructorUsedError;
  TypeDepense get typeDepense => throw _privateConstructorUsedError;
  String? get soinId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this HistoriqueDepense to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HistoriqueDepense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HistoriqueDepenseCopyWith<HistoriqueDepense> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoriqueDepenseCopyWith<$Res> {
  factory $HistoriqueDepenseCopyWith(
    HistoriqueDepense value,
    $Res Function(HistoriqueDepense) then,
  ) = _$HistoriqueDepenseCopyWithImpl<$Res, HistoriqueDepense>;
  @useResult
  $Res call({
    String id,
    String serviceId,
    DateTime date,
    double montant,
    TypeDepense typeDepense,
    String? soinId,
    String? description,
  });
}

/// @nodoc
class _$HistoriqueDepenseCopyWithImpl<$Res, $Val extends HistoriqueDepense>
    implements $HistoriqueDepenseCopyWith<$Res> {
  _$HistoriqueDepenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HistoriqueDepense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceId = null,
    Object? date = null,
    Object? montant = null,
    Object? typeDepense = null,
    Object? soinId = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            serviceId: null == serviceId
                ? _value.serviceId
                : serviceId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            montant: null == montant
                ? _value.montant
                : montant // ignore: cast_nullable_to_non_nullable
                      as double,
            typeDepense: null == typeDepense
                ? _value.typeDepense
                : typeDepense // ignore: cast_nullable_to_non_nullable
                      as TypeDepense,
            soinId: freezed == soinId
                ? _value.soinId
                : soinId // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HistoriqueDepenseImplCopyWith<$Res>
    implements $HistoriqueDepenseCopyWith<$Res> {
  factory _$$HistoriqueDepenseImplCopyWith(
    _$HistoriqueDepenseImpl value,
    $Res Function(_$HistoriqueDepenseImpl) then,
  ) = __$$HistoriqueDepenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String serviceId,
    DateTime date,
    double montant,
    TypeDepense typeDepense,
    String? soinId,
    String? description,
  });
}

/// @nodoc
class __$$HistoriqueDepenseImplCopyWithImpl<$Res>
    extends _$HistoriqueDepenseCopyWithImpl<$Res, _$HistoriqueDepenseImpl>
    implements _$$HistoriqueDepenseImplCopyWith<$Res> {
  __$$HistoriqueDepenseImplCopyWithImpl(
    _$HistoriqueDepenseImpl _value,
    $Res Function(_$HistoriqueDepenseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HistoriqueDepense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceId = null,
    Object? date = null,
    Object? montant = null,
    Object? typeDepense = null,
    Object? soinId = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _$HistoriqueDepenseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        serviceId: null == serviceId
            ? _value.serviceId
            : serviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        montant: null == montant
            ? _value.montant
            : montant // ignore: cast_nullable_to_non_nullable
                  as double,
        typeDepense: null == typeDepense
            ? _value.typeDepense
            : typeDepense // ignore: cast_nullable_to_non_nullable
                  as TypeDepense,
        soinId: freezed == soinId
            ? _value.soinId
            : soinId // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoriqueDepenseImpl implements _HistoriqueDepense {
  const _$HistoriqueDepenseImpl({
    required this.id,
    required this.serviceId,
    required this.date,
    required this.montant,
    required this.typeDepense,
    this.soinId,
    this.description,
  });

  factory _$HistoriqueDepenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoriqueDepenseImplFromJson(json);

  @override
  final String id;
  @override
  final String serviceId;
  @override
  final DateTime date;
  @override
  final double montant;
  @override
  final TypeDepense typeDepense;
  @override
  final String? soinId;
  @override
  final String? description;

  @override
  String toString() {
    return 'HistoriqueDepense(id: $id, serviceId: $serviceId, date: $date, montant: $montant, typeDepense: $typeDepense, soinId: $soinId, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoriqueDepenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.montant, montant) || other.montant == montant) &&
            (identical(other.typeDepense, typeDepense) ||
                other.typeDepense == typeDepense) &&
            (identical(other.soinId, soinId) || other.soinId == soinId) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    serviceId,
    date,
    montant,
    typeDepense,
    soinId,
    description,
  );

  /// Create a copy of HistoriqueDepense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoriqueDepenseImplCopyWith<_$HistoriqueDepenseImpl> get copyWith =>
      __$$HistoriqueDepenseImplCopyWithImpl<_$HistoriqueDepenseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoriqueDepenseImplToJson(this);
  }
}

abstract class _HistoriqueDepense implements HistoriqueDepense {
  const factory _HistoriqueDepense({
    required final String id,
    required final String serviceId,
    required final DateTime date,
    required final double montant,
    required final TypeDepense typeDepense,
    final String? soinId,
    final String? description,
  }) = _$HistoriqueDepenseImpl;

  factory _HistoriqueDepense.fromJson(Map<String, dynamic> json) =
      _$HistoriqueDepenseImpl.fromJson;

  @override
  String get id;
  @override
  String get serviceId;
  @override
  DateTime get date;
  @override
  double get montant;
  @override
  TypeDepense get typeDepense;
  @override
  String? get soinId;
  @override
  String? get description;

  /// Create a copy of HistoriqueDepense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoriqueDepenseImplCopyWith<_$HistoriqueDepenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
