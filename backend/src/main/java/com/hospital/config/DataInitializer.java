package com.hospital.config;

import com.hospital.model.Role;
import com.hospital.model.Utilisateur;
import com.hospital.repository.UtilisateurRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Initialisation des données au démarrage de l'application
 * Crée l'utilisateur admin par défaut SANS mot de passe (à configurer au premier lancement)
 */
@Configuration
@Slf4j
public class DataInitializer {

    @Bean
    public CommandLineRunner initData(UtilisateurRepository utilisateurRepository) {
        return args -> {
            // Vérifie si l'admin existe déjà
            if (utilisateurRepository.findByEmail("admin@hospital.com").isEmpty()) {
                
                // Crée l'utilisateur admin SANS mot de passe - doit être configuré au premier login
                Utilisateur admin = new Utilisateur();
                admin.setEmail("admin@hospital.com");
                admin.setMotDePasse(null); // Pas de mot de passe par défaut - à configurer
                admin.setNom("Admin");
                admin.setPrenom("Super");
                admin.setRole(Role.ADMIN);
                admin.setPasswordVersion(0); // Version 0 = mot de passe non configuré
                
                utilisateurRepository.save(admin);
                
                log.info("═══════════════════════════════════════════════════════");
                log.info("✅ Utilisateur admin créé");
                log.info("📧 Email: admin@hospital.com");
                log.info("⚠️ IMPORTANT: Configurez votre mot de passe au premier login");
                log.info("═══════════════════════════════════════════════════════");
            } else {
                log.info("ℹ️ L'utilisateur admin existe déjà");
            }
        };
    }
}
