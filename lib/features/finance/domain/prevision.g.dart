// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prevision.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrevisionImpl _$$PrevisionImplFromJson(Map<String, dynamic> json) =>
    _$PrevisionImpl(
      serviceId: json['serviceId'] as String,
      points: (json['points'] as List<dynamic>)
          .map((e) => PointPrevision.fromJson(e as Map<String, dynamic>))
          .toList(),
      methode: json['methode'] as String,
      confiance: (json['confiance'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$PrevisionImplToJson(_$PrevisionImpl instance) =>
    <String, dynamic>{
      'serviceId': instance.serviceId,
      'points': instance.points,
      'methode': instance.methode,
      'confiance': instance.confiance,
    };

_$PointPrevisionImpl _$$PointPrevisionImplFromJson(Map<String, dynamic> json) =>
    _$PointPrevisionImpl(
      date: DateTime.parse(json['date'] as String),
      montantPrevu: (json['montantPrevu'] as num).toDouble(),
      montantReel: (json['montantReel'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$PointPrevisionImplToJson(
  _$PointPrevisionImpl instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'montantPrevu': instance.montantPrevu,
  'montantReel': instance.montantReel,
};
