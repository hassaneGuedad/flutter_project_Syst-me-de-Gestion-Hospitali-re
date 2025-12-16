package com.hospital.controller;

import com.hospital.dto.BudgetServiceDTO;
import com.hospital.dto.CoutSoinDTO;
import com.hospital.model.*;
import com.hospital.service.FinanceService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Contrôleur REST pour la gestion financière
 */
@RestController
@RequestMapping("/api/finance")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class FinanceController {

    private final FinanceService financeService;

    /**
     * Calcule le coût détaillé d'un soin
     */
    @PostMapping("/cout-soin")
    public ResponseEntity<CoutSoinDTO> calculerCoutSoin(
            @RequestParam Long soinId,
            @RequestParam(required = false) Double coutPersonnel,
            @RequestParam(required = false) Double coutMateriel,
            @RequestParam(required = false) Double coutConsommables) {
        
        CoutSoin coutSoin = financeService.calculerCoutSoin(
            soinId, coutPersonnel, coutMateriel, coutConsommables);
        
        return ResponseEntity.ok(toDTO(coutSoin));
    }

    /**
     * Calcule automatiquement le coût d'un soin
     */
    @PostMapping("/cout-soin/auto/{soinId}")
    public ResponseEntity<CoutSoinDTO> calculerCoutSoinAutomatique(@PathVariable Long soinId) {
        CoutSoin coutSoin = financeService.calculerCoutSoinAutomatique(soinId);
        return ResponseEntity.ok(toDTO(coutSoin));
    }

    /**
     * Récupère les détails de coût d'un soin
     */
    @GetMapping("/cout-soin/{soinId}")
    public ResponseEntity<CoutSoinDTO> getCoutSoin(@PathVariable Long soinId) {
        return financeService.getCoutSoin(soinId)
            .map(cs -> ResponseEntity.ok(toDTO(cs)))
            .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Récupère le budget d'un service pour une période
     */
    @GetMapping("/budget-service/{serviceId}")
    public ResponseEntity<BudgetServiceDTO> getBudgetService(
            @PathVariable Long serviceId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate periode) {
        
        if (periode == null) {
            periode = LocalDate.now().withDayOfMonth(1);
        }
        
        return financeService.getBudgetService(serviceId, periode)
            .map(b -> ResponseEntity.ok(toDTO(b)))
            .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Récupère l'historique des dépenses d'un service
     */
    @GetMapping("/historique/{serviceId}")
    public ResponseEntity<List<HistoriqueDepense>> getHistoriqueDepenses(
            @PathVariable Long serviceId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate debut,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fin) {
        
        if (debut == null) {
            debut = LocalDate.now().minusMonths(6);
        }
        if (fin == null) {
            fin = LocalDate.now();
        }
        
        List<HistoriqueDepense> historique = financeService.getHistoriqueDepenses(serviceId, debut, fin);
        return ResponseEntity.ok(historique);
    }

    /**
     * Récupère les budgets dépassés
     */
    @GetMapping("/budgets-depasses")
    public ResponseEntity<List<BudgetServiceDTO>> getBudgetsDepasses() {
        List<BudgetServiceDTO> budgets = financeService.getBudgetsDepasses().stream()
            .map(this::toDTO)
            .collect(Collectors.toList());
        return ResponseEntity.ok(budgets);
    }

    /**
     * Récupère les budgets en alerte
     */
    @GetMapping("/budgets-alerte")
    public ResponseEntity<List<BudgetServiceDTO>> getBudgetsEnAlerte() {
        List<BudgetServiceDTO> budgets = financeService.getBudgetsEnAlerte().stream()
            .map(this::toDTO)
            .collect(Collectors.toList());
        return ResponseEntity.ok(budgets);
    }

    /**
     * Recalcule tous les budgets du mois en cours
     */
    @PostMapping("/recalculer-budgets")
    public ResponseEntity<String> recalculerBudgets() {
        financeService.recalculerBudgetsMoisCourant();
        return ResponseEntity.ok("Budgets recalculés avec succès");
    }

    // Méthodes de conversion DTO
    private CoutSoinDTO toDTO(CoutSoin coutSoin) {
        return new CoutSoinDTO(
            coutSoin.getId(),
            coutSoin.getSoinId(),
            coutSoin.getCoutPersonnel(),
            coutSoin.getCoutMateriel(),
            coutSoin.getCoutConsommables(),
            coutSoin.getCoutTotal(),
            coutSoin.getDateCalcul()
        );
    }

    private BudgetServiceDTO toDTO(BudgetService budget) {
        return new BudgetServiceDTO(
            budget.getId(),
            budget.getServiceId(),
            budget.getPeriode(),
            budget.getBudgetPrevu(),
            budget.getBudgetReel(),
            budget.getEcart(),
            budget.getTauxUtilisation(),
            budget.getStatut().toString()
        );
    }
}

