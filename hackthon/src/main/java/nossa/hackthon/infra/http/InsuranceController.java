package nossa.hackthon.infra.http;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import nossa.hackthon.modules.insurance.Insurance;
import nossa.hackthon.modules.insurance.InsuranceService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("insurence")
@RequiredArgsConstructor
@Tag(name = "Insurance", description = "Insurance management API")
public class InsuranceController {

    private final InsuranceService service;


    @GetMapping
    public ResponseEntity<Page<Insurance>> getAllInsurance(
            @RequestParam(defaultValue = "0") int pag,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "id") String orderBy)
    {
        Pageable pageable = PageRequest.of(pag, size, Sort.by(orderBy));
        return ResponseEntity.ok(service.getAll(pageable));
    }
}
