package nossa.hackthon.modules.users.services;

import lombok.RequiredArgsConstructor;
import nossa.hackthon.common.exceptions.InvalidIdentificationException;
import nossa.hackthon.common.helpers.identification.IdentificationResponse;
import nossa.hackthon.common.helpers.identification.ValidateIdentification;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class IdentificationService {

    private final ValidateIdentification validateIdentification;

    /**
     * Validates a BI (Bilhete de Identidade) number.
     * Throws InvalidIdentificationException if the BI is invalid.
     *
     * @param identityNumber The BI number to validate
     * @return The validated identification response
     */
    public IdentificationResponse validateBi(String identityNumber) {
        try {
            IdentificationResponse identificationResponse = validateIdentification.bi(identityNumber);

            if (identificationResponse == null || !identificationResponse.isSuccess()) {
                throw new InvalidIdentificationException();
            }
            
            return identificationResponse;
        } catch (Exception e) {
            if (e instanceof InvalidIdentificationException) {
                throw e;
            }
            throw new InvalidIdentificationException("Error validating identification", e);
        }
    }
}