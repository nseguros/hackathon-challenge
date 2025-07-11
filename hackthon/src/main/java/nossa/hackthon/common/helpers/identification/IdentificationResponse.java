package nossa.hackthon.common.helpers.identification;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class IdentificationResponse {
    private boolean success;
    private String name;
    private String birthDate;
    private String father;
    private String mother;
    private String address;
    private String emittedAt;
    private String type;
}
