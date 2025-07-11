package nossa.hackthon.modules.auth.models;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Response model for the OTP validation request.
 * Contains a token that can be used to reset the password.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OtpValidationResponse {
    private String token;
    private String message;
}