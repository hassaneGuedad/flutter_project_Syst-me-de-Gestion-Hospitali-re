package com.hospital.service;

import com.hospital.model.*;
import com.hospital.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.List;
import java.util.Optional;

/**
 * Service métier pour la gestion financière.
 * Gère le calcul des coûts, le suivi des budgets et la génération de rapports.
 */
@Service
@RequiredArgsConstructor
@Transactional
public class FinanceService {

    private final CoutSoinRepository coutSoinRepository;
    private final BudgetServiceRepository budgetServiceRepository;
    private final HistoriqueDepenseRepository historiqueDepenseRepository;
    private final SoinRepository soinRepository;
    private final ServiceRepository serviceRepository;
    private final AlerteService alerteService;

    /**
     * Calcule le coût détaillé d'un soin.
     * Si le soin existe déjà, met à jour le coût.
     * 
     * @param soinId ID du soin
     * @param coutPersonnel Coût du personnel
     * @param coutMateriel Coût du matériel
     * @param coutConsommables Coût des consommables
     * @return Le coût calculé
     */
    public CoutSoin calculerCoutSoin(Long soinId, Double coutPersonnel, 
                                     Double coutMateriel, Double coutConsommables) {
        Optional<CoutSoin> existing = coutSoinRepository.findBySoinId(soinId);
        
        CoutSoin coutSoin;
        if (existing.isPresent()) {
            coutSoin = existing.get();
            coutSoin.setCoutPersonnel(coutPersonnel != null ? coutPersonnel : 0.0);
            coutSoin.setCoutMateriel(coutMateriel != null ? coutMateriel : 0.0);
            coutSoin.setCoutConsommables(coutConsommables != null ? coutConsommables : 0.0);
            coutSoin.setDateCalcul(LocalDateTime.now());
        } else {
            coutSoin = new CoutSoin();
            coutSoin.setSoinId(soinId);
            coutSoin.setCoutPersonnel(coutPersonnel != null ? coutPersonnel : 0.0);
            coutSoin.setCoutMateriel(coutMateriel != null ? coutMateriel : 0.0);
            coutSoin.setCoutConsommables(coutConsommables != null ? coutConsommables : 0.0);
            coutSoin.setDateCalcul(LocalDateTime.now());
        }
        
        // Le coût total est calculé automatiquement par @PrePersist/@PreUpdate
        coutSoin = coutSoinRepository.save(coutSoin);
        
        // Mettre à jour l'historique des dépenses
        mettreAJourHistoriqueDepenses(soinId, coutSoin);
        
        // Mettre à jour le budget du service
        Optional<Soin> soin = soinRepository.findById(soinId);
        if (soin.isPresent()) {
            mettreAJourBudgetService(soin.get().getServiceId(), coutSoin.getCoutTotal());
        }
        
        return coutSoin;
    }

    /**
     * Calcule automatiquement le coût d'un soin basé sur des règles métier.
     * Cette méthode peut être étendue avec des règles plus complexes.
     */
    public CoutSoin calculerCoutSoinAutomatique(Long soinId) {
        Optional<Soin> soinOpt = soinRepository.findById(soinId);
        if (soinOpt.isEmpty()) {
            throw new RuntimeException("Soin non trouvé: " + soinId);
        }
        
        Soin soin = soinOpt.get();
        
        // Règles simplifiées (à adapter selon les besoins réels)
        // Exemple : coût personnel = 60% du coût total, matériel = 25%, consommables = 15%
        double coutTotal = soin.getCout() != null ? soin.getCout() : 0.0;
        double coutPersonnel = coutTotal * 0.60;
        double coutMateriel = coutTotal * 0.25;
        double coutConsommables = coutTotal * 0.15;
        
        return calculerCoutSoin(soinId, coutPersonnel, coutMateriel, coutConsommables);
    }

