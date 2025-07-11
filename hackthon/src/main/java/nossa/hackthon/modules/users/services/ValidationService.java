package nossa.hackthon.modules.users.services;

import nossa.hackthon.common.exceptions.ValidationException;
import nossa.hackthon.modules.users.models.RegisterRequest;
import org.springframework.stereotype.Service;

@Service
public class ValidationService {

    /**
     * Validates the registration request.
     * Throws ValidationException if any field is invalid.
     *
     * @param request The registration request to validate
     */
    public void validateRegisterRequest(RegisterRequest request) {
        ValidationException validationException = new ValidationException();

        if (request == null) {
            throw new ValidationException("Registration request cannot be null");
        }

        if (request.getName() == null || request.getName().trim().isEmpty()) {
            validationException.addError("name", "Name is required");
        }

        if (request.getEmail() == null || request.getEmail().trim().isEmpty()) {
            validationException.addError("email", "Email is required");
        } else if (!request.getEmail().matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            validationException.addError("email", "Invalid email format");
        }

        if (request.getPhone() == null || request.getPhone().trim().isEmpty()) {
            validationException.addError("phone", "Phone number is required");
        }

        if (request.getPassword() == null || request.getPassword().trim().isEmpty()) {
            validationException.addError("password", "Password is required");
        } else if (request.getPassword().length() < 6) {
            validationException.addError("password", "Password must be at least 6 characters long");
        }

        if (request.getIdentity() == null || request.getIdentity().trim().isEmpty()) {
            validationException.addError("identity", "Identification (BI) is required");
        }

        if (validationException.hasErrors()) {
            throw validationException;
        }
    }
}