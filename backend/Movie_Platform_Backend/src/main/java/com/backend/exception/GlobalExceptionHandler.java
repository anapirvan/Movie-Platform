package com.backend.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.stream.Collectors;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(SQLException.class)
    public ResponseEntity<ErrorResponse> handleSQLException(SQLException e) {
        String message = e.getMessage();
        int code = e.getErrorCode();
        String cleanMessage = message.substring(message.indexOf(":") + 2).trim();
        if (cleanMessage.contains("\n")) {
            cleanMessage = cleanMessage.substring(0, cleanMessage.indexOf("\n")).trim();
        }

        if (code == 20001 || code == 20002 || code==20004 || code==20005 ||code==20008 || code==20010 || code==20011) {
            return build(HttpStatus.NOT_FOUND, cleanMessage);
        }
        else if (code==20003){
            return build(HttpStatus.BAD_REQUEST,cleanMessage);
        }
        else if(code==20009){
            return build(HttpStatus.CONFLICT,cleanMessage);
        }

        return build(HttpStatus.INTERNAL_SERVER_ERROR, "Internal server error: " + message);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException e) {
        String message = e.getBindingResult().getFieldErrors().stream()
                .map(err -> err.getField() + ": " + err.getDefaultMessage())
                .collect(Collectors.joining(", "));
        return build(HttpStatus.BAD_REQUEST, message);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneric(Exception e) {
        return build(HttpStatus.INTERNAL_SERVER_ERROR, "Unexpected error: " + e.getMessage());
    }

    private ResponseEntity<ErrorResponse> build(HttpStatus status, String mesaj) {
        ErrorResponse body = new ErrorResponse(status.value(), mesaj, LocalDateTime.now());
        return ResponseEntity.status(status).body(body);
    }

    public record ErrorResponse(int status, String mesaj, LocalDateTime timestamp) {}
}
