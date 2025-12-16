# 🏥 Architecture Financière - Système d'Anticipation des Coûts Hospitaliers

## 📋 Vue d'Ensemble

Ce document décrit l'architecture complète du système d'anticipation financière des soins hospitaliers, intégré à l'application existante.

## 🎯 Objectifs

1. **Analyse Financière** : Suivi détaillé des coûts (personnel, matériel, consommables)
2. **Prévision** : Anticipation des dépenses futures basée sur l'historique
3. **Aide à la Décision** : Tableaux de bord pour le service financier
4. **Alertes** : Détection automatique de dépassements budgétaires
5. **Rapports** : Génération de rapports PDF mensuels

## 🏗️ Architecture Backend (Spring Boot)

### 1. Entités JPA

#### CoûtSoin (Détail des coûts d'un soin)
```java
- id: Long
- soinId: Long (FK vers Soin)
- coutPersonnel: Double (coût du personnel médical)
- coutMateriel: Double (équipements utilisés)
- coutConsommables: Double (médicaments, fournitures)
- coutTotal: Double (somme des trois)
- dateCalcul: LocalDateTime
```

#### BudgetService (Budget prévisionnel par service)
```java
- id: Long
- serviceId: Long (FK vers Service)
- periode: LocalDate (mois/année)
- budgetPrevu: Double
- budgetReel: Double (calculé à partir des dépenses)
- ecart: Double (différence)
- statut: Enum (DANS_BUDGET, DEPASSE, ALERTE)
```

#### HistoriqueDepense (Historique des dépenses)
```java
- id: Long
- serviceId: Long
- date: LocalDate
- montant: Double
- typeDepense: Enum (PERSONNEL, MATERIEL, CONSOMMABLES)
- soinId: Long (optionnel, pour traçabilité)
```

#### Alerte (Système d'alertes)
```java
- id: Long
- type: Enum (DEPASSEMENT_BUDGET, ANOMALIE_COUT, TENDANCE_ALARMANTE)
- serviceId: Long
- message: String
- niveau: Enum (INFO, WARNING, CRITIQUE)
- dateCreation: LocalDateTime
- dateResolution: LocalDateTime (optionnel)
- resolue: Boolean
```

### 2. Services Métier

#### FinanceService
- `calculerCoutSoin(Soin soin)` : Calcule le coût détaillé d'un soin
- `calculerBudgetReel(Long serviceId, LocalDate periode)` : Calcule le budget réel
- `detecterDepassement(Long serviceId)` : Détecte les dépassements
- `genererRapportMensuel(LocalDate mois)` : Génère un rapport PDF

#### PrevisionService
- `prevoirDepenses(Long serviceId, int mois)` : Prévision par moyenne mobile
- `prevoirDepensesTendance(Long serviceId, int mois)` : Prévision par tendance
- `simulerScenario(Long serviceId, Map<String, Double> parametres)` : Simulation what-if
- `calculerTendance(Long serviceId)` : Calcule la tendance des dépenses

#### AlerteService
- `creerAlerte(Alerte alerte)` : Crée une alerte
- `getAlertesActives()` : Récupère les alertes non résolues
- `resoudreAlerte(Long id)` : Marque une alerte comme résolue

### 3. Contrôleurs REST

#### FinanceController
```
GET  /api/finance/cout-soin/{soinId}          - Détails des coûts d'un soin
GET  /api/finance/budget-service/{serviceId}  - Budget d'un service
GET  /api/finance/historique/{serviceId}      - Historique des dépenses
POST /api/finance/calculer-cout              - Calculer le coût d'un soin
GET  /api/finance/rapport-mensuel/{mois}     - Générer rapport PDF
```

#### PrevisionController
```
GET  /api/prevision/{serviceId}?mois=3       - Prévision sur N mois
GET  /api/prevision/tendance/{serviceId}     - Tendance des dépenses
POST /api/prevision/simuler                  - Simulation de scénario
GET  /api/prevision/comparaison/{serviceId}  - Comparaison prévu vs réel
```

#### AlerteController
```
GET  /api/alertes                            - Liste des alertes actives
GET  /api/alertes/service/{serviceId}        - Alertes d'un service
POST /api/alertes/{id}/resoudre              - Résoudre une alerte
GET  /api/alertes/statistiques                - Statistiques des alertes
```

## 🎨 Architecture Frontend (Flutter)

### 1. Modèles de Données

#### CoûtSoin (Domain)
```dart
@freezed
class CoûtSoin {
  final String id;
  final String soinId;
  final double coutPersonnel;
  final double coutMateriel;
  final double coutConsommables;
  final double coutTotal;
  final DateTime dateCalcul;
}
```

#### BudgetService (Domain)
```dart
@freezed
class BudgetService {
  final String id;
  final String serviceId;
  final DateTime periode;
  final double budgetPrevu;
  final double budgetReel;
  final double ecart;
  final StatutBudget statut;
}

enum StatutBudget { dansBudget, depasse, alerte }
```

