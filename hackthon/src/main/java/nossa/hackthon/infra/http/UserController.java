package nossa.hackthon.infra.http;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import nossa.hackthon.modules.auth.models.AuthResponse;
import nossa.hackthon.modules.users.models.RegisterRequest;
import nossa.hackthon.modules.users.services.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("users")
@RequiredArgsConstructor
@Tag(name = "Users", description = "User management API")
public class UserController {

    private final UserService userService;

    @Operation(summary = "Register new user", description = "Registers a new user with BI validation and returns a JWT token")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "User successfully registered",
                content = @Content(mediaType = "application/json", 
                schema = @Schema(implementation = AuthResponse.class))),
        @ApiResponse(responseCode = "400", description = "Invalid input or BI validation failed", 
                content = @Content),
        @ApiResponse(responseCode = "409", description = "User already exists", 
                content = @Content)
    })
    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(
            @Parameter(description = "Registration details with user information and BI", required = true)
            @RequestBody RegisterRequest registerRequest) {
            AuthResponse response = userService.registerUser(registerRequest);
            return new ResponseEntity<>(response, HttpStatus.CREATED);
    }
}