    /**
     * Met à jour l'historique des dépenses pour un soin
     */
    private void mettreAJourHistoriqueDepenses(Long soinId, CoutSoin coutSoin) {
        Optional<Soin> soinOpt = soinRepository.findById(soinId);
        if (soinOpt.isEmpty()) return;
        
        Soin soin = soinOpt.get();
        LocalDate date = soin.getDateSoin() != null 
            ? soin.getDateSoin().toLocalDate() 
            : LocalDate.now();
        
        // Créer des entrées pour chaque type de dépense
        if (coutSoin.getCoutPersonnel() > 0) {
            HistoriqueDepense depense = new HistoriqueDepense();
            depense.setServiceId(soin.getServiceId());
            depense.setDate(date);
            depense.setMontant(coutSoin.getCoutPersonnel());
            depense.setTypeDepense(HistoriqueDepense.TypeDepense.PERSONNEL);
            depense.setSoinId(soinId);
            depense.setDescription("Coût personnel pour soin #" + soinId);
            historiqueDepenseRepository.save(depense);
        }
        
        if (coutSoin.getCoutMateriel() > 0) {
            HistoriqueDepense depense = new HistoriqueDepense();
            depense.setServiceId(soin.getServiceId());
            depense.setDate(date);
            depense.setMontant(coutSoin.getCoutMateriel());
            depense.setTypeDepense(HistoriqueDepense.TypeDepense.MATERIEL);
            depense.setSoinId(soinId);
            depense.setDescription("Coût matériel pour soin #" + soinId);
            historiqueDepenseRepository.save(depense);
        }
        
        if (coutSoin.getCoutConsommables() > 0) {
            HistoriqueDepense depense = new HistoriqueDepense();
            depense.setServiceId(soin.getServiceId());
            depense.setDate(date);
            depense.setMontant(coutSoin.getCoutConsommables());
            depense.setTypeDepense(HistoriqueDepense.TypeDepense.CONSOMMABLES);
            depense.setSoinId(soinId);
            depense.setDescription("Coût consommables pour soin #" + soinId);
            historiqueDepenseRepository.save(depense);
        }
    }

    /**
     * Met à jour le budget réel d'un service pour le mois en cours
     */
    public void mettreAJourBudgetService(Long serviceId, Double montant) {
        LocalDate periode = LocalDate.now().withDayOfMonth(1); // Premier jour du mois
        
        Optional<BudgetService> budgetOpt = budgetServiceRepository
            .findByServiceIdAndPeriode(serviceId, periode);
        
        BudgetService budget;
        if (budgetOpt.isPresent()) {
            budget = budgetOpt.get();
            budget.setBudgetReel(budget.getBudgetReel() + montant);
        } else {
            budget = new BudgetService();
            budget.setServiceId(serviceId);
            budget.setPeriode(periode);
            budget.setBudgetReel(montant);
            
            // Récupérer le budget prévu du service
            Optional<com.hospital.model.Service> serviceOpt = serviceRepository.findById(serviceId);
            if (serviceOpt.isPresent()) {
                budget.setBudgetPrevu(serviceOpt.get().getBudgetMensuel());
            } else {
                budget.setBudgetPrevu(0.0);
            }
        }
        
        budget = budgetServiceRepository.save(budget);
        
        // Vérifier les dépassements et créer des alertes si nécessaire
        alerteService.verifierDepassementBudget(budget);
    }

    /**
     * Calcule le budget réel d'un service pour une période donnée
     */
    public Double calculerBudgetReel(Long serviceId, LocalDate debut, LocalDate fin) {
        Double total = historiqueDepenseRepository.calculerTotalDepenses(serviceId, debut, fin);
        return total != null ? total : 0.0;
    }

    /**
     * Récupère le coût détaillé d'un soin
     */
    public Optional<CoutSoin> getCoutSoin(Long soinId) {
        return coutSoinRepository.findBySoinId(soinId);
    }

    /**
     * Récupère le budget d'un service pour une période
     */
    public Optional<BudgetService> getBudgetService(Long serviceId, LocalDate periode) {
        return budgetServiceRepository.findByServiceIdAndPeriode(serviceId, periode);
    }

    /**
     * Récupère l'historique des dépenses d'un service
     */
    public List<HistoriqueDepense> getHistoriqueDepenses(Long serviceId, 
                                                         LocalDate debut, 
                                                         LocalDate fin) {
        return historiqueDepenseRepository.findByServiceIdAndDateBetween(serviceId, debut, fin);
    }

    /**
     * Récupère les budgets dépassés
     */
    public List<BudgetService> getBudgetsDepasses() {
        return budgetServiceRepository.findBudgetsDepasses();
    }

    /**
     * Récupère les budgets en alerte
     */
    public List<BudgetService> getBudgetsEnAlerte() {
        return budgetServiceRepository.findBudgetsEnAlerte();
    }

    /**
     * Recalcule tous les budgets pour le mois en cours
     */
    public void recalculerBudgetsMoisCourant() {
        LocalDate debut = LocalDate.now().withDayOfMonth(1);
        LocalDate fin = LocalDate.now();
        
        List<com.hospital.model.Service> services = serviceRepository.findAll();
        for (com.hospital.model.Service service : services) {
            Double budgetReel = calculerBudgetReel(service.getId(), debut, fin);
            mettreAJourBudgetService(service.getId(), 0.0); // Force la mise à jour
            
            Optional<BudgetService> budgetOpt = budgetServiceRepository
                .findByServiceIdAndPeriode(service.getId(), debut);
            if (budgetOpt.isPresent()) {
                BudgetService budget = budgetOpt.get();
                budget.setBudgetReel(budgetReel);
                budgetServiceRepository.save(budget);
                alerteService.verifierDepassementBudget(budget);
            }
        }
    }
}

