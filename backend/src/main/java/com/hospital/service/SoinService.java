package com.hospital.service;

import com.hospital.model.Soin;
import com.hospital.repository.SoinRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class SoinService {

    private final SoinRepository soinRepository;

    public List<Soin> getAllSoins() {
        return soinRepository.findAll();
    }

    public Optional<Soin> getSoinById(Long id) {
        return soinRepository.findById(id);
    }

    public Soin createSoin(Soin soin) {
        return soinRepository.save(soin);
    }

    public List<Soin> getSoinsByPatientId(Long patientId) {
        return soinRepository.findByPatientId(patientId);
    }

    public List<Soin> getSoinsByServiceId(Long serviceId) {
        return soinRepository.findByServiceId(serviceId);
    }

    public Soin updateSoin(Long id, Soin soinDetails) {
        Soin soin = soinRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Soin not found with id: " + id));
        soin.setTypeSoin(soinDetails.getTypeSoin());
        soin.setCout(soinDetails.getCout());
        soin.setDateSoin(soinDetails.getDateSoin());
        soin.setDescription(soinDetails.getDescription());
        if (soinDetails.getPatient() != null) {
            soin.setPatient(soinDetails.getPatient());
        }
        if (soinDetails.getService() != null) {
            soin.setService(soinDetails.getService());
        }
        return soinRepository.save(soin);
    }

    public void deleteSoin(Long id) {
        Soin soin = soinRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Soin not found with id: " + id));
        soinRepository.delete(soin);
    }
}
