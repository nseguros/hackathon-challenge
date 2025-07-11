package nossa.hackthon.common.exceptions;

import org.springframework.http.HttpStatus;

/**
 * Base exception class for all application exceptions.
 * Provides common functionality for all exceptions.
 */
public abstract class BaseException extends RuntimeException {
    private final HttpStatus status;

    /**
     * Constructor with message and HTTP status.
     *
     * @param message Error message
     * @param status HTTP status code
     */
    public BaseException(String message, HttpStatus status) {
        super(message);
        this.status = status;
    }

    /**
     * Constructor with message, cause, and HTTP status.
     *
     * @param message Error message
     * @param cause Cause of the exception
     * @param status HTTP status code
     */
    public BaseException(String message, Throwable cause, HttpStatus status) {
        super(message, cause);
        this.status = status;
    }

    /**
     * Get the HTTP status associated with this exception.
     *
     * @return HTTP status
     */
    public HttpStatus getStatus() {
        return status;
    }
}