package com.hospital.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

/**
 * Entité Utilisateur avec support pour l'authentification sécurisée
 * - Mot de passe haché avec BCrypt
 * - Version du mot de passe pour invalider les tokens après changement
 */
@Entity
@Table(name = "utilisateur")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Utilisateur {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String email;
    
    @Column(name = "mot_de_passe", nullable = false)
    private String motDePasse; // Stocké haché avec BCrypt
    
    @Column(length = 100)
    private String nom;
    
    @Column(length = 100)
    private String prenom;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private Role role;
    
    /**
     * Version du mot de passe - incrémentée à chaque changement
     * Permet d'invalider tous les tokens existants après un changement de mot de passe
     */
    @Column(name = "password_version", nullable = false)
    private Integer passwordVersion = 1;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (passwordVersion == null) {
            passwordVersion = 1;
        }
    }
    
    /**
     * Incrémente la version du mot de passe
     * Appelé après chaque changement de mot de passe pour invalider les anciens tokens
     */
    public void incrementPasswordVersion() {
        this.passwordVersion = (this.passwordVersion == null ? 1 : this.passwordVersion) + 1;
    }
}
