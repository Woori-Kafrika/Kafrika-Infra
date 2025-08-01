package com.fisa.chat_service.dto;

import lombok.Getter;

@Getter
public class ChatMessageRequest {

    private Long userId;

    private String message;

    private String sendAt;
}
