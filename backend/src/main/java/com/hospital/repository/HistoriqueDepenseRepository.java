package com.hospital.repository;

import com.hospital.model.HistoriqueDepense;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface HistoriqueDepenseRepository extends JpaRepository<HistoriqueDepense, Long> {
    
    /**
     * Trouve les dépenses d'un service
     */
    List<HistoriqueDepense> findByServiceIdOrderByDateDesc(Long serviceId);
    
    /**
     * Trouve les dépenses d'un service dans une période
     */
    List<HistoriqueDepense> findByServiceIdAndDateBetween(
        Long serviceId,
        LocalDate debut,
        LocalDate fin
    );
    
    /**
     * Trouve les dépenses par type
     */
    List<HistoriqueDepense> findByServiceIdAndTypeDepenseOrderByDateDesc(
        Long serviceId,
        HistoriqueDepense.TypeDepense typeDepense
    );
    
    /**
     * Calcule le total des dépenses d'un service pour une période
     */
    @Query("SELECT SUM(h.montant) FROM HistoriqueDepense h " +
           "WHERE h.serviceId = :serviceId AND h.date BETWEEN :debut AND :fin")
    Double calculerTotalDepenses(
        @Param("serviceId") Long serviceId,
        @Param("debut") LocalDate debut,
        @Param("fin") LocalDate fin
    );
    
    /**
     * Calcule le total des dépenses par type pour un service
     */
    @Query("SELECT h.typeDepense, SUM(h.montant) FROM HistoriqueDepense h " +
           "WHERE h.serviceId = :serviceId AND h.date BETWEEN :debut AND :fin " +
           "GROUP BY h.typeDepense")
    List<Object[]> calculerTotalParType(
        @Param("serviceId") Long serviceId,
        @Param("debut") LocalDate debut,
        @Param("fin") LocalDate fin
    );
    
    /**
     * Trouve les dépenses récentes (derniers N jours)
     */
    @Query("SELECT h FROM HistoriqueDepense h WHERE h.date >= :dateLimite ORDER BY h.date DESC")
    List<HistoriqueDepense> findDepensesRecent(@Param("dateLimite") LocalDate dateLimite);
}

