package com.hospital.controller;

import com.hospital.dto.PrevisionDTO;
import com.hospital.dto.PointPrevisionDTO;
import com.hospital.service.PrevisionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Contrôleur REST pour les prévisions financières
 */
@RestController
@RequestMapping("/api/prevision")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class PrevisionController {

    private final PrevisionService previsionService;

    /**
     * Prévision par moyenne mobile simple
     */
    @GetMapping("/{serviceId}/moyenne-mobile")
    public ResponseEntity<PrevisionDTO> prevoirMoyenneMobile(
            @PathVariable Long serviceId,
            @RequestParam(defaultValue = "3") int nombreMois,
            @RequestParam(defaultValue = "3") int periodeMoyenne) {
        
        List<PrevisionService.PrevisionResult> previsions = 
            previsionService.prevoirDepensesMoyenneMobile(serviceId, nombreMois, periodeMoyenne);
        
        PrevisionDTO dto = toDTO(serviceId, previsions);
        return ResponseEntity.ok(dto);
    }

    /**
     * Prévision par moyenne mobile pondérée
     */
    @GetMapping("/{serviceId}/moyenne-mobile-ponderee")
    public ResponseEntity<PrevisionDTO> prevoirMoyenneMobilePonderee(
            @PathVariable Long serviceId,
            @RequestParam(defaultValue = "3") int nombreMois,
            @RequestParam(defaultValue = "3") int periodeMoyenne) {
        
        List<PrevisionService.PrevisionResult> previsions = 
            previsionService.prevoirDepensesMoyenneMobilePonderee(serviceId, nombreMois, periodeMoyenne);
        
        PrevisionDTO dto = toDTO(serviceId, previsions);
        return ResponseEntity.ok(dto);
    }

    /**
     * Prévision par tendance (régression linéaire)
     */
    @GetMapping("/{serviceId}/tendance")
    public ResponseEntity<PrevisionDTO> prevoirTendance(
            @PathVariable Long serviceId,
            @RequestParam(defaultValue = "3") int nombreMois) {
        
        List<PrevisionService.PrevisionResult> previsions = 
            previsionService.prevoirDepensesTendance(serviceId, nombreMois);
        
        PrevisionDTO dto = toDTO(serviceId, previsions);
        return ResponseEntity.ok(dto);
    }

    /**
     * Calcule la tendance actuelle des dépenses
     */
    @GetMapping("/{serviceId}/tendance-actuelle")
    public ResponseEntity<Map<String, Object>> getTendanceActuelle(@PathVariable Long serviceId) {
        PrevisionService.TendanceResult tendance = previsionService.calculerTendance(serviceId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("direction", tendance.direction);
        result.put("variationPourcentage", tendance.variationPourcentage);
        result.put("description", tendance.description);
        
        return ResponseEntity.ok(result);
    }

    /**
     * Simulation de scénario what-if
     */
    @PostMapping("/{serviceId}/simuler")
    public ResponseEntity<PrevisionDTO> simulerScenario(
            @PathVariable Long serviceId,
            @RequestBody Map<String, Double> parametres) {
        
        List<PrevisionService.PrevisionResult> previsions = 
            previsionService.simulerScenario(serviceId, parametres);
        
        PrevisionDTO dto = toDTO(serviceId, previsions);
        return ResponseEntity.ok(dto);
    }

    /**
     * Comparaison prévu vs réel
     */
    @GetMapping("/{serviceId}/comparaison")
    public ResponseEntity<Map<String, Object>> comparerPrevuReel(@PathVariable Long serviceId) {
        // Prévisions
        List<PrevisionService.PrevisionResult> previsions = 
            previsionService.prevoirDepensesMoyenneMobile(serviceId, 3, 3);
        
        // Tendance
        PrevisionService.TendanceResult tendance = previsionService.calculerTendance(serviceId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("previsions", previsions.stream()
            .map(p -> {
                Map<String, Object> point = new HashMap<>();
                point.put("date", p.date);
                point.put("montantPrevu", p.montant);
                point.put("methode", p.methode);
                return point;
            })
            .collect(Collectors.toList()));
        result.put("tendance", Map.of(
            "direction", tendance.direction,
            "variationPourcentage", tendance.variationPourcentage,
            "description", tendance.description
        ));
        
        return ResponseEntity.ok(result);
    }

    private PrevisionDTO toDTO(Long serviceId, List<PrevisionService.PrevisionResult> previsions) {
        List<PointPrevisionDTO> points = previsions.stream()
            .map(p -> new PointPrevisionDTO(p.date, p.montant, null))
            .collect(Collectors.toList());
        
        String methode = previsions.isEmpty() ? "N/A" : previsions.get(0).methode;
        double confiance = previsions.size() >= 3 ? 0.85 : (previsions.size() >= 2 ? 0.70 : 0.50);
        
        return new PrevisionDTO(serviceId, points, methode, confiance);
    }
}

