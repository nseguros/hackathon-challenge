package nossa.hackthon.common.exceptions;

import org.springframework.http.HttpStatus;

/**
 * Exception thrown when the provided identification (BI) is invalid or cannot be verified.
 */
public class InvalidIdentificationException extends BaseException {

    /**
     * Constructor with default message.
     */
    public InvalidIdentificationException() {
        super("Invalid identification (BI)", HttpStatus.BAD_REQUEST);
    }

    /**
     * Constructor with custom message.
     *
     * @param message Custom error message
     */
    public InvalidIdentificationException(String message) {
        super(message, HttpStatus.BAD_REQUEST);
    }

    /**
     * Constructor with message and cause.
     *
     * @param message Custom error message
     * @param cause Cause of the exception
     */
    public InvalidIdentificationException(String message, Throwable cause) {
        super(message, cause, HttpStatus.BAD_REQUEST);
    }
}