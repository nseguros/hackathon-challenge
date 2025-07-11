package nossa.hackthon.modules.users.services;

import lombok.RequiredArgsConstructor;
import nossa.hackthon.modules.users.Role;
import nossa.hackthon.modules.users.RoleRepository;
import nossa.hackthon.modules.users.User;
import org.springframework.stereotype.Service;

import java.util.Optional;

/**
 * Service responsible for role management operations.
 */
@Service
@RequiredArgsConstructor
public class RoleService {

    private final RoleRepository roleRepository;

    /**
     * Find a role by name or create it if it doesn't exist
     *
     * @param name The role name
     * @param description The role description
     * @return The role
     */
    public Role findOrCreateRole(String name, String description) {
        return roleRepository.findByName(name)
                .orElseGet(() -> {
                    Role role = new Role();
                    role.setName(name);
                    role.setDescription(description);
                    return roleRepository.save(role);
                });
    }

    /**
     * Find a role by name
     *
     * @param name The role name
     * @return Optional containing the role if found
     */
    public Optional<Role> findByName(String name) {
        return roleRepository.findByName(name);
    }

    /**
     * Assign a role to a user
     *
     * @param user The user
     * @param role The role
     */
    public void assignRoleToUser(User user, Role role) {
        user.addRole(role);
    }
}