package com.hospital.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

/**
 * DTO pour le budget d'un service
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class BudgetServiceDTO {
    private Long id;
    private Long serviceId;
    private LocalDate periode;
    private Double budgetPrevu;
    private Double budgetReel;
    private Double ecart;
    private Double tauxUtilisation;
    private String statut;
}

