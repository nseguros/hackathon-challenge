package nossa.hackthon.modules.insurance;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class InsuranceCreationDto {
    private String name;
    private String description;


    public Insurance mapper(InsuranceCreationDto insurance) {
        return new Insurance(insurance.name, insurance.description);
    }
}
