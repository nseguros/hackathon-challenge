package nossa.hackthon.modules.insurance;

import lombok.RequiredArgsConstructor;
import nossa.hackthon.common.exceptions.NotFoundException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class InsuranceService {

    private final InsuranceRepository repository;
    private InsuranceCreationDto mapper;

    public Insurance register(InsuranceCreationDto insurance) {
        return repository.save(mapper.mapper(insurance));
    }

    public Page<Insurance> getAll(Pageable pageable) {
        return repository.findAll(pageable);
    }
    public Insurance findByInsuranceId(UUID id) {
        return repository.findById(id).orElseThrow(() -> new NotFoundException("Insurance not found"));
    }
}
