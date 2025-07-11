package nossa.hackthon.common.helpers.identification;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("identification")
public class IdentificationController {

    private final ValidateIdentification service;

    public IdentificationController(ValidateIdentification service) {
        this.service = service;
    }

    @GetMapping("/nif/{nif}")
    public IdentificationResponse nif(@PathVariable String nif) {
       return service.nif(nif);
    }

    @GetMapping("/bi/{bi}")
    public IdentificationResponse bi(@PathVariable String bi) {
        return service.bi(bi);
    }
}
