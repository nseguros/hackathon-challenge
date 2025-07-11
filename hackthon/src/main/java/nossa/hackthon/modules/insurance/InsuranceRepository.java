package nossa.hackthon.modules.insurance;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface InsuranceRepository extends JpaRepository<Insurance, UUID> {
    boolean existsByName(String name);
}