#### Prevision (Domain)
```dart
@freezed
class Prevision {
  final String serviceId;
  final List<PointPrevision> points;
  final double moyenneMobile;
  final double tendance;
  final double confiance;
}

@freezed
class PointPrevision {
  final DateTime date;
  final double montantPrevu;
  final double? montantReel;
}
```

### 2. Features Flutter

#### finance/
- `data/` : Repository implémentations, API clients
- `domain/` : Entités, repository interfaces
- `presentation/` : 
  - `finance_dashboard_screen.dart` : Dashboard financier avancé
  - `cout_detail_screen.dart` : Détails des coûts
  - `historique_screen.dart` : Historique des dépenses
  - `prevision_screen.dart` : Prévisions et simulations

#### alertes/
- `presentation/` :
  - `alertes_screen.dart` : Liste des alertes
  - `alerte_detail_screen.dart` : Détails d'une alerte

#### rapports/
- `presentation/` :
  - `rapports_screen.dart` : Liste des rapports
  - `rapport_pdf_viewer.dart` : Visualisation PDF

### 3. Dashboard Amélioré

#### Composants
- **KPI Cards** : Budget total, Coût réel, Écart, Taux d'utilisation
- **Graphiques** :
  - Courbe de tendance des dépenses
  - Comparaison Budget vs Réel
  - Répartition des coûts (personnel/matériel/consommables)
  - Prévisions sur 3/6/12 mois
- **Tableaux** :
  - Top services par coût
  - Alertes actives
  - Dépenses récentes
- **Filtres** : Par période, service, type de coût

## 🔐 Sécurité

### Rôles
- **ADMIN** : Accès complet
- **FINANCIER** : Accès aux données financières, rapports, alertes
- **MEDECIN** : Accès limité (lecture seule des coûts)

### JWT
- Token avec expiration (24h)
- Refresh token pour renouvellement
- Claims : userId, roles, permissions

## 📊 Algorithmes d'Anticipation

### 1. Moyenne Mobile Simple
```
Prévision(n+1) = (Dépense(n) + Dépense(n-1) + ... + Dépense(n-k+1)) / k
```
Où k = nombre de périodes (ex: 3 mois)

### 2. Moyenne Mobile Pondérée
```
Prévision(n+1) = Σ(Dépense(i) * Poids(i)) / Σ(Poids(i))
```
Les périodes récentes ont plus de poids

### 3. Régression Linéaire (Tendance)
```
y = ax + b
```
Où y = dépense, x = période, a = pente, b = ordonnée

### 4. Détection d'Anomalies
- Écart-type : Dépense > moyenne + 2*écart-type = anomalie
- Variation : Variation > 20% par rapport au mois précédent

## 📄 Génération de Rapports PDF

### Structure du Rapport Mensuel
1. **En-tête** : Logo, période, date de génération
2. **Résumé Exécutif** : KPIs principaux
3. **Analyse par Service** : Budget vs Réel
4. **Top 10 Dépenses** : Les plus importantes
5. **Prévisions** : Pour les 3 prochains mois
6. **Alertes** : Liste des alertes du mois
7. **Graphiques** : Visualisations clés
8. **Recommandations** : Suggestions basées sur l'analyse

## 🚨 Système d'Alertes

### Types d'Alertes
1. **DEPASSEMENT_BUDGET** : Budget dépassé de >10%
2. **ANOMALIE_COUT** : Coût anormalement élevé
3. **TENDANCE_ALARMANTE** : Tendance à la hausse >15% sur 3 mois
4. **BUDGET_PROCHAIN_DEPASSE** : Prévision indique dépassement

### Niveaux
- **INFO** : Information (vert)
- **WARNING** : Attention (orange)
- **CRITIQUE** : Action requise (rouge)

## 📈 Métriques et KPIs

### KPIs Principaux
- Budget Total Mensuel
- Coût Réel Mensuel
- Écart Budgétaire
- Taux d'Utilisation Budget
- Coût Moyen par Soin
- Tendance des Dépenses (↑/↓/→)

### Métriques Secondaires
- Coût Personnel vs Matériel vs Consommables
- Top 5 Services par Coût
- Nombre d'Alertes Actives
- Précision des Prévisions

## 🔄 Flux de Données

```
Soin créé → FinanceService.calculerCoutSoin()
         → CoûtSoin créé
         → HistoriqueDepense mis à jour
         → BudgetService.budgetReel recalculé
         → AlerteService.vérifierDepassement()
         → Alerte créée si nécessaire
```

## 🐳 Compatibilité Docker

Toutes les nouvelles entités et services sont compatibles avec l'infrastructure Docker existante. Aucune modification des fichiers Docker n'est nécessaire.

## 📝 Prochaines Étapes

1. ✅ Créer les entités JPA
2. ✅ Implémenter les services métier
3. ✅ Créer les contrôleurs REST
4. ✅ Développer les modèles Flutter
5. ✅ Améliorer le dashboard
6. ✅ Implémenter la génération PDF
7. ✅ Ajouter le système d'alertes
8. ✅ Intégrer JWT avec rôles

