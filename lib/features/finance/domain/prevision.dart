import 'package:freezed_annotation/freezed_annotation.dart';

part 'prevision.freezed.dart';
part 'prevision.g.dart';

@freezed
class Prevision with _$Prevision {
  const factory Prevision({
    required String serviceId,
    required List<PointPrevision> points,
    required String methode,
    @Default(0.0) double confiance,
  }) = _Prevision;

  factory Prevision.fromJson(Map<String, dynamic> json) => _$PrevisionFromJson(json);
}

@freezed
class PointPrevision with _$PointPrevision {
  const factory PointPrevision({
    required DateTime date,
    required double montantPrevu,
    double? montantReel,
  }) = _PointPrevision;

  factory PointPrevision.fromJson(Map<String, dynamic> json) => _$PointPrevisionFromJson(json);
}

