package com.hospital.service;

import com.hospital.model.RendezVous;
import com.hospital.repository.RendezVousRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class RendezVousService {

    private final RendezVousRepository rendezVousRepository;

    public List<RendezVous> getAllRendezVous() {
        return rendezVousRepository.findAll();
    }

    public Optional<RendezVous> getRendezVousById(Long id) {
        return rendezVousRepository.findById(id);
    }

    public List<RendezVous> getRendezVousByPatientId(Long patientId) {
        return rendezVousRepository.findByPatientId(patientId);
    }

    public List<RendezVous> getRendezVousByDate(LocalDate date) {
        LocalDateTime startOfDay = date.atStartOfDay();
        LocalDateTime endOfDay = date.atTime(LocalTime.MAX);
        return rendezVousRepository.findByDateHeureBetween(startOfDay, endOfDay);
    }

    public RendezVous createRendezVous(RendezVous rendezVous) {
        return rendezVousRepository.save(rendezVous);
    }

    public RendezVous updateRendezVous(Long id, RendezVous rendezVousDetails) {
        RendezVous rendezVous = rendezVousRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("RendezVous not found with id: " + id));
        
        rendezVous.setDateHeure(rendezVousDetails.getDateHeure());
        rendezVous.setMotif(rendezVousDetails.getMotif());
        rendezVous.setStatut(rendezVousDetails.getStatut());
        rendezVous.setNotes(rendezVousDetails.getNotes());
        if (rendezVousDetails.getPatient() != null) {
            rendezVous.setPatient(rendezVousDetails.getPatient());
        }
        
        return rendezVousRepository.save(rendezVous);
    }

    public RendezVous updateStatut(Long id, String statut) {
        RendezVous rendezVous = rendezVousRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("RendezVous not found with id: " + id));
        rendezVous.setStatut(statut);
        return rendezVousRepository.save(rendezVous);
    }

    public void deleteRendezVous(Long id) {
        RendezVous rendezVous = rendezVousRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("RendezVous not found with id: " + id));
        rendezVousRepository.delete(rendezVous);
    }
}
