package com.atguigu.crowd.exception;

/**
 * 提交修改的用户，如果用户账号重复，抛出此异常
 */
public class LoginAcctAlreadyInUserForUpdateException extends RuntimeException {

    private static final long serialVersionUID = -1L;

    public LoginAcctAlreadyInUserForUpdateException() {
    }

    public LoginAcctAlreadyInUserForUpdateException(String message) {
        super(message);
    }

    public LoginAcctAlreadyInUserForUpdateException(String message, Throwable cause) {
        super(message, cause);
    }

    public LoginAcctAlreadyInUserForUpdateException(Throwable cause) {
        super(cause);
    }

    public LoginAcctAlreadyInUserForUpdateException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
