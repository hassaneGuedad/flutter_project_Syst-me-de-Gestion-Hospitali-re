package com.hospital.service;

import com.hospital.model.Service;
import com.hospital.repository.ServiceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@org.springframework.stereotype.Service
@RequiredArgsConstructor
@Transactional
public class ServiceService {

    private final ServiceRepository serviceRepository;

    public List<Service> getAllServices() {
        return serviceRepository.findAll();
    }

    public Service getServiceById(Long id) {
        return serviceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Service not found with id: " + id));
    }

    public Service createService(Service service) {
        return serviceRepository.save(service);
    }

    public Service updateService(Long id, Service serviceDetails) {
        Service service = getServiceById(id);
        service.setNom(serviceDetails.getNom());
        service.setBudgetMensuel(serviceDetails.getBudgetMensuel());
        service.setBudgetAnnuel(serviceDetails.getBudgetAnnuel());
        service.setCoutActuel(serviceDetails.getCoutActuel());
        return serviceRepository.save(service);
    }

    public void deleteService(Long id) {
        Service service = getServiceById(id);
        serviceRepository.delete(service);
    }
}
