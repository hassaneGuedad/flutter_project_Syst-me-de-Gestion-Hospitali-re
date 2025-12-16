import 'package:freezed_annotation/freezed_annotation.dart';

part 'alerte.freezed.dart';
part 'alerte.g.dart';

@freezed
class Alerte with _$Alerte {
  const factory Alerte({
    required String id,
    required TypeAlerte type,
    String? serviceId,
    required String message,
    required NiveauAlerte niveau,
    required DateTime dateCreation,
    DateTime? dateResolution,
    @Default(false) bool resolue,
  }) = _Alerte;

  factory Alerte.fromJson(Map<String, dynamic> json) => _$AlerteFromJson(json);
}

enum TypeAlerte {
  @JsonValue('DEPASSEMENT_BUDGET')
  depassementBudget,
  @JsonValue('ANOMALIE_COUT')
  anomalieCout,
  @JsonValue('TENDANCE_ALARMANTE')
  tendanceAlarmante,
  @JsonValue('BUDGET_PROCHAIN_DEPASSE')
  budgetProchainDepasse,
  @JsonValue('VARIATION_ANORMALE')
  variationAnormale,
}

enum NiveauAlerte {
  @JsonValue('INFO')
  info,
  @JsonValue('WARNING')
  warning,
  @JsonValue('CRITIQUE')
  critique,
}

