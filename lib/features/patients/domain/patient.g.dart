// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PatientImpl _$$PatientImplFromJson(Map<String, dynamic> json) =>
    _$PatientImpl(
      id: const _IntToStringConverter().fromJson(json['id']),
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      dateNaissance: DateTime.parse(json['dateNaissance'] as String),
      numeroSecuriteSociale: json['numeroSecuriteSociale'] as String,
      coutTotal: (json['coutTotal'] as num?)?.toDouble() ?? 0.0,
      soinIds:
          (json['soinIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PatientImplToJson(_$PatientImpl instance) =>
    <String, dynamic>{
      'id': const _IntToStringConverter().toJson(instance.id),
      'nom': instance.nom,
      'prenom': instance.prenom,
      'dateNaissance': instance.dateNaissance.toIso8601String(),
      'numeroSecuriteSociale': instance.numeroSecuriteSociale,
      'coutTotal': instance.coutTotal,
      'soinIds': instance.soinIds,
    };
