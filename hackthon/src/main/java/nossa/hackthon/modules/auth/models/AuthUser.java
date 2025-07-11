package nossa.hackthon.modules.auth.models;

import lombok.RequiredArgsConstructor;
import nossa.hackthon.modules.users.Role;
import nossa.hackthon.modules.users.User;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Implementation of Spring Security's UserDetails interface.
 * Wraps a User entity and provides authentication and authorization details.
 */
@RequiredArgsConstructor
public class AuthUser implements UserDetails {

    private final User user;

    @Override
    public String getUsername() { return user.getEmail(); }

    @Override
    public String getPassword() { return user.getPassword(); }

    /**
     * Returns the authorities granted to the user based on their roles.
     * 
     * @return A collection of GrantedAuthority objects
     */
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        if (user.getRoles() == null || user.getRoles().isEmpty()) {
            return List.of();
        }

        return user.getRoles().stream()
                .map(Role::getName)
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toList());
    }

    @Override
    public boolean isAccountNonExpired() { return true; }

    @Override
    public boolean isAccountNonLocked() { return true; }

    @Override
    public boolean isCredentialsNonExpired() { return true; }

    @Override
    public boolean isEnabled() { 
        return true;
    }

    /**
     * Returns the wrapped user entity
     * 
     * @return The User entity
     */
    public User getUser() {
        return user;
    }
}
