package nossa.hackthon.modules.auth.services;

import lombok.RequiredArgsConstructor;
import nossa.hackthon.modules.auth.models.AuthUser;
import nossa.hackthon.modules.users.User;
import nossa.hackthon.modules.users.UserRepository;
import org.springframework.core.convert.converter.Converter;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class CustomJwtAuthenticationConverter implements Converter<Jwt, AbstractAuthenticationToken> {

    private final UserRepository userRepository;

    @Override
    public AbstractAuthenticationToken convert(Jwt jwt) {
        String username = jwt.getSubject();

        User user = userRepository.findByEmailOrPhone(username, username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username));

        AuthUser authUser = new AuthUser(user);

        return new UsernamePasswordAuthenticationToken(
                authUser,
                null,
                authUser.getAuthorities()
        );
    }
}
