package com.hospital.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * DTO pour les détails de coût d'un soin
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CoutSoinDTO {
    private Long id;
    private Long soinId;
    private Double coutPersonnel;
    private Double coutMateriel;
    private Double coutConsommables;
    private Double coutTotal;
    private LocalDateTime dateCalcul;
}

