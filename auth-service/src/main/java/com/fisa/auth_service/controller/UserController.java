package com.fisa.auth_service.controller;

import static com.fisa.auth_service.common.response.status.BaseExceptionResponseStatus.INVALID_USER_LOGIN;
import static com.fisa.auth_service.common.response.status.BaseExceptionResponseStatus.INVALID_USER_SIGNUP;
import static com.fisa.auth_service.common.util.BindingResultUtils.getErrorMessage;

import com.fisa.auth_service.common.exception.CustomException;
import com.fisa.auth_service.common.response.BaseResponse;
import com.fisa.auth_service.common.response.SuccessResponse;
import com.fisa.auth_service.dto.PostUserLoginRequest;
import com.fisa.auth_service.dto.PostUserLoginResponse;
import com.fisa.auth_service.dto.PostUserSignupRequest;
import com.fisa.auth_service.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/user")
public class UserController {

    private final UserService userService;

    @PostMapping("/signup")
    public BaseResponse<SuccessResponse> signup(@Validated @RequestBody PostUserSignupRequest postUserSignupRequest, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            throw new CustomException(INVALID_USER_SIGNUP, getErrorMessage(bindingResult));
        }

        userService.signup(postUserSignupRequest);

        return new BaseResponse<>(new SuccessResponse(true));
    }

    @PostMapping("/login")
    public BaseResponse<PostUserLoginResponse> login(@Validated @RequestBody PostUserLoginRequest postUserLoginRequest, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            throw new CustomException(INVALID_USER_LOGIN, getErrorMessage(bindingResult));
        }

        long userId = userService.login(postUserLoginRequest);

        return new BaseResponse<>(new PostUserLoginResponse(userId));
    }
}
