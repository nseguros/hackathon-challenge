package nossa.hackthon.modules.auth.services;

import lombok.RequiredArgsConstructor;
import nossa.hackthon.modules.auth.models.AuthRequest;
import nossa.hackthon.modules.auth.models.AuthResponse;
import nossa.hackthon.modules.users.User;
import nossa.hackthon.modules.users.UserRepository;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final AuthenticationManager authenticationManager;
    private final JwtTokenService jwtTokenService;
    private final UserRepository userRepository;
    public AuthResponse authenticate(AuthRequest authRequest) {
        var token = new UsernamePasswordAuthenticationToken(authRequest.getUsername(), authRequest.getPassword());
        Authentication authentication = authenticationManager.authenticate(token);
        String jwtToken = jwtTokenService.generateToken(authentication);
        Long expiresAt = jwtTokenService.extractExpirationTime(jwtToken);
        return new AuthResponse(jwtToken, authentication.getName(), expiresAt);
    }

    public User profile(UUID id)
    {
        return userRepository.findById(id).orElse(null);
    }
}