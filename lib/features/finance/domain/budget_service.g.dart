// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetServiceImpl _$$BudgetServiceImplFromJson(Map<String, dynamic> json) =>
    _$BudgetServiceImpl(
      id: json['id'] as String,
      serviceId: json['serviceId'] as String,
      periode: DateTime.parse(json['periode'] as String),
      budgetPrevu: (json['budgetPrevu'] as num).toDouble(),
      budgetReel: (json['budgetReel'] as num).toDouble(),
      ecart: (json['ecart'] as num).toDouble(),
      tauxUtilisation: (json['tauxUtilisation'] as num).toDouble(),
      statut: $enumDecode(_$StatutBudgetEnumMap, json['statut']),
    );

Map<String, dynamic> _$$BudgetServiceImplToJson(_$BudgetServiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceId': instance.serviceId,
      'periode': instance.periode.toIso8601String(),
      'budgetPrevu': instance.budgetPrevu,
      'budgetReel': instance.budgetReel,
      'ecart': instance.ecart,
      'tauxUtilisation': instance.tauxUtilisation,
      'statut': _$StatutBudgetEnumMap[instance.statut]!,
    };

const _$StatutBudgetEnumMap = {
  StatutBudget.dansBudget: 'DANS_BUDGET',
  StatutBudget.alerte: 'ALERTE',
  StatutBudget.depasse: 'DEPASSE',
};
