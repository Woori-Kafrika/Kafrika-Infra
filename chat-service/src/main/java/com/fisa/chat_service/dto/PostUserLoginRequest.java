package com.fisa.chat_service.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import jakarta.validation.constraints.NotBlank;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class PostUserLoginRequest {

    @NotBlank
    private String id;

    @NotBlank
    private String pw;

}
