package nossa.hackthon.common.exceptions;

import org.springframework.http.HttpStatus;

/**
 * Exception thrown when a service operation fails.
 * This could be due to database errors, external service failures, etc.
 */
public class ServiceException extends BaseException {

    /**
     * Constructor with default message.
     */
    public ServiceException() {
        super("Service operation failed", HttpStatus.INTERNAL_SERVER_ERROR);
    }

    /**
     * Constructor with custom message.
     *
     * @param message Custom error message
     */
    public ServiceException(String message) {
        super(message, HttpStatus.INTERNAL_SERVER_ERROR);
    }

    /**
     * Constructor with message and cause.
     *
     * @param message Custom error message
     * @param cause Cause of the exception
     */
    public ServiceException(String message, Throwable cause) {
        super(message, cause, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}