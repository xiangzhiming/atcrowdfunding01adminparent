package com.atguigu.crowd.exception;

/**
 * 保存或者更新用户时，如果检测到账号重复抛出这个异常
 */
public class LoginAcctAlreadyInUserException extends RuntimeException {

    private static final long serialVersionUID = -1L;

    public LoginAcctAlreadyInUserException() {
    }

    public LoginAcctAlreadyInUserException(String message) {
        super(message);
    }

    public LoginAcctAlreadyInUserException(String message, Throwable cause) {
        super(message, cause);
    }

    public LoginAcctAlreadyInUserException(Throwable cause) {
        super(cause);
    }

    public LoginAcctAlreadyInUserException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
