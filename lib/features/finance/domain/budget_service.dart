import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_service.freezed.dart';
part 'budget_service.g.dart';

@freezed
class BudgetService with _$BudgetService {
  const factory BudgetService({
    required String id,
    required String serviceId,
    required DateTime periode,
    required double budgetPrevu,
    required double budgetReel,
    required double ecart,
    required double tauxUtilisation,
    required StatutBudget statut,
  }) = _BudgetService;

  factory BudgetService.fromJson(Map<String, dynamic> json) => _$BudgetServiceFromJson(json);
}

enum StatutBudget {
  @JsonValue('DANS_BUDGET')
  dansBudget,
  @JsonValue('ALERTE')
  alerte,
  @JsonValue('DEPASSE')
  depasse,
}

