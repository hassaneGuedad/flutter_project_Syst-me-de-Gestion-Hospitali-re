package com.hospital.service;

import com.hospital.model.HistoriqueDepense;
import com.hospital.repository.HistoriqueDepenseRepository;
import com.hospital.repository.BudgetServiceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Service métier pour les prévisions financières.
 * Implémente les algorithmes d'anticipation : moyenne mobile, tendance, simulation.
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PrevisionService {

    private final HistoriqueDepenseRepository historiqueDepenseRepository;
    private final BudgetServiceRepository budgetServiceRepository;

    /**
     * Prévision par moyenne mobile simple.
     * 
     * @param serviceId ID du service
     * @param nombreMois Nombre de mois à prévoir
     * @param periodeMoyenne Nombre de périodes pour la moyenne (ex: 3 pour moyenne sur 3 mois)
     * @return Liste des prévisions
     */
    public List<PrevisionResult> prevoirDepensesMoyenneMobile(
            Long serviceId, int nombreMois, int periodeMoyenne) {
        
        // Récupérer les dépenses historiques
        LocalDate fin = LocalDate.now();
        LocalDate debut = fin.minusMonths(periodeMoyenne + nombreMois);
        
        List<HistoriqueDepense> depenses = historiqueDepenseRepository
            .findByServiceIdAndDateBetween(serviceId, debut, fin);
        
        // Grouper par mois
        Map<YearMonth, Double> depensesParMois = depenses.stream()
            .collect(Collectors.groupingBy(
                d -> YearMonth.from(d.getDate()),
                Collectors.summingDouble(d -> d.getMontant() != null ? d.getMontant() : 0.0)
            ));
        
        List<PrevisionResult> previsions = new ArrayList<>();
        
        // Calculer la moyenne mobile
        List<YearMonth> mois = depensesParMois.keySet().stream()
            .sorted()
            .collect(Collectors.toList());
        
        if (mois.size() < periodeMoyenne) {
            // Pas assez de données historiques
            return previsions;
        }
        
        // Calculer la moyenne des N derniers mois
        double moyenne = mois.stream()
            .skip(mois.size() - periodeMoyenne)
            .mapToDouble(depensesParMois::get)
            .average()
            .orElse(0.0);
        
        // Générer les prévisions
        YearMonth dernierMois = mois.get(mois.size() - 1);
        for (int i = 1; i <= nombreMois; i++) {
            YearMonth moisPrevision = dernierMois.plusMonths(i);
            previsions.add(new PrevisionResult(
                moisPrevision.atDay(1),
                moyenne,
                "Moyenne mobile (" + periodeMoyenne + " mois)"
            ));
        }
        
        return previsions;
    }

    /**
     * Prévision par moyenne mobile pondérée.
     * Les périodes récentes ont plus de poids.
     */
    public List<PrevisionResult> prevoirDepensesMoyenneMobilePonderee(
            Long serviceId, int nombreMois, int periodeMoyenne) {
        
        LocalDate fin = LocalDate.now();
        LocalDate debut = fin.minusMonths(periodeMoyenne + nombreMois);
        
        List<HistoriqueDepense> depenses = historiqueDepenseRepository
            .findByServiceIdAndDateBetween(serviceId, debut, fin);
        
        Map<YearMonth, Double> depensesParMois = depenses.stream()
            .collect(Collectors.groupingBy(
                d -> YearMonth.from(d.getDate()),
                Collectors.summingDouble(d -> d.getMontant() != null ? d.getMontant() : 0.0)
            ));
        
        List<PrevisionResult> previsions = new ArrayList<>();
        List<YearMonth> mois = depensesParMois.keySet().stream()
            .sorted()
            .collect(Collectors.toList());
        
        if (mois.size() < periodeMoyenne) {
            return previsions;
        }
        
        // Calculer la moyenne pondérée
        double sommePonderee = 0.0;
        double sommePoids = 0.0;
        
        List<YearMonth> derniersMois = mois.stream()
            .skip(mois.size() - periodeMoyenne)
            .collect(Collectors.toList());
        
        for (int i = 0; i < derniersMois.size(); i++) {
            double poids = i + 1; // Plus récent = plus de poids
            double montant = depensesParMois.get(derniersMois.get(i));
            sommePonderee += montant * poids;
            sommePoids += poids;
        }
        
        double moyennePonderee = sommePoids > 0 ? sommePonderee / sommePoids : 0.0;
        
        // Générer les prévisions
        YearMonth dernierMois = mois.get(mois.size() - 1);
        for (int i = 1; i <= nombreMois; i++) {
            YearMonth moisPrevision = dernierMois.plusMonths(i);
            previsions.add(new PrevisionResult(
                moisPrevision.atDay(1),
                moyennePonderee,
                "Moyenne mobile pondérée (" + periodeMoyenne + " mois)"
            ));
        }
        
        return previsions;
    }

    /**
     * Prévision par régression linéaire (tendance).
     * Calcule la tendance des dépenses et l'extrapole.
     */
    public List<PrevisionResult> prevoirDepensesTendance(
            Long serviceId, int nombreMois) {
        
        LocalDate fin = LocalDate.now();
        LocalDate debut = fin.minusMonths(12); // 12 mois d'historique
        
        List<HistoriqueDepense> depenses = historiqueDepenseRepository
            .findByServiceIdAndDateBetween(serviceId, debut, fin);
        
        Map<YearMonth, Double> depensesParMois = depenses.stream()
            .collect(Collectors.groupingBy(
                d -> YearMonth.from(d.getDate()),
                Collectors.summingDouble(d -> d.getMontant() != null ? d.getMontant() : 0.0)
            ));
        
        List<YearMonth> mois = depensesParMois.keySet().stream()
            .sorted()
            .collect(Collectors.toList());
        
        if (mois.size() < 3) {
            return new ArrayList<>();
        }
        
        // Calculer la régression linéaire y = ax + b
        int n = mois.size();
        double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
        
        for (int i = 0; i < n; i++) {
            double x = i;
            double y = depensesParMois.get(mois.get(i));
            sumX += x;
            sumY += y;
            sumXY += x * y;
            sumX2 += x * x;
        }
        
        // Calculer a (pente) et b (ordonnée à l'origine)
        double a = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
        double b = (sumY - a * sumX) / n;
        
        // Générer les prévisions
        List<PrevisionResult> previsions = new ArrayList<>();
        YearMonth dernierMois = mois.get(mois.size() - 1);
        
        for (int i = 1; i <= nombreMois; i++) {
            YearMonth moisPrevision = dernierMois.plusMonths(i);
            double x = n + i - 1;
            double y = a * x + b;
            
            // S'assurer que la prévision n'est pas négative
            y = Math.max(0, y);
            
            previsions.add(new PrevisionResult(
                moisPrevision.atDay(1),
                y,
                "Régression linéaire (tendance)"
            ));
        }
        
        return previsions;
    }

    /**
     * Calcule la tendance des dépenses (hausse, baisse, stable)
     */
    public TendanceResult calculerTendance(Long serviceId) {
        LocalDate fin = LocalDate.now();
        LocalDate debut = fin.minusMonths(3);
        
        List<HistoriqueDepense> depenses = historiqueDepenseRepository
            .findByServiceIdAndDateBetween(serviceId, debut, fin);
        
        Map<YearMonth, Double> depensesParMois = depenses.stream()
            .collect(Collectors.groupingBy(
                d -> YearMonth.from(d.getDate()),
                Collectors.summingDouble(d -> d.getMontant() != null ? d.getMontant() : 0.0)
            ));
        
        List<YearMonth> mois = depensesParMois.keySet().stream()
            .sorted()
            .collect(Collectors.toList());
        
        if (mois.size() < 2) {
            return new TendanceResult("STABLE", 0.0, "Données insuffisantes");
        }
        
        double dernier = depensesParMois.get(mois.get(mois.size() - 1));
        double avantDernier = depensesParMois.get(mois.get(mois.size() - 2));
        
        double variation = ((dernier - avantDernier) / avantDernier) * 100;
        
        String direction;
        if (variation > 5) {
            direction = "HAUSSE";
        } else if (variation < -5) {
            direction = "BAISSE";
        } else {
            direction = "STABLE";
        }
        
        return new TendanceResult(
            direction,
            variation,
            String.format("Variation de %.1f%%", variation)
        );
    }

    /**
     * Simule un scénario what-if
     */
    public List<PrevisionResult> simulerScenario(
            Long serviceId, Map<String, Double> parametres) {
        
        // Récupérer la prévision de base
        List<PrevisionResult> previsionsBase = prevoirDepensesMoyenneMobile(
            serviceId, 3, 3);
        
        // Appliquer les paramètres de simulation
        double facteurAugmentation = parametres.getOrDefault("facteurAugmentation", 1.0);
        double variationPersonnel = parametres.getOrDefault("variationPersonnel", 0.0);
        double variationMateriel = parametres.getOrDefault("variationMateriel", 0.0);
        
        return previsionsBase.stream()
            .map(p -> {
                double nouveauMontant = p.montant * facteurAugmentation;
                nouveauMontant += variationPersonnel + variationMateriel;
                return new PrevisionResult(
                    p.date,
                    Math.max(0, nouveauMontant),
                    "Simulation: " + p.methode
                );
            })
            .collect(Collectors.toList());
    }

    /**
     * Classe interne pour les résultats de prévision
     */
    public static class PrevisionResult {
        public LocalDate date;
        public double montant;
        public String methode;

        public PrevisionResult(LocalDate date, double montant, String methode) {
            this.date = date;
            this.montant = montant;
            this.methode = methode;
        }
    }

    /**
     * Classe interne pour les résultats de tendance
     */
    public static class TendanceResult {
        public String direction; // HAUSSE, BAISSE, STABLE
        public double variationPourcentage;
        public String description;

        public TendanceResult(String direction, double variationPourcentage, String description) {
            this.direction = direction;
            this.variationPourcentage = variationPourcentage;
            this.description = description;
        }
    }
}

