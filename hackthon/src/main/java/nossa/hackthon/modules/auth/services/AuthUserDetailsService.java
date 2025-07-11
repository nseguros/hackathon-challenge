package nossa.hackthon.modules.auth.services;

import lombok.RequiredArgsConstructor;
import nossa.hackthon.modules.auth.models.AuthUser;
import nossa.hackthon.modules.users.UserRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
@Service
@RequiredArgsConstructor
public class AuthUserDetailsService implements UserDetailsService {
    private final UserRepository userRepository;
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return userRepository.findByEmailOrPhone(username, username).map(AuthUser::new)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username));
    }
}
