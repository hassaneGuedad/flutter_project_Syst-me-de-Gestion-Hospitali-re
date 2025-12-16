import 'package:freezed_annotation/freezed_annotation.dart';

part 'historique_depense.freezed.dart';
part 'historique_depense.g.dart';

@freezed
class HistoriqueDepense with _$HistoriqueDepense {
  const factory HistoriqueDepense({
    required String id,
    required String serviceId,
    required DateTime date,
    required double montant,
    required TypeDepense typeDepense,
    String? soinId,
    String? description,
  }) = _HistoriqueDepense;

  factory HistoriqueDepense.fromJson(Map<String, dynamic> json) => _$HistoriqueDepenseFromJson(json);
}

enum TypeDepense {
  @JsonValue('PERSONNEL')
  personnel,
  @JsonValue('MATERIEL')
  materiel,
  @JsonValue('CONSOMMABLES')
  consommables,
}

