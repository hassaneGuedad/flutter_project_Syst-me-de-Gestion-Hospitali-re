package com.hospital.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

/**
 * DTO pour un point de prévision (date + montant prévu/réel)
 */
@Data
@NoArgsConstructor
public class PointPrevisionDTO {
    private LocalDate date;
    private Double montantPrevu;
    private Double montantReel;
    
    public PointPrevisionDTO(LocalDate date, Double montantPrevu, Double montantReel) {
        this.date = date;
        this.montantPrevu = montantPrevu;
        this.montantReel = montantReel;
    }
}

