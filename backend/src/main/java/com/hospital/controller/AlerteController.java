package com.hospital.controller;

import com.hospital.model.Alerte;
import com.hospital.service.AlerteService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Contrôleur REST pour la gestion des alertes
 */
@RestController
@RequestMapping("/api/alertes")
@RequiredArgsConstructor
public class AlerteController {

    private final AlerteService alerteService;

    /**
     * Récupère toutes les alertes actives
     */
    @GetMapping
    public ResponseEntity<List<Alerte>> getAlertesActives() {
        return ResponseEntity.ok(alerteService.getAlertesActives());
    }

    /**
     * Récupère les alertes d'un service
     */
    @GetMapping("/service/{serviceId}")
    public ResponseEntity<List<Alerte>> getAlertesParService(@PathVariable Long serviceId) {
        return ResponseEntity.ok(alerteService.getAlertesParService(serviceId));
    }

    /**
     * Récupère les alertes actives d'un service
     */
    @GetMapping("/service/{serviceId}/actives")
    public ResponseEntity<List<Alerte>> getAlertesActivesParService(@PathVariable Long serviceId) {
        return ResponseEntity.ok(alerteService.getAlertesActivesParService(serviceId));
    }

    /**
     * Récupère les alertes critiques
     */
    @GetMapping("/critiques")
    public ResponseEntity<List<Alerte>> getAlertesCritiques() {
        return ResponseEntity.ok(alerteService.getAlertesCritiques());
    }

    /**
     * Résout une alerte
     */
    @PostMapping("/{id}/resoudre")
    public ResponseEntity<Alerte> resoudreAlerte(@PathVariable Long id) {
        return ResponseEntity.ok(alerteService.resoudreAlerte(id));
    }

    /**
     * Crée une alerte manuellement
     */
    @PostMapping
    public ResponseEntity<Alerte> creerAlerte(@RequestBody Map<String, Object> request) {
        Alerte.TypeAlerte type = Alerte.TypeAlerte.valueOf(
            (String) request.get("type"));
        Long serviceId = request.get("serviceId") != null 
            ? Long.valueOf(request.get("serviceId").toString()) 
            : null;
        String message = (String) request.get("message");
        Alerte.NiveauAlerte niveau = Alerte.NiveauAlerte.valueOf(
            (String) request.getOrDefault("niveau", "INFO"));
        
        Alerte alerte = alerteService.creerAlerte(type, serviceId, message, niveau);
        return ResponseEntity.ok(alerte);
    }
}

