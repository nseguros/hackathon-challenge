package nossa.hackthon.common.exceptions;

import org.springframework.http.HttpStatus;

import java.util.HashMap;
import java.util.Map;

/**
 * Exception thrown when validation of input data fails.
 * Can contain multiple validation errors.
 */
public class ValidationException extends BaseException {
    private final Map<String, String> errors;

    /**
     * Constructor with default message.
     */
    public ValidationException() {
        super("Validation failed", HttpStatus.BAD_REQUEST);
        this.errors = new HashMap<>();
    }

    /**
     * Constructor with custom message.
     *
     * @param message Custom error message
     */
    public ValidationException(String message) {
        super(message, HttpStatus.BAD_REQUEST);
        this.errors = new HashMap<>();
    }

    /**
     * Constructor with message and validation errors.
     *
     * @param message Custom error message
     * @param errors Map of field names to error messages
     */
    public ValidationException(String message, Map<String, String> errors) {
        super(message, HttpStatus.BAD_REQUEST);
        this.errors = errors;
    }

    /**
     * Add a validation error for a specific field.
     *
     * @param field Field name
     * @param error Error message
     * @return This exception instance for method chaining
     */
    public ValidationException addError(String field, String error) {
        this.errors.put(field, error);
        return this;
    }

    /**
     * Get all validation errors.
     *
     * @return Map of field names to error messages
     */
    public Map<String, String> getErrors() {
        return errors;
    }

    /**
     * Check if there are any validation errors.
     *
     * @return true if there are validation errors, false otherwise
     */
    public boolean hasErrors() {
        return !errors.isEmpty();
    }
}