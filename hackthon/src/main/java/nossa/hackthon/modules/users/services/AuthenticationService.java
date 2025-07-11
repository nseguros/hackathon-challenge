package nossa.hackthon.modules.users.services;

import lombok.RequiredArgsConstructor;
import nossa.hackthon.modules.auth.models.AuthResponse;
import nossa.hackthon.modules.auth.services.JwtTokenService;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Service;

import java.util.Collections;

@Service
@RequiredArgsConstructor
public class AuthenticationService {

    private final JwtTokenService jwtTokenService;

    /**
     * Creates an authentication token for the given username.
     *
     * @param username The username to create the token for
     * @return The created authentication token
     */
    public Authentication createAuthenticationToken(String username) {
        return new UsernamePasswordAuthenticationToken(
                username,
                null,
                Collections.singletonList(new SimpleGrantedAuthority("ROLE_USER"))
        );
    }

    /**
     * Generates a JWT token and creates an AuthResponse.
     *
     * @param username The username to generate the token for
     * @return The AuthResponse containing the token and expiration time
     */
    public AuthResponse generateAuthResponse(String username) {
        Authentication authentication = createAuthenticationToken(username);
        String token = jwtTokenService.generateToken(authentication);
        Long expiresAt = jwtTokenService.extractExpirationTime(token);

        return new AuthResponse(token, username, expiresAt);
    }
}