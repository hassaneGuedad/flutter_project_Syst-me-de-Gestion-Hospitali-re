package com.hospital.controller;

import com.hospital.dto.ChangePasswordRequest;
import com.hospital.dto.LoginRequest;
import com.hospital.dto.LoginResponse;
import com.hospital.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.Map;

/**
 * Contrôleur d'authentification
 * Gère la connexion, déconnexion et changement de mot de passe
 */
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Authentification", description = "API d'authentification sécurisée")
public class AuthController {

    private final AuthService authService;

    /**
     * Endpoint de connexion
     * @param request Email et mot de passe
     * @return Token JWT si succès, 401 si échec
     */
    @PostMapping("/login")
    @Operation(summary = "Connexion utilisateur", description = "Authentifie un utilisateur et retourne un token JWT")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Connexion réussie"),
        @ApiResponse(responseCode = "401", description = "Identifiants incorrects"),
        @ApiResponse(responseCode = "400", description = "Requête invalide"),
        @ApiResponse(responseCode = "428", description = "Mot de passe à configurer")
    })
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest request) {
        try {
            LoginResponse response = authService.login(request);
            return ResponseEntity.ok(response);
        } catch (AuthService.PasswordNotConfiguredException e) {
            log.info("Premier login - mot de passe à configurer pour: {}", request.getEmail());
            return ResponseEntity
                    .status(HttpStatus.PRECONDITION_REQUIRED)
                    .body(Map.of(
                        "error", "PASSWORD_SETUP_REQUIRED",
                        "message", e.getMessage(),
                        "email", request.getEmail(),
                        "status", 428
                    ));
        } catch (AuthService.AuthenticationException e) {
            log.warn("Échec de connexion: {}", e.getMessage());
            return ResponseEntity
                    .status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of(
                        "error", "UNAUTHORIZED",
                        "message", e.getMessage(),
                        "status", 401
                    ));
        }
    }

    /**
     * Endpoint de configuration initiale du mot de passe
     * Utilisé lors du premier login
     */
    @PostMapping("/setup-password")
    @Operation(summary = "Configurer le mot de passe initial", description = "Configure le mot de passe lors du premier login")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Mot de passe configuré avec succès"),
        @ApiResponse(responseCode = "400", description = "Mot de passe invalide"),
        @ApiResponse(responseCode = "409", description = "Mot de passe déjà configuré")
    })
    public ResponseEntity<?> setupPassword(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        String newPassword = request.get("newPassword");
        
        if (email == null || newPassword == null) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(Map.of(
                        "error", "BAD_REQUEST",
                        "message", "Email et nouveau mot de passe requis",
                        "status", 400
                    ));
        }
        
        try {
            LoginResponse response = authService.setupPassword(email, newPassword);
            return ResponseEntity.ok(response);
        } catch (AuthService.AuthenticationException e) {
            return ResponseEntity
                    .status(HttpStatus.CONFLICT)
                    .body(Map.of(
                        "error", "CONFLICT",
                        "message", e.getMessage(),
                        "status", 409
                    ));
        }
    }

    /**
     * Endpoint de changement de mot de passe
     * Nécessite un token JWT valide
     * Invalide automatiquement tous les anciens tokens
     */
    @PostMapping("/change-password")
    @Operation(summary = "Changer le mot de passe", description = "Change le mot de passe et invalide les anciens tokens")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Mot de passe changé avec succès"),
        @ApiResponse(responseCode = "401", description = "Non authentifié ou mot de passe actuel incorrect"),
        @ApiResponse(responseCode = "400", description = "Requête invalide")
    })
    public ResponseEntity<?> changePassword(
            @Valid @RequestBody ChangePasswordRequest request,
            Principal principal) {
        
        if (principal == null) {
            return ResponseEntity
                    .status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of(
                        "error", "UNAUTHORIZED",
                        "message", "Non authentifié",
                        "status", 401
                    ));
        }
        
        try {
            authService.changePassword(principal.getName(), request);
            return ResponseEntity.ok(Map.of(
                "message", "Mot de passe changé avec succès",
                "tokenInvalidated", true
            ));
        } catch (AuthService.AuthenticationException e) {
            return ResponseEntity
                    .status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of(
                        "error", "UNAUTHORIZED",
                        "message", e.getMessage(),
                        "status", 401
                    ));
        }
    }

    /**
     * Endpoint de vérification du token
     */
    @GetMapping("/verify")
    @Operation(summary = "Vérifier le token", description = "Vérifie si le token JWT est valide")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Token valide"),
        @ApiResponse(responseCode = "401", description = "Token invalide ou expiré")
    })
    public ResponseEntity<?> verifyToken(Principal principal) {
        if (principal == null) {
            return ResponseEntity
                    .status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of(
                        "valid", false,
                        "error", "Token invalide ou expiré"
                    ));
        }
        
        return ResponseEntity.ok(Map.of(
            "valid", true,
            "email", principal.getName()
        ));
    }

    /**
     * Endpoint de déconnexion (côté client, invalide le token localement)
     */
    @PostMapping("/logout")
    @Operation(summary = "Déconnexion", description = "Déconnecte l'utilisateur (côté client)")
    public ResponseEntity<?> logout() {
        // Le token est invalidé côté client en le supprimant du stockage local
        // Côté serveur, on peut ajouter le token à une blacklist si nécessaire
        return ResponseEntity.ok(Map.of(
            "message", "Déconnexion réussie"
        ));
    }
}
