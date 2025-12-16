package com.hospital.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

/**
 * Entité représentant le budget prévisionnel et réel d'un service pour une période donnée.
 * Permet de suivre l'écart entre le budget prévu et les dépenses réelles.
 */
@Entity
@Table(name = "budget_service", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"service_id", "periode"})
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class BudgetService {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "service_id", nullable = false)
    private Long serviceId;

    /**
     * Période du budget (premier jour du mois)
     */
    @Column(nullable = false)
    private LocalDate periode;

    /**
     * Budget prévu pour cette période
     */
    @Column(name = "budget_prevu", nullable = false)
    private Double budgetPrevu = 0.0;

    /**
     * Budget réel (calculé à partir des dépenses)
     */
    @Column(name = "budget_reel", nullable = false)
    private Double budgetReel = 0.0;

    /**
     * Écart = budget réel - budget prévu
     */
    @Column(nullable = false)
    private Double ecart = 0.0;

    /**
     * Pourcentage d'utilisation = (budget réel / budget prévu) * 100
     */
    @Column(name = "taux_utilisation")
    private Double tauxUtilisation = 0.0;

    /**
     * Statut du budget
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatutBudget statut = StatutBudget.DANS_BUDGET;

    @Column(name = "created_at")
    private java.time.LocalDateTime createdAt = java.time.LocalDateTime.now();

    @Column(name = "updated_at")
    private java.time.LocalDateTime updatedAt = java.time.LocalDateTime.now();

    @PrePersist
    protected void onCreate() {
        createdAt = java.time.LocalDateTime.now();
        updatedAt = java.time.LocalDateTime.now();
        calculerEcart();
        calculerTauxUtilisation();
        determinerStatut();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = java.time.LocalDateTime.now();
        calculerEcart();
        calculerTauxUtilisation();
        determinerStatut();
    }

    /**
     * Calcule l'écart entre budget réel et prévu
     */
    private void calculerEcart() {
        if (budgetPrevu != null && budgetReel != null) {
            ecart = budgetReel - budgetPrevu;
        }
    }

    /**
     * Calcule le taux d'utilisation du budget
     */
    private void calculerTauxUtilisation() {
        if (budgetPrevu != null && budgetPrevu > 0 && budgetReel != null) {
            tauxUtilisation = (budgetReel / budgetPrevu) * 100;
        }
    }

    /**
     * Détermine le statut du budget selon le taux d'utilisation
     */
    private void determinerStatut() {
        if (tauxUtilisation == null || budgetPrevu == null || budgetPrevu == 0) {
            statut = StatutBudget.DANS_BUDGET;
            return;
        }

        if (tauxUtilisation > 110) {
            statut = StatutBudget.DEPASSE;
        } else if (tauxUtilisation > 90) {
            statut = StatutBudget.ALERTE;
        } else {
            statut = StatutBudget.DANS_BUDGET;
        }
    }

    /**
     * Enum pour le statut du budget
     */
    public enum StatutBudget {
        DANS_BUDGET,  // < 90% d'utilisation
        ALERTE,       // 90-110% d'utilisation
        DEPASSE       // > 110% d'utilisation
    }
}

