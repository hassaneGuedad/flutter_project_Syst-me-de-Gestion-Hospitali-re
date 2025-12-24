package com.hospital.security;

import com.hospital.model.Utilisateur;
import com.hospital.repository.UtilisateurRepository;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;
import java.util.Optional;

/**
 * Filtre JWT pour l'authentification des requêtes
 * Vérifie le token JWT et la version du mot de passe
 */
@RequiredArgsConstructor
@Slf4j
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtService jwtService;
    private final UtilisateurRepository utilisateurRepository;

    @Override
    protected void doFilterInternal(
            @NonNull HttpServletRequest request,
            @NonNull HttpServletResponse response,
            @NonNull FilterChain filterChain
    ) throws ServletException, IOException {
        
        final String authHeader = request.getHeader("Authorization");
        
        // Pas de header Authorization ou ne commence pas par "Bearer "
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }
        
        try {
            final String jwt = authHeader.substring(7);
            final String email = jwtService.extractEmail(jwt);
            
            // Si l'email est extrait et qu'aucune authentification n'existe déjà
            if (email != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                
                Optional<Utilisateur> optUser = utilisateurRepository.findByEmail(email);
                
                if (optUser.isPresent()) {
                    Utilisateur user = optUser.get();
                    
                    // Vérifie le token avec la version du mot de passe
                    if (jwtService.isTokenValid(jwt, email, user.getPasswordVersion())) {
                        
                        // Crée l'authentification
                        UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                            email,
                            null,
                            Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + user.getRole().name()))
                        );
                        
                        authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                        SecurityContextHolder.getContext().setAuthentication(authToken);
                        
                        log.debug("Utilisateur authentifié: {}", email);
                    } else {
                        log.warn("Token invalide ou mot de passe changé pour: {}", email);
                        // Continue avec la chaîne de filtres - la sécurité décidera si l'accès est permis
                    }
                }
            }
        } catch (Exception e) {
            log.debug("Token JWT non valide ou absent: {}", e.getMessage());
            // Continue avec la chaîne de filtres - les endpoints publics seront accessibles
        }
        
        filterChain.doFilter(request, response);
    }
}
