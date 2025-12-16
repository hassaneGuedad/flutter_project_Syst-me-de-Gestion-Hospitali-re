package com.hospital.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

/**
 * Entité représentant le détail des coûts d'un soin médical.
 * Permet de décomposer le coût total en : personnel, matériel et consommables.
 */
@Entity
@Table(name = "cout_soin")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CoutSoin {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "soin_id", nullable = false)
    private Long soinId;

    /**
     * Coût du personnel médical (médecins, infirmiers, etc.)
     */
    @Column(name = "cout_personnel", nullable = false)
    private Double coutPersonnel = 0.0;

    /**
     * Coût des équipements et matériels médicaux utilisés
     */
    @Column(name = "cout_materiel", nullable = false)
    private Double coutMateriel = 0.0;

    /**
     * Coût des consommables (médicaments, fournitures, etc.)
     */
    @Column(name = "cout_consommables", nullable = false)
    private Double coutConsommables = 0.0;

    /**
     * Coût total = personnel + matériel + consommables
     */
    @Column(name = "cout_total", nullable = false)
    private Double coutTotal = 0.0;

    @Column(name = "date_calcul", nullable = false)
    private LocalDateTime dateCalcul = LocalDateTime.now();

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @PrePersist
    protected void onCreate() {
        if (dateCalcul == null) {
            dateCalcul = LocalDateTime.now();
        }
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        // Calcul automatique du coût total
        if (coutTotal == null || coutTotal == 0.0) {
            coutTotal = (coutPersonnel != null ? coutPersonnel : 0.0) +
                       (coutMateriel != null ? coutMateriel : 0.0) +
                       (coutConsommables != null ? coutConsommables : 0.0);
        }
    }

    @PreUpdate
    protected void onUpdate() {
        // Recalculer le coût total à chaque mise à jour
        coutTotal = (coutPersonnel != null ? coutPersonnel : 0.0) +
                   (coutMateriel != null ? coutMateriel : 0.0) +
                   (coutConsommables != null ? coutConsommables : 0.0);
    }
}

