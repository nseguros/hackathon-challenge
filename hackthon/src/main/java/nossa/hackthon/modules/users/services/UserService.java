package nossa.hackthon.modules.users.services;

import lombok.RequiredArgsConstructor;
import nossa.hackthon.common.exceptions.ServiceException;
import nossa.hackthon.common.exceptions.UserAlreadyExistsException;
import nossa.hackthon.modules.auth.models.AuthResponse;
import nossa.hackthon.modules.users.User;
import nossa.hackthon.modules.users.UserRepository;
import nossa.hackthon.modules.users.models.RegisterRequest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

/**
 * Service responsible for user management operations.
 * Following the Single Responsibility Principle, this service focuses only on user management,
 * delegating validation, authentication, and identification to specialized services.
 */
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final ValidationService validationService;
    private final IdentificationService identificationService;
    private final AuthenticationService authenticationService;

    /**
     * Registers a new user with validation and returns authentication token.
     *
     * @param registerRequest The registration request with user details
     * @return AuthResponse containing JWT token and expiration time
     */
    public AuthResponse registerUser(RegisterRequest registerRequest) {
        // Validate input parameters
        validationService.validateRegisterRequest(registerRequest);

        // Check if user already exists
        Optional<User> existingUser = getUser(registerRequest);

        Optional<User> existingUserByIdentity = getUserByIdentity(registerRequest);

        if (existingUser.isPresent()  || existingUserByIdentity.isPresent()) {
            throw new UserAlreadyExistsException();
        }

        if(registerRequest.getIdentity_type().equals("BI")) {

            identificationService.validateBi(registerRequest.getIdentity());
        }

        // Create new user
        User user = new User();
        user.setName(registerRequest.getName());
        user.setEmail(registerRequest.getEmail());
        user.setPhone(registerRequest.getPhone());
        user.setPassword(passwordEncoder.encode(registerRequest.getPassword()));
        user.setIdentity(registerRequest.getIdentity());
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        user.setIdentity_type(registerRequest.getIdentity_type());
        try {
            // Save user
            userRepository.save(user);

            // Generate auth response with token
            return authenticationService.generateAuthResponse(user.getEmail());
        } catch (Exception e) {
            throw new ServiceException("Error registering user: " + e.getMessage(), e);
        }
    }

    private Optional<User> getUser(RegisterRequest registerRequest) {
        return userRepository.findByEmailOrPhone(
                registerRequest.getEmail(), registerRequest.getPhone());
    }

    private Optional<User> getUserByIdentity(RegisterRequest registerRequest) {
        return userRepository.findByIdentity(registerRequest.getIdentity());
    }

    /**
     * Find a user by email
     *
     * @param email The email to search for
     * @return Optional containing the user if found
     */
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmailOrPhone(email, null);
    }

    /**
     * Find a user by ID
     *
     * @param id The user ID
     * @return Optional containing the user if found
     */
    public Optional<User> findById(UUID id) {
        return userRepository.findById(id);
    }

    /**
     * Save a user
     *
     * @param user The user to save
     * @return The saved user
     */
    public User save(User user) {
        if (user.getCreatedAt() == null) {
            user.setCreatedAt(LocalDateTime.now());
        }
        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }
}
