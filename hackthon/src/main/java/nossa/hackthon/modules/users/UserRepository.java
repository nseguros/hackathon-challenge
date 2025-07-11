package nossa.hackthon.modules.users;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID> {
    Optional<User> findByEmailOrPhone(String email, String phone);
    Optional<User> findByIdentity(String phone);

    boolean existsByEmailOrPhone(String email, String phone);
}
