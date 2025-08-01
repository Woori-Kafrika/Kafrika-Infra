package com.fisa.chat_service.common.exception;

import com.fisa.chat_service.common.response.status.ResponseStatus;
import lombok.Getter;

@Getter
public class CustomException extends RuntimeException{

    private final ResponseStatus exceptionStatus;

    public CustomException(ResponseStatus exceptionStatus) {
        super(exceptionStatus.getMessage());
        this.exceptionStatus = exceptionStatus;
    }

    public CustomException(ResponseStatus exceptionStatus, String message) {
        super(message);
        this.exceptionStatus = exceptionStatus;
    }
}
