package com.fisa.chat_service.common.response.status;

import org.springframework.http.HttpStatus;

public interface ResponseStatus {

    int getCode();

    HttpStatus getStatus();

    String getMessage();
}