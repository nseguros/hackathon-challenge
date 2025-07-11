package nossa.hackthon.modules.auth.services;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.jose.jws.SignatureAlgorithm;
import org.springframework.security.oauth2.jwt.*;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.temporal.ChronoUnit;

@Service
@RequiredArgsConstructor
public class JwtTokenService {

    private final JwtEncoder encoder;
    private final JwtDecoder decoder;
    public String generateToken(Authentication authentication) {
        Instant now = Instant.now();
        String scope = "ROLE_ADMIN";
        JwtClaimsSet claims = JwtClaimsSet.builder()
                .issuer("self")
                .issuedAt(now)
                .expiresAt(now.plus(1, ChronoUnit.HOURS))
                .subject(authentication.getName())
                .claim("scope", scope)
                .build();
        var encoderParameters = JwtEncoderParameters.from(JwsHeader.with(SignatureAlgorithm.RS256).build(), claims);
        return this.encoder.encode(encoderParameters).getTokenValue();
    }
    public Long extractExpirationTime(String token) {
        Jwt jwt = decoder.decode(token);
        var exp = (Instant) jwt.getClaim("exp");
        return exp.toEpochMilli();
    }
    /**
     * Extracts the username (subject) from a JWT token.
     *
     * @param token The JWT token
     * @return The username
     */
    public String extractUsername(String token) {
        Jwt jwt = decoder.decode(token);
        return jwt.getSubject();
    }
}
