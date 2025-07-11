package nossa.hackthon.modules.auth.models;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Request model for setting a new password after successful OTP validation.
 * Contains only the new password. The token is passed in the Authorization header.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class NewPasswordRequest {
    private String newPassword; // New password to set
}
