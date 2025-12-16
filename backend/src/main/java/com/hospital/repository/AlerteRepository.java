package com.hospital.repository;

import com.hospital.model.Alerte;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AlerteRepository extends JpaRepository<Alerte, Long> {
    
    /**
     * Trouve les alertes actives (non résolues)
     */
    List<Alerte> findByResolueFalseOrderByDateCreationDesc();
    
    /**
     * Trouve les alertes d'un service
     */
    List<Alerte> findByServiceIdOrderByDateCreationDesc(Long serviceId);
    
    /**
     * Trouve les alertes actives d'un service
     */
    List<Alerte> findByServiceIdAndResolueFalseOrderByDateCreationDesc(Long serviceId);
    
    /**
     * Trouve les alertes par type
     */
    List<Alerte> findByTypeAndResolueFalseOrderByDateCreationDesc(Alerte.TypeAlerte type);
    
    /**
     * Trouve les alertes par niveau
     */
    List<Alerte> findByNiveauAndResolueFalseOrderByDateCreationDesc(Alerte.NiveauAlerte niveau);
    
    /**
     * Trouve les alertes critiques actives
     */
    @Query("SELECT a FROM Alerte a WHERE a.niveau = 'CRITIQUE' AND a.resolue = false " +
           "ORDER BY a.dateCreation DESC")
    List<Alerte> findAlertesCritiques();
    
    /**
     * Compte les alertes actives par type
     */
    @Query("SELECT a.type, COUNT(a) FROM Alerte a WHERE a.resolue = false GROUP BY a.type")
    List<Object[]> compterAlertesParType();
    
    /**
     * Trouve les alertes créées après une date
     */
    List<Alerte> findByDateCreationAfterOrderByDateCreationDesc(LocalDateTime date);
}

