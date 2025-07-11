package nossa.hackthon.modules.users;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

/**
 * Repository for managing Role entities
 */
@Repository
public interface RoleRepository extends JpaRepository<Role, UUID> {
    
    /**
     * Find a role by its name
     * 
     * @param name The role name
     * @return Optional containing the role if found
     */
    Optional<Role> findByName(String name);

    boolean existsByName(String name);
}