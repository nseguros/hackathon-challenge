package nossa.hackthon.common.helpers.identification;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Class representing the response format from the identification provider.
 */
@Getter
@Setter
@NoArgsConstructor
public class ProviderIdentificationResponse {
    private boolean error;
    private String name;
    private String data_de_nascimento;
    private String pai;
    private String mae;
    private String morada;
    private String emitido_em;
    private String type;
}