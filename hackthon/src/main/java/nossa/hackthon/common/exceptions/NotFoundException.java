package nossa.hackthon.common.exceptions;

import org.springframework.http.HttpStatus;

public class NotFoundException extends BaseException{
    public NotFoundException()  {
        super("Data Not Founded", HttpStatus.NOT_FOUND);
    }

    public NotFoundException(String message)  {
        super(message, HttpStatus.NOT_FOUND);
    }
}