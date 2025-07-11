package nossa.hackthon.modules.auth.models;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Request model for validating OTP during password reset process.
 * Contains the username and OTP code.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OtpValidationRequest {
    private String username; // Email or phone
    private String otp; // 5-digit alphanumeric OTP
}