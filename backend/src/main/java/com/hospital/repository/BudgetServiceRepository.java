package com.hospital.repository;

import com.hospital.model.BudgetService;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface BudgetServiceRepository extends JpaRepository<BudgetService, Long> {
    
    /**
     * Trouve le budget d'un service pour une période donnée
     */
    Optional<BudgetService> findByServiceIdAndPeriode(Long serviceId, LocalDate periode);
    
    /**
     * Trouve tous les budgets d'un service
     */
    List<BudgetService> findByServiceIdOrderByPeriodeDesc(Long serviceId);
    
    /**
     * Trouve les budgets dans une période donnée
     */
    @Query("SELECT b FROM BudgetService b WHERE b.periode BETWEEN :debut AND :fin")
    List<BudgetService> findByPeriodeBetween(
        @Param("debut") LocalDate debut,
        @Param("fin") LocalDate fin
    );
    
    /**
     * Trouve les budgets dépassés
     */
    @Query("SELECT b FROM BudgetService b WHERE b.statut = 'DEPASSE'")
    List<BudgetService> findBudgetsDepasses();
    
    /**
     * Trouve les budgets en alerte
     */
    @Query("SELECT b FROM BudgetService b WHERE b.statut = 'ALERTE' OR b.statut = 'DEPASSE'")
    List<BudgetService> findBudgetsEnAlerte();
    
    /**
     * Trouve le dernier budget d'un service
     */
    Optional<BudgetService> findFirstByServiceIdOrderByPeriodeDesc(Long serviceId);
}

