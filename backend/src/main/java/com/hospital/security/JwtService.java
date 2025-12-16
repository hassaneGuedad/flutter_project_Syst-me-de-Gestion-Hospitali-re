package com.hospital.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

/**
 * Service JWT pour la génération et validation des tokens
 * Les tokens sont invalidés automatiquement si le mot de passe change (via passwordVersion)
 */
@Component
public class JwtService {

    @Value("${jwt.secret:hospital-secret-key-minimum-256-bits-pour-hs256-algorithme-securise}")
    private String secretKey;

    @Value("${jwt.expiration:86400000}") // 24 heures par défaut
    private long jwtExpiration;

    /**
     * Extrait l'email du token JWT
     */
    public String extractEmail(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    /**
     * Extrait la version du mot de passe du token
     * Utilisé pour invalider les tokens après changement de mot de passe
     */
    public Integer extractPasswordVersion(String token) {
        return extractClaim(token, claims -> claims.get("pwdVersion", Integer.class));
    }

    /**
     * Extrait une claim spécifique du token
     */
    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    /**
     * Génère un token JWT avec la version du mot de passe
     */
    public String generateToken(String email, String role, Integer passwordVersion) {
        Map<String, Object> extraClaims = new HashMap<>();
        extraClaims.put("role", role);
        extraClaims.put("pwdVersion", passwordVersion);
        return generateToken(extraClaims, email);
    }

    /**
     * Génère un token JWT avec des claims personnalisées
     */
    public String generateToken(Map<String, Object> extraClaims, String email) {
        return Jwts.builder()
                .claims(extraClaims)
                .subject(email)
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + jwtExpiration))
                .signWith(getSignInKey(), Jwts.SIG.HS256)
                .compact();
    }

    /**
     * Vérifie si le token est valide pour l'utilisateur
     * Vérifie aussi la version du mot de passe
     */
    public boolean isTokenValid(String token, String email, Integer currentPasswordVersion) {
        final String tokenEmail = extractEmail(token);
        final Integer tokenPasswordVersion = extractPasswordVersion(token);
        
        // Le token est invalide si:
        // 1. L'email ne correspond pas
        // 2. Le token est expiré
        // 3. La version du mot de passe ne correspond pas (mot de passe changé)
        return tokenEmail.equals(email) 
                && !isTokenExpired(token)
                && (tokenPasswordVersion == null || tokenPasswordVersion.equals(currentPasswordVersion));
    }

    /**
     * Vérifie si le token est expiré
     */
    public boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    /**
     * Extrait la date d'expiration du token
     */
    private Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    /**
     * Extrait toutes les claims du token
     */
    private Claims extractAllClaims(String token) {
        return Jwts.parser()
                .verifyWith(getSignInKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    /**
     * Retourne la clé de signature
     */
    private SecretKey getSignInKey() {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    /**
     * Retourne la durée d'expiration en millisecondes
     */
    public long getExpirationTime() {
        return jwtExpiration;
    }
}
