package nossa.hackthon.modules.auth.services;

import lombok.RequiredArgsConstructor;
import nossa.hackthon.common.exceptions.ValidationException;
import nossa.hackthon.modules.auth.models.NewPasswordRequest;
import nossa.hackthon.modules.auth.models.OtpValidationRequest;
import nossa.hackthon.modules.auth.models.OtpValidationResponse;
import nossa.hackthon.modules.auth.models.ResetPasswordResponse;
import nossa.hackthon.modules.users.User;
import nossa.hackthon.modules.users.UserRepository;
import nossa.hackthon.modules.users.services.AuthenticationService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class PasswordResetService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenService jwtTokenService;
    private final AuthenticationService authenticationService;

    // In-memory storage for OTPs (in a production environment, this should be replaced with a database or cache)
    private final Map<String, OtpData> otpStorage = new HashMap<>();

    // OTP expiration time in minutes
    private static final int OTP_EXPIRATION_MINUTES = 15;

    /**
     * Initiates the password reset process by generating and sending an OTP.
     *
     * @param username The username (email or phone) to reset password for
     * @return ResetPasswordResponse with a message indicating OTP has been sent
     */
    public ResetPasswordResponse initiatePasswordReset(String username) {
        // Validate username
        if (username == null || username.trim().isEmpty()) {
            throw new ValidationException("Username is required");
        }

        // Find user by email or phone
        Optional<User> userOptional = userRepository.findByEmailOrPhone(username, username);

        if (userOptional.isEmpty()) {
            throw new ValidationException("User not found");
        }

        // Generate OTP
        String otp = generateOtp();

        // Store OTP with expiration time
        otpStorage.put(username, new OtpData(otp, LocalDateTime.now().plusMinutes(OTP_EXPIRATION_MINUTES)));

        // In a real application, send OTP via email or SMS
        // For this simulation, we'll just log it
        System.out.println("OTP for " + username + ": " + otp);

        return new ResetPasswordResponse("OTP has been sent to your email or phone", username);
    }

    /**
     * Validates the OTP and returns a token for password reset.
     *
     * @param request The OTP validation request
     * @return OtpValidationResponse with a token for password reset
     */
    public OtpValidationResponse validateOtp(OtpValidationRequest request) {
        // Validate request
        if (request == null || request.getUsername() == null || request.getOtp() == null) {
            throw new ValidationException("Username and OTP are required");
        }

        String username = request.getUsername();
        String otp = request.getOtp();

        // Check if OTP exists for the username
        if (!otpStorage.containsKey(username)) {
            throw new ValidationException("No OTP request found for this username");
        }

        OtpData otpData = otpStorage.get(username);

        // Check if OTP is expired
        if (otpData.getExpirationTime().isBefore(LocalDateTime.now())) {
            otpStorage.remove(username);
            throw new ValidationException("OTP has expired");
        }

        // Check if OTP matches
        if (!otpData.getOtp().equals(otp)) {
            throw new ValidationException("Invalid OTP");
        }

        // OTP is valid, remove it from storage
        otpStorage.remove(username);

        // Generate a token for password reset
        String token = authenticationService.generateAuthResponse(username).getToken();

        return new OtpValidationResponse(token, "OTP validated successfully");
    }

    /**
     * Resets the password using the provided token and new password.
     *
     * @param request The new password request
     * @param token The reset token from the Authorization header
     * @return A message indicating password has been reset
     */
    public String resetPassword(NewPasswordRequest request, String token) {
        // Validate request
        if (request == null || token == null || request.getNewPassword() == null) {
            throw new ValidationException("Token and new password are required");
        }

        // Validate password
        if (request.getNewPassword().length() < 6) {
            throw new ValidationException("Password must be at least 6 characters long");
        }

        // Extract username from token
        String username = jwtTokenService.extractUsername(token);

        // Find user
        Optional<User> userOptional = userRepository.findByEmailOrPhone(username, username);

        if (userOptional.isEmpty()) {
            throw new ValidationException("User not found");
        }

        User user = userOptional.get();

        // Update password
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        user.setUpdatedAt(LocalDateTime.now());

        // Save user
        userRepository.save(user);

        return "Password has been reset successfully";
    }

    /**
     * Generates a random 5-digit alphanumeric OTP.
     *
     * @return A 5-digit alphanumeric OTP
     */
    private String generateOtp() {
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder otp = new StringBuilder();
        SecureRandom random = new SecureRandom();

        for (int i = 0; i < 5; i++) {
            otp.append(characters.charAt(random.nextInt(characters.length())));
        }

        return otp.toString();
    }

    /**
     * Inner class to store OTP data with expiration time.
     */
    private static class OtpData {
        private final String otp;
        private final LocalDateTime expirationTime;

        public OtpData(String otp, LocalDateTime expirationTime) {
            this.otp = otp;
            this.expirationTime = expirationTime;
        }

        public String getOtp() {
            return otp;
        }

        public LocalDateTime getExpirationTime() {
            return expirationTime;
        }
    }
}
