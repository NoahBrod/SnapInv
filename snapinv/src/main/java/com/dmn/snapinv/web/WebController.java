package com.dmn.snapinv.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class WebController {
    @GetMapping({"/", "/home"})
    public String home() {
        return "index";
    }
    
    @GetMapping("/features")
    public String features() {
        return "main/features";
    }
    
}
