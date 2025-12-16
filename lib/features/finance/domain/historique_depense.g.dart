// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historique_depense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoriqueDepenseImpl _$$HistoriqueDepenseImplFromJson(
  Map<String, dynamic> json,
) => _$HistoriqueDepenseImpl(
  id: json['id'] as String,
  serviceId: json['serviceId'] as String,
  date: DateTime.parse(json['date'] as String),
  montant: (json['montant'] as num).toDouble(),
  typeDepense: $enumDecode(_$TypeDepenseEnumMap, json['typeDepense']),
  soinId: json['soinId'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$$HistoriqueDepenseImplToJson(
  _$HistoriqueDepenseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'serviceId': instance.serviceId,
  'date': instance.date.toIso8601String(),
  'montant': instance.montant,
  'typeDepense': _$TypeDepenseEnumMap[instance.typeDepense]!,
  'soinId': instance.soinId,
  'description': instance.description,
};

const _$TypeDepenseEnumMap = {
  TypeDepense.personnel: 'PERSONNEL',
  TypeDepense.materiel: 'MATERIEL',
  TypeDepense.consommables: 'CONSOMMABLES',
};
