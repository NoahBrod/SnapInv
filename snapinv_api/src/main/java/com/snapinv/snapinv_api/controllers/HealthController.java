package com.snapinv.snapinv_api.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HealthController {
    @GetMapping("/health")
    public String healthCheck() {
        return "OK";
    }
}
