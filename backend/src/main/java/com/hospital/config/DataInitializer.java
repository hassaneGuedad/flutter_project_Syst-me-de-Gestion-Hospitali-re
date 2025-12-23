package com.hospital.config;

import com.hospital.model.Role;
import com.hospital.model.Utilisateur;
import com.hospital.repository.UtilisateurRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * Initialisation des données au démarrage de l'application
 * Crée l'utilisateur admin par défaut avec mot de passe
 */
@Configuration
@Slf4j
public class DataInitializer {

    @Bean
    public CommandLineRunner initData(UtilisateurRepository utilisateurRepository) {
        return args -> {
            // Vérifie si l'admin existe déjà
            if (utilisateurRepository.findByEmail("admin@hospital.com").isEmpty()) {
                
                BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
                
                // Crée l'utilisateur admin avec mot de passe encodé
                Utilisateur admin = new Utilisateur();
                admin.setEmail("admin@hospital.com");
                admin.setMotDePasse(encoder.encode("password")); // Mot de passe par défaut
                admin.setNom("Admin");
                admin.setPrenom("Super");
                admin.setRole(Role.ADMIN);
                admin.setPasswordVersion(1);
                
                utilisateurRepository.save(admin);
                
                log.info("═══════════════════════════════════════════════════════");
                log.info("✅ Utilisateur admin créé");
                log.info("📧 Email: admin@hospital.com");
                log.info("🔑 Mot de passe: password");
                log.info("═══════════════════════════════════════════════════════");
            } else {
                log.info("ℹ️ L'utilisateur admin existe déjà");
            }
        };
    }
}
