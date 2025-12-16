package com.hospital.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * DTO pour les prévisions
 */
@Data
@NoArgsConstructor
public class PrevisionDTO {
    private Long serviceId;
    private List<PointPrevisionDTO> points;
    private String methode;
    private Double confiance;
    
    public PrevisionDTO(Long serviceId, List<PointPrevisionDTO> points, String methode, Double confiance) {
        this.serviceId = serviceId;
        this.points = points;
        this.methode = methode;
        this.confiance = confiance;
    }
}

