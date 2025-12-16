package com.hospital.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

/**
 * Entité représentant une alerte financière.
 * Permet de notifier les utilisateurs des anomalies ou dépassements budgétaires.
 */
@Entity
@Table(name = "alerte", indexes = {
    @Index(name = "idx_service_resolue", columnList = "service_id,resolue"),
    @Index(name = "idx_resolue", columnList = "resolue")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Alerte {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Type d'alerte
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TypeAlerte type;

    /**
     * Service concerné (peut être null pour alertes globales)
     */
    @Column(name = "service_id")
    private Long serviceId;

    /**
     * Message de l'alerte
     */
    @Column(nullable = false, columnDefinition = "TEXT")
    private String message;

    /**
     * Niveau de criticité
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private NiveauAlerte niveau = NiveauAlerte.INFO;

    /**
     * Date de création
     */
    @Column(name = "date_creation", nullable = false)
    private LocalDateTime dateCreation = LocalDateTime.now();

    /**
     * Date de résolution (null si non résolue)
     */
    @Column(name = "date_resolution")
    private LocalDateTime dateResolution;

    /**
     * Indique si l'alerte est résolue
     */
    @Column(nullable = false)
    private Boolean resolue = false;

    /**
     * Données supplémentaires au format JSON (optionnel)
     */
    @Column(name = "donnees_supplementaires", columnDefinition = "TEXT")
    private String donneesSupplementaires;

    @PrePersist
    protected void onCreate() {
        if (dateCreation == null) {
            dateCreation = LocalDateTime.now();
        }
        if (resolue == null) {
            resolue = false;
        }
    }

    /**
     * Marque l'alerte comme résolue
     */
    public void resoudre() {
        this.resolue = true;
        this.dateResolution = LocalDateTime.now();
    }

    /**
     * Enum pour le type d'alerte
     */
    public enum TypeAlerte {
        DEPASSEMENT_BUDGET,        // Budget dépassé
        ANOMALIE_COUT,             // Coût anormalement élevé
        TENDANCE_ALARMANTE,        // Tendance à la hausse
        BUDGET_PROCHAIN_DEPASSE,   // Prévision indique dépassement
        VARIATION_ANORMALE         // Variation anormale des dépenses
    }

    /**
     * Enum pour le niveau d'alerte
     */
    public enum NiveauAlerte {
        INFO,      // Information (vert)
        WARNING,   // Attention (orange)
        CRITIQUE   // Action requise (rouge)
    }
}

