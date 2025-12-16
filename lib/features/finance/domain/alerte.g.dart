// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alerte.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlerteImpl _$$AlerteImplFromJson(Map<String, dynamic> json) => _$AlerteImpl(
  id: json['id'] as String,
  type: $enumDecode(_$TypeAlerteEnumMap, json['type']),
  serviceId: json['serviceId'] as String?,
  message: json['message'] as String,
  niveau: $enumDecode(_$NiveauAlerteEnumMap, json['niveau']),
  dateCreation: DateTime.parse(json['dateCreation'] as String),
  dateResolution: json['dateResolution'] == null
      ? null
      : DateTime.parse(json['dateResolution'] as String),
  resolue: json['resolue'] as bool? ?? false,
);

Map<String, dynamic> _$$AlerteImplToJson(_$AlerteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$TypeAlerteEnumMap[instance.type]!,
      'serviceId': instance.serviceId,
      'message': instance.message,
      'niveau': _$NiveauAlerteEnumMap[instance.niveau]!,
      'dateCreation': instance.dateCreation.toIso8601String(),
      'dateResolution': instance.dateResolution?.toIso8601String(),
      'resolue': instance.resolue,
    };

const _$TypeAlerteEnumMap = {
  TypeAlerte.depassementBudget: 'DEPASSEMENT_BUDGET',
  TypeAlerte.anomalieCout: 'ANOMALIE_COUT',
  TypeAlerte.tendanceAlarmante: 'TENDANCE_ALARMANTE',
  TypeAlerte.budgetProchainDepasse: 'BUDGET_PROCHAIN_DEPASSE',
  TypeAlerte.variationAnormale: 'VARIATION_ANORMALE',
};

const _$NiveauAlerteEnumMap = {
  NiveauAlerte.info: 'INFO',
  NiveauAlerte.warning: 'WARNING',
  NiveauAlerte.critique: 'CRITIQUE',
};
