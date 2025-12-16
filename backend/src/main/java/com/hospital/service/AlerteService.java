package com.hospital.service;

import com.hospital.model.Alerte;
import com.hospital.model.BudgetService;
import com.hospital.repository.AlerteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Service métier pour la gestion des alertes financières.
 */
@Service
@RequiredArgsConstructor
@Transactional
public class AlerteService {

    private final AlerteRepository alerteRepository;

    /**
     * Vérifie si un budget est dépassé et crée une alerte si nécessaire
     */
    public void verifierDepassementBudget(BudgetService budget) {
        if (budget.getTauxUtilisation() == null || budget.getStatut() == null) {
            return;
        }

        // Vérifier si déjà une alerte active pour ce budget
        List<Alerte> alertesExistantes = alerteRepository
            .findByServiceIdAndResolueFalseOrderByDateCreationDesc(budget.getServiceId());
        
        boolean alerteExiste = alertesExistantes.stream()
            .anyMatch(a -> a.getType() == Alerte.TypeAlerte.DEPASSEMENT_BUDGET);

        if (budget.getStatut() == BudgetService.StatutBudget.DEPASSE) {
            if (!alerteExiste) {
                creerAlerte(
                    Alerte.TypeAlerte.DEPASSEMENT_BUDGET,
                    budget.getServiceId(),
                    String.format("Le budget du service a été dépassé. " +
                                "Taux d'utilisation: %.1f%%. Écart: %.2f€",
                                budget.getTauxUtilisation(),
                                budget.getEcart()),
                    Alerte.NiveauAlerte.CRITIQUE
                );
            }
        } else if (budget.getStatut() == BudgetService.StatutBudget.ALERTE) {
            if (!alerteExiste) {
                creerAlerte(
                    Alerte.TypeAlerte.DEPASSEMENT_BUDGET,
                    budget.getServiceId(),
                    String.format("Le budget du service approche de la limite. " +
                                "Taux d'utilisation: %.1f%%",
                                budget.getTauxUtilisation()),
                    Alerte.NiveauAlerte.WARNING
                );
            }
        }
    }

    /**
     * Crée une nouvelle alerte
     */
    public Alerte creerAlerte(Alerte.TypeAlerte type, Long serviceId, 
                              String message, Alerte.NiveauAlerte niveau) {
        Alerte alerte = new Alerte();
        alerte.setType(type);
        alerte.setServiceId(serviceId);
        alerte.setMessage(message);
        alerte.setNiveau(niveau);
        alerte.setDateCreation(LocalDateTime.now());
        alerte.setResolue(false);
        
        return alerteRepository.save(alerte);
    }

    /**
     * Récupère toutes les alertes actives
     */
    public List<Alerte> getAlertesActives() {
        return alerteRepository.findByResolueFalseOrderByDateCreationDesc();
    }

    /**
     * Récupère les alertes d'un service
     */
    public List<Alerte> getAlertesParService(Long serviceId) {
        return alerteRepository.findByServiceIdOrderByDateCreationDesc(serviceId);
    }

    /**
     * Récupère les alertes actives d'un service
     */
    public List<Alerte> getAlertesActivesParService(Long serviceId) {
        return alerteRepository.findByServiceIdAndResolueFalseOrderByDateCreationDesc(serviceId);
    }

    /**
     * Récupère les alertes critiques
     */
    public List<Alerte> getAlertesCritiques() {
        return alerteRepository.findAlertesCritiques();
    }

    /**
     * Résout une alerte
     */
    public Alerte resoudreAlerte(Long id) {
        Alerte alerte = alerteRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Alerte non trouvée: " + id));
        
        alerte.resoudre();
        return alerteRepository.save(alerte);
    }

    /**
     * Détecte une anomalie de coût (coût anormalement élevé)
     */
    public void detecterAnomalieCout(Long serviceId, Double cout, Double moyenne) {
        if (moyenne == null || moyenne == 0) return;
        
        // Si le coût est supérieur à 2 fois la moyenne, c'est une anomalie
        if (cout > moyenne * 2) {
            creerAlerte(
                Alerte.TypeAlerte.ANOMALIE_COUT,
                serviceId,
                String.format("Coût anormalement élevé détecté: %.2f€ (moyenne: %.2f€)",
                            cout, moyenne),
                Alerte.NiveauAlerte.WARNING
            );
        }
    }

    /**
     * Détecte une variation anormale des dépenses
     */
    public void detecterVariationAnormale(Long serviceId, Double variationPourcentage) {
        if (variationPourcentage > 20) {
            creerAlerte(
                Alerte.TypeAlerte.VARIATION_ANORMALE,
                serviceId,
                String.format("Variation anormale des dépenses: +%.1f%% par rapport au mois précédent",
                            variationPourcentage),
                Alerte.NiveauAlerte.WARNING
            );
        } else if (variationPourcentage < -30) {
            creerAlerte(
                Alerte.TypeAlerte.VARIATION_ANORMALE,
                serviceId,
                String.format("Baisse importante des dépenses: %.1f%% par rapport au mois précédent",
                            variationPourcentage),
                Alerte.NiveauAlerte.INFO
            );
        }
    }
}

