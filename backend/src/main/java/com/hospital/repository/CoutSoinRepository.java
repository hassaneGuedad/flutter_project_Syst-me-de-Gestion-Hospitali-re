package com.hospital.repository;

import com.hospital.model.CoutSoin;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface CoutSoinRepository extends JpaRepository<CoutSoin, Long> {
    
    /**
     * Trouve le coût détaillé d'un soin
     */
    Optional<CoutSoin> findBySoinId(Long soinId);
    
    /**
     * Trouve tous les coûts d'un service (via les soins)
     */
    @Query("SELECT cs FROM CoutSoin cs WHERE cs.soinId IN " +
           "(SELECT s.id FROM Soin s WHERE s.serviceId = :serviceId)")
    List<CoutSoin> findByServiceId(@Param("serviceId") Long serviceId);
    
    /**
     * Trouve les coûts dans une période donnée
     */
    @Query("SELECT cs FROM CoutSoin cs WHERE cs.dateCalcul BETWEEN :debut AND :fin")
    List<CoutSoin> findByDateCalculBetween(
        @Param("debut") LocalDateTime debut,
        @Param("fin") LocalDateTime fin
    );
    
    /**
     * Calcule le coût total d'un service pour une période
     */
    @Query("SELECT SUM(cs.coutTotal) FROM CoutSoin cs WHERE cs.soinId IN " +
           "(SELECT s.id FROM Soin s WHERE s.serviceId = :serviceId " +
           "AND s.dateSoin BETWEEN :debut AND :fin)")
    Double calculerCoutTotalService(
        @Param("serviceId") Long serviceId,
        @Param("debut") LocalDateTime debut,
        @Param("fin") LocalDateTime fin
    );
}

