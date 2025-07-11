package nossa.hackthon.infra.http;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import nossa.hackthon.modules.auth.models.AuthRequest;
import nossa.hackthon.modules.auth.models.AuthResponse;
import nossa.hackthon.modules.auth.models.AuthUser;
import nossa.hackthon.modules.auth.services.AuthService;
import nossa.hackthon.modules.users.User;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("auth")
@Tag(name = "Authentication", description = "Authentication API")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @Operation(summary = "Authenticate user", description = "Authenticates a user and returns a JWT token")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Successfully authenticated",
                content = @Content(mediaType = "application/json", 
                schema = @Schema(implementation = AuthResponse.class))),
        @ApiResponse(responseCode = "401", description = "Invalid credentials", 
                content = @Content)
    })
    @PostMapping("/login")
    public AuthResponse login(
            @Parameter(description = "Authentication request with username and password", required = true)
            @RequestBody AuthRequest authRequest) {
        return authService.authenticate(authRequest);
    }

    @PostMapping("/profile")
    public ResponseEntity<User> profile(@AuthenticationPrincipal AuthUser authUser)
    {
        var user = authService.profile(authUser.getUser().getId());
        user.setPassword(null);
        return ResponseEntity.ok(user);
    }
}
