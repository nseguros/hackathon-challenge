package nossa.hackthon.common.exceptions;

import org.springframework.http.HttpStatus;

/**
 * Exception thrown when attempting to register a user with an email or phone
 * that already exists in the system.
 */
public class UserAlreadyExistsException extends BaseException {

    /**
     * Constructor with default message.
     */
    public UserAlreadyExistsException() {
        super("User with this email or phone already exists", HttpStatus.CONFLICT);
    }

    /**
     * Constructor with custom message.
     *
     * @param message Custom error message
     */
    public UserAlreadyExistsException(String message) {
        super(message, HttpStatus.CONFLICT);
    }

    /**
     * Constructor with message and cause.
     *
     * @param message Custom error message
     * @param cause Cause of the exception
     */
    public UserAlreadyExistsException(String message, Throwable cause) {
        super(message, cause, HttpStatus.CONFLICT);
    }
}