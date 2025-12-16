import 'package:freezed_annotation/freezed_annotation.dart';

part 'cout_soin.freezed.dart';
part 'cout_soin.g.dart';

@freezed
class CoutSoin with _$CoutSoin {
  const factory CoutSoin({
    required String id,
    required String soinId,
    required double coutPersonnel,
    required double coutMateriel,
    required double coutConsommables,
    required double coutTotal,
    required DateTime dateCalcul,
  }) = _CoutSoin;

  factory CoutSoin.fromJson(Map<String, dynamic> json) => _$CoutSoinFromJson(json);
}

