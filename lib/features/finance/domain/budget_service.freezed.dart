// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BudgetService _$BudgetServiceFromJson(Map<String, dynamic> json) {
  return _BudgetService.fromJson(json);
}

/// @nodoc
mixin _$BudgetService {
  String get id => throw _privateConstructorUsedError;
  String get serviceId => throw _privateConstructorUsedError;
  DateTime get periode => throw _privateConstructorUsedError;
  double get budgetPrevu => throw _privateConstructorUsedError;
  double get budgetReel => throw _privateConstructorUsedError;
  double get ecart => throw _privateConstructorUsedError;
  double get tauxUtilisation => throw _privateConstructorUsedError;
  StatutBudget get statut => throw _privateConstructorUsedError;

  /// Serializes this BudgetService to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BudgetService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetServiceCopyWith<BudgetService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetServiceCopyWith<$Res> {
  factory $BudgetServiceCopyWith(
    BudgetService value,
    $Res Function(BudgetService) then,
  ) = _$BudgetServiceCopyWithImpl<$Res, BudgetService>;
  @useResult
  $Res call({
    String id,
    String serviceId,
    DateTime periode,
    double budgetPrevu,
    double budgetReel,
    double ecart,
    double tauxUtilisation,
    StatutBudget statut,
  });
}

/// @nodoc
class _$BudgetServiceCopyWithImpl<$Res, $Val extends BudgetService>
    implements $BudgetServiceCopyWith<$Res> {
  _$BudgetServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceId = null,
    Object? periode = null,
    Object? budgetPrevu = null,
    Object? budgetReel = null,
    Object? ecart = null,
    Object? tauxUtilisation = null,
    Object? statut = null,
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
            periode: null == periode
                ? _value.periode
                : periode // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            budgetPrevu: null == budgetPrevu
                ? _value.budgetPrevu
                : budgetPrevu // ignore: cast_nullable_to_non_nullable
                      as double,
            budgetReel: null == budgetReel
                ? _value.budgetReel
                : budgetReel // ignore: cast_nullable_to_non_nullable
                      as double,
            ecart: null == ecart
                ? _value.ecart
                : ecart // ignore: cast_nullable_to_non_nullable
                      as double,
            tauxUtilisation: null == tauxUtilisation
                ? _value.tauxUtilisation
                : tauxUtilisation // ignore: cast_nullable_to_non_nullable
                      as double,
            statut: null == statut
                ? _value.statut
                : statut // ignore: cast_nullable_to_non_nullable
                      as StatutBudget,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BudgetServiceImplCopyWith<$Res>
    implements $BudgetServiceCopyWith<$Res> {
  factory _$$BudgetServiceImplCopyWith(
    _$BudgetServiceImpl value,
    $Res Function(_$BudgetServiceImpl) then,
  ) = __$$BudgetServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String serviceId,
    DateTime periode,
    double budgetPrevu,
    double budgetReel,
    double ecart,
    double tauxUtilisation,
    StatutBudget statut,
  });
}

/// @nodoc
class __$$BudgetServiceImplCopyWithImpl<$Res>
    extends _$BudgetServiceCopyWithImpl<$Res, _$BudgetServiceImpl>
    implements _$$BudgetServiceImplCopyWith<$Res> {
  __$$BudgetServiceImplCopyWithImpl(
    _$BudgetServiceImpl _value,
    $Res Function(_$BudgetServiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BudgetService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceId = null,
    Object? periode = null,
    Object? budgetPrevu = null,
    Object? budgetReel = null,
    Object? ecart = null,
    Object? tauxUtilisation = null,
    Object? statut = null,
  }) {
    return _then(
      _$BudgetServiceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        serviceId: null == serviceId
            ? _value.serviceId
            : serviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        periode: null == periode
            ? _value.periode
            : periode // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        budgetPrevu: null == budgetPrevu
            ? _value.budgetPrevu
            : budgetPrevu // ignore: cast_nullable_to_non_nullable
                  as double,
        budgetReel: null == budgetReel
            ? _value.budgetReel
            : budgetReel // ignore: cast_nullable_to_non_nullable
                  as double,
        ecart: null == ecart
            ? _value.ecart
            : ecart // ignore: cast_nullable_to_non_nullable
                  as double,
        tauxUtilisation: null == tauxUtilisation
            ? _value.tauxUtilisation
            : tauxUtilisation // ignore: cast_nullable_to_non_nullable
                  as double,
        statut: null == statut
            ? _value.statut
            : statut // ignore: cast_nullable_to_non_nullable
                  as StatutBudget,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BudgetServiceImpl implements _BudgetService {
  const _$BudgetServiceImpl({
    required this.id,
    required this.serviceId,
    required this.periode,
    required this.budgetPrevu,
    required this.budgetReel,
    required this.ecart,
    required this.tauxUtilisation,
    required this.statut,
  });

  factory _$BudgetServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetServiceImplFromJson(json);

  @override
  final String id;
  @override
  final String serviceId;
  @override
  final DateTime periode;
  @override
  final double budgetPrevu;
  @override
  final double budgetReel;
  @override
  final double ecart;
  @override
  final double tauxUtilisation;
  @override
  final StatutBudget statut;

  @override
  String toString() {
    return 'BudgetService(id: $id, serviceId: $serviceId, periode: $periode, budgetPrevu: $budgetPrevu, budgetReel: $budgetReel, ecart: $ecart, tauxUtilisation: $tauxUtilisation, statut: $statut)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetServiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.periode, periode) || other.periode == periode) &&
            (identical(other.budgetPrevu, budgetPrevu) ||
                other.budgetPrevu == budgetPrevu) &&
            (identical(other.budgetReel, budgetReel) ||
                other.budgetReel == budgetReel) &&
            (identical(other.ecart, ecart) || other.ecart == ecart) &&
            (identical(other.tauxUtilisation, tauxUtilisation) ||
                other.tauxUtilisation == tauxUtilisation) &&
            (identical(other.statut, statut) || other.statut == statut));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    serviceId,
    periode,
    budgetPrevu,
    budgetReel,
    ecart,
    tauxUtilisation,
    statut,
  );

  /// Create a copy of BudgetService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetServiceImplCopyWith<_$BudgetServiceImpl> get copyWith =>
      __$$BudgetServiceImplCopyWithImpl<_$BudgetServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetServiceImplToJson(this);
  }
}

abstract class _BudgetService implements BudgetService {
  const factory _BudgetService({
    required final String id,
    required final String serviceId,
    required final DateTime periode,
    required final double budgetPrevu,
    required final double budgetReel,
    required final double ecart,
    required final double tauxUtilisation,
    required final StatutBudget statut,
  }) = _$BudgetServiceImpl;

  factory _BudgetService.fromJson(Map<String, dynamic> json) =
      _$BudgetServiceImpl.fromJson;

  @override
  String get id;
  @override
  String get serviceId;
  @override
  DateTime get periode;
  @override
  double get budgetPrevu;
  @override
  double get budgetReel;
  @override
  double get ecart;
  @override
  double get tauxUtilisation;
  @override
  StatutBudget get statut;

  /// Create a copy of BudgetService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetServiceImplCopyWith<_$BudgetServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
