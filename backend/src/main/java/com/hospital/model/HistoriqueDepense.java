package com.hospital.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

/**
 * Entité représentant l'historique des dépenses par service.
 * Permet de tracer toutes les dépenses pour analyse et prévision.
 */
@Entity
@Table(name = "historique_depense", indexes = {
    @Index(name = "idx_service_date", columnList = "service_id,date"),
    @Index(name = "idx_date", columnList = "date")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class HistoriqueDepense {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "service_id", nullable = false)
    private Long serviceId;

    /**
     * Date de la dépense
     */
    @Column(nullable = false)
    private LocalDate date;

    /**
     * Montant de la dépense
     */
    @Column(nullable = false)
    private Double montant = 0.0;

    /**
     * Type de dépense
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "type_depense", nullable = false)
    private TypeDepense typeDepense;

    /**
     * Référence optionnelle au soin (pour traçabilité)
     */
    @Column(name = "soin_id")
    private Long soinId;

    /**
     * Description de la dépense
     */
    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "created_at")
    private java.time.LocalDateTime createdAt = java.time.LocalDateTime.now();

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = java.time.LocalDateTime.now();
        }
    }

    /**
     * Enum pour le type de dépense
     */
    public enum TypeDepense {
        PERSONNEL,      // Coût du personnel médical
        MATERIEL,       // Coût des équipements
        CONSOMMABLES    // Coût des médicaments et fournitures
    }
}

