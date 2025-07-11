package nossa.hackthon.modules.insurance;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

@Component
public class SeederInsurance implements ApplicationRunner {

    private final InsuranceRepository repository;

    public SeederInsurance(InsuranceRepository repository) {
        this.repository = repository;
    }

    @Override
    public void run(ApplicationArguments args) throws Exception {
        seedInsuranceData();
    }

    public void seedInsuranceData() {
        seedIfNotExists("Vida", "Seguro de vida — grupo e individual");
        seedIfNotExists("Saúde", "Seguro de saúde, incluindo Saúde Mwangolé");
        seedIfNotExists("Escolar", "Seguro escolar");
        seedIfNotExists("Automóvel", "Seguro obrigatório de veículos");
    }

    private void seedIfNotExists(String name, String description) {
        boolean exists = repository.existsByName(name);
        if (!exists) {
            Insurance insurance = new Insurance();
            insurance.setName(name);
            insurance.setDescription(description);
            repository.save(insurance);
        }
    }
}

