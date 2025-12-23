package com.hospital.controller;

import com.hospital.model.RendezVous;
import com.hospital.service.RendezVousService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/rendez-vous")
@RequiredArgsConstructor

public class RendezVousController {

    private final RendezVousService rendezVousService;

    @GetMapping
    public ResponseEntity<List<RendezVous>> getAllRendezVous() {
        return ResponseEntity.ok(rendezVousService.getAllRendezVous());
    }

    @GetMapping("/{id}")
    public ResponseEntity<RendezVous> getRendezVousById(@PathVariable Long id) {
        return rendezVousService.getRendezVousById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/patient/{patientId}")
    public ResponseEntity<List<RendezVous>> getRendezVousByPatient(@PathVariable Long patientId) {
        return ResponseEntity.ok(rendezVousService.getRendezVousByPatientId(patientId));
    }

    @GetMapping("/date/{date}")
    public ResponseEntity<List<RendezVous>> getRendezVousByDate(
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        return ResponseEntity.ok(rendezVousService.getRendezVousByDate(date));
    }

    @PostMapping
    public ResponseEntity<RendezVous> createRendezVous(@RequestBody RendezVous rendezVous) {
        return ResponseEntity.ok(rendezVousService.createRendezVous(rendezVous));
    }

    @PutMapping("/{id}")
    public ResponseEntity<RendezVous> updateRendezVous(
            @PathVariable Long id,
            @RequestBody RendezVous rendezVous) {
        return ResponseEntity.ok(rendezVousService.updateRendezVous(id, rendezVous));
    }

    @PatchMapping("/{id}/statut")
    public ResponseEntity<RendezVous> updateStatut(
            @PathVariable Long id,
            @RequestBody Map<String, String> body) {
        String statut = body.get("statut");
        return ResponseEntity.ok(rendezVousService.updateStatut(id, statut));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteRendezVous(@PathVariable Long id) {
        rendezVousService.deleteRendezVous(id);
        return ResponseEntity.noContent().build();
    }
}
