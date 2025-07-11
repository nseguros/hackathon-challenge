package nossa.hackthon.modules.auth.models;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Request model for initiating password reset process.
 * Contains the username (email or phone) to identify the user.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ResetPasswordRequest {
    private String username; // Email or phone
}