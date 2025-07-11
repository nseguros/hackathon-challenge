package nossa.hackthon.common.helpers.identification;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class ValidateIdentification {

    @Value("${identity.validation}")
    private String baseUrl;

    private final RestTemplate restTemplate;

    public ValidateIdentification(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public IdentificationResponse nif(String identification) {
        String url = this.baseUrl + identification + "/nif";
        return makeRequest(url, "nif validation");
    }

    public IdentificationResponse bi(String identification) {
        String url = this.baseUrl + identification;
        return makeRequest(url, "bi validation");
    }


    private IdentificationResponse makeRequest(String url, String message) {
        ProviderIdentificationResponse providerResponse = restTemplate.getForObject(url, ProviderIdentificationResponse.class);

        if (providerResponse != null) {
            IdentificationResponse response = new IdentificationResponse();
            response.setSuccess(!providerResponse.isError());
            response.setName(providerResponse.getName());
            response.setBirthDate(providerResponse.getData_de_nascimento());
            response.setFather(providerResponse.getPai());
            response.setMother(providerResponse.getMae());
            response.setAddress(providerResponse.getMorada());
            response.setEmittedAt(providerResponse.getEmitido_em());
            response.setType(message);

            return response;
        }
        return null;
    }
}
