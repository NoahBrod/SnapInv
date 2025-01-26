package com.snapinv.snapinv_api.controllers;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HealthController {
    @GetMapping("/health")
    public ResponseEntity<String> healthCheck() {
        return new ResponseEntity<>("OK", HttpStatus.OK);
    }
}
