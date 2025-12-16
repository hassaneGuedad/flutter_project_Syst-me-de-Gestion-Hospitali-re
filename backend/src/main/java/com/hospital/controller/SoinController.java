package com.hospital.controller;

import com.hospital.model.Soin;
import com.hospital.service.SoinService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/soins")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class SoinController {

    private final SoinService soinService;

    @GetMapping
    public ResponseEntity<List<Soin>> getAllSoins() {
        return ResponseEntity.ok(soinService.getAllSoins());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Soin> getSoinById(@PathVariable Long id) {
        return soinService.getSoinById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Soin> createSoin(@RequestBody Soin soin) {
        return ResponseEntity.ok(soinService.createSoin(soin));
    }

    @GetMapping("/patient/{patientId}")
    public ResponseEntity<List<Soin>> getSoinsByPatient(@PathVariable Long patientId) {
        return ResponseEntity.ok(soinService.getSoinsByPatientId(patientId));
    }

    @GetMapping("/service/{serviceId}")
    public ResponseEntity<List<Soin>> getSoinsByService(@PathVariable Long serviceId) {
        return ResponseEntity.ok(soinService.getSoinsByServiceId(serviceId));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Soin> updateSoin(@PathVariable Long id, @RequestBody Soin soin) {
        return ResponseEntity.ok(soinService.updateSoin(id, soin));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSoin(@PathVariable Long id) {
        soinService.deleteSoin(id);
        return ResponseEntity.noContent().build();
    }
}
