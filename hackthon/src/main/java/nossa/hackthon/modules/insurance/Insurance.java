package nossa.hackthon.modules.insurance;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import nossa.hackthon.common.GenericValues;

@Entity
@Table(name = "nossa_insurance")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class Insurance extends GenericValues {

    private String name;
    private String description;
}
