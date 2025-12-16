package com.hospital.service;

import com.hospital.dto.ChangePasswordRequest;
import com.hospital.dto.LoginRequest;
import com.hospital.dto.LoginResponse;
import com.hospital.model.Utilisateur;
import com.hospital.repository.UtilisateurRepository;
import com.hospital.security.JwtService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

/**
 * Service d'authentification sécurisé
 * - Mots de passe hachés avec BCrypt
 * - Tokens JWT avec version de mot de passe
 * - Invalidation automatique des tokens après changement de mot de passe
 * - Configuration initiale du mot de passe au premier login
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {

    private final UtilisateurRepository utilisateurRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    /**
     * Authentification de l'utilisateur
     * @return LoginResponse si succès, null si échec
     * @throws AuthenticationException si les identifiants sont incorrects
     * @throws PasswordNotConfiguredException si le mot de passe n'est pas configuré
     */
    @Transactional(readOnly = true)
    public LoginResponse login(LoginRequest request) {
        log.info("Tentative de connexion pour: {}", request.getEmail());
        
        // Recherche de l'utilisateur par email
        Optional<Utilisateur> optUser = utilisateurRepository.findByEmail(request.getEmail());
        
        if (optUser.isEmpty()) {
            log.warn("Utilisateur non trouvé: {}", request.getEmail());
            throw new AuthenticationException("Identifiants incorrects");
        }
        
        Utilisateur user = optUser.get();
        
        // Vérification si le mot de passe doit être configuré
        if (user.getMotDePasse() == null || user.getPasswordVersion() == 0) {
            log.info("Premier login - mot de passe à configurer pour: {}", request.getEmail());
            throw new PasswordNotConfiguredException("Veuillez configurer votre mot de passe");
        }
        
        // Vérification du mot de passe avec BCrypt
        if (!passwordEncoder.matches(request.getPassword(), user.getMotDePasse())) {
            log.warn("Mot de passe incorrect pour: {}", request.getEmail());
            throw new AuthenticationException("Identifiants incorrects");
        }
        
        // Génération du token JWT avec la version du mot de passe
        String token = jwtService.generateToken(
            user.getEmail(), 
            user.getRole().name(),
            user.getPasswordVersion()
        );
        
        log.info("Connexion réussie pour: {}", request.getEmail());
        
        return LoginResponse.builder()
                .token(token)
                .email(user.getEmail())
                .nom(user.getNom())
                .prenom(user.getPrenom())
                .role(user.getRole().name())
                .expiresIn(jwtService.getExpirationTime())
                .build();
    }

    /**
     * Configuration initiale du mot de passe (premier login)
     */
    @Transactional
    public LoginResponse setupPassword(String email, String newPassword) {
        log.info("Configuration initiale du mot de passe pour: {}", email);
        
        Utilisateur user = utilisateurRepository.findByEmail(email)
                .orElseThrow(() -> new AuthenticationException("Utilisateur non trouvé"));
        
        // Vérification que le mot de passe n'est pas déjà configuré
        if (user.getMotDePasse() != null && user.getPasswordVersion() > 0) {
            throw new AuthenticationException("Le mot de passe est déjà configuré. Utilisez la fonction de changement de mot de passe.");
        }
        
        // Validation du mot de passe (minimum 6 caractères)
        if (newPassword == null || newPassword.length() < 6) {
            throw new AuthenticationException("Le mot de passe doit contenir au moins 6 caractères");
        }
        
        // Hachage et sauvegarde du mot de passe
        String hashedPassword = passwordEncoder.encode(newPassword);
        user.setMotDePasse(hashedPassword);
        user.setPasswordVersion(1);
        
        utilisateurRepository.save(user);
        log.info("Mot de passe configuré avec succès pour: {}", email);
        
        // Génération du token JWT
        String token = jwtService.generateToken(
            user.getEmail(), 
            user.getRole().name(),
            user.getPasswordVersion()
        );
        
        return LoginResponse.builder()
                .token(token)
                .email(user.getEmail())
                .nom(user.getNom())
                .prenom(user.getPrenom())
                .role(user.getRole().name())
                .expiresIn(jwtService.getExpirationTime())
                .build();
    }

    /**
     * Changement de mot de passe
     * Invalide automatiquement tous les anciens tokens
     */
    @Transactional
    public void changePassword(String email, ChangePasswordRequest request) {
        log.info("Changement de mot de passe pour: {}", email);
        
        Utilisateur user = utilisateurRepository.findByEmail(email)
                .orElseThrow(() -> new AuthenticationException("Utilisateur non trouvé"));
        
        // Vérification de l'ancien mot de passe
        if (!passwordEncoder.matches(request.getCurrentPassword(), user.getMotDePasse())) {
            log.warn("Ancien mot de passe incorrect pour: {}", email);
            throw new AuthenticationException("Mot de passe actuel incorrect");
        }
        
        // Hachage du nouveau mot de passe
        String hashedPassword = passwordEncoder.encode(request.getNewPassword());
        user.setMotDePasse(hashedPassword);
        
        // Incrémentation de la version du mot de passe
        // Cela invalide automatiquement tous les anciens tokens
        user.incrementPasswordVersion();
        
        utilisateurRepository.save(user);
        log.info("Mot de passe changé avec succès pour: {}", email);
    }

    /**
     * Vérifie si un token est valide pour un utilisateur
     */
    public boolean validateToken(String token, String email) {
        Optional<Utilisateur> optUser = utilisateurRepository.findByEmail(email);
        if (optUser.isEmpty()) {
            return false;
        }
        
        Utilisateur user = optUser.get();
        return jwtService.isTokenValid(token, email, user.getPasswordVersion());
    }

    /**
     * Vérifie si le mot de passe doit être configuré pour un utilisateur
     */
    public boolean needsPasswordSetup(String email) {
        Optional<Utilisateur> optUser = utilisateurRepository.findByEmail(email);
        if (optUser.isEmpty()) {
            return false;
        }
        Utilisateur user = optUser.get();
        return user.getMotDePasse() == null || user.getPasswordVersion() == 0;
    }

    /**
     * Exception personnalisée pour l'authentification
     */
    public static class AuthenticationException extends RuntimeException {
        public AuthenticationException(String message) {
            super(message);
        }
    }

    /**
     * Exception pour mot de passe non configuré
     */
    public static class PasswordNotConfiguredException extends RuntimeException {
        public PasswordNotConfiguredException(String message) {
            super(message);
        }
    }
}
