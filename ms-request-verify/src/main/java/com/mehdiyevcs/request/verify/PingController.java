package com.mehdiyevcs.request.verify;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Objects;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class PingController {

    @GetMapping("/ping")
    public String ping() {
        return "Hello from, ms-request-verify";
    }

    @PostMapping("/request-log")
    public void logRequest(
            @RequestHeader(value = "x-request-id", required = false) String requestId,
            @RequestBody(required = false) Object obj) {
        log.info("Request id is {} and requestBody is {} ", requestId,
                Objects.isNull(obj) ? null : obj.toString());
    }

    @PostMapping("/response-log")
    public void logResponse(
            @RequestHeader(value = "x-request-id", required = false) String requestId,
            @RequestBody(required = false) Object obj) {
        log.info("Request id is {} and responseBody is {} ", requestId,
                Objects.isNull(obj) ? null : obj.toString());
    }
}
