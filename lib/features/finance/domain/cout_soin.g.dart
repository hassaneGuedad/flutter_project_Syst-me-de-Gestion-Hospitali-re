// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cout_soin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoutSoinImpl _$$CoutSoinImplFromJson(Map<String, dynamic> json) =>
    _$CoutSoinImpl(
      id: json['id'] as String,
      soinId: json['soinId'] as String,
      coutPersonnel: (json['coutPersonnel'] as num).toDouble(),
      coutMateriel: (json['coutMateriel'] as num).toDouble(),
      coutConsommables: (json['coutConsommables'] as num).toDouble(),
      coutTotal: (json['coutTotal'] as num).toDouble(),
      dateCalcul: DateTime.parse(json['dateCalcul'] as String),
    );

Map<String, dynamic> _$$CoutSoinImplToJson(_$CoutSoinImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'soinId': instance.soinId,
      'coutPersonnel': instance.coutPersonnel,
      'coutMateriel': instance.coutMateriel,
      'coutConsommables': instance.coutConsommables,
      'coutTotal': instance.coutTotal,
      'dateCalcul': instance.dateCalcul.toIso8601String(),
    };
