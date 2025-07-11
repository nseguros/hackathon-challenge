package nossa.hackthon.modules.auth;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import nossa.hackthon.modules.auth.models.*;
import nossa.hackthon.modules.auth.services.PasswordResetService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("auth/reset-password")
@RequiredArgsConstructor
@Tag(name = "Password Reset", description = "Password Reset API")
public class ResetPasswordController {

    private final PasswordResetService passwordResetService;

    @Operation(summary = "Request password reset", description = "Validates username and sends OTP")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OTP sent successfully",
                content = @Content(mediaType = "application/json", 
                schema = @Schema(implementation = ResetPasswordResponse.class))),
        @ApiResponse(responseCode = "400", description = "Invalid username or user not found", 
                content = @Content)
    })
    @PostMapping("/request")
    public ResponseEntity<ResetPasswordResponse> requestPasswordReset(
            @Parameter(description = "Reset password request with username", required = true)
            @RequestBody ResetPasswordRequest request) {
        ResetPasswordResponse response = passwordResetService.initiatePasswordReset(request.getUsername());
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "Validate OTP", description = "Validates OTP and returns token for password reset")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OTP validated successfully",
                content = @Content(mediaType = "application/json", 
                schema = @Schema(implementation = OtpValidationResponse.class))),
        @ApiResponse(responseCode = "400", description = "Invalid OTP or expired", 
                content = @Content)
    })
    @PostMapping("/validate-otp")
    public ResponseEntity<OtpValidationResponse> validateOtp(
            @Parameter(description = "OTP validation request with username and OTP", required = true)
            @RequestBody OtpValidationRequest request) {
        OtpValidationResponse response = passwordResetService.validateOtp(request);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "Reset password", description = "Resets password using token from Authorization header")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Password reset successfully",
                content = @Content(mediaType = "application/json")),
        @ApiResponse(responseCode = "400", description = "Invalid token or password", 
                content = @Content)
    })
    @PostMapping("/reset")
    public ResponseEntity<String> resetPassword(
            @Parameter(description = "New password request with new password", required = true)
            @RequestBody NewPasswordRequest request,
            @Parameter(description = "Authorization token", required = true)
            @RequestHeader("Authorization") String token) {
        // Remove "Bearer " prefix if present
        if (token.startsWith("Bearer ")) {
            token = token.substring(7);
        }
        String response = passwordResetService.resetPassword(request, token);
        return ResponseEntity.ok(response);
    }
}